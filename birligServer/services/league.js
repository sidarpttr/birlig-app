const mongoose = require("mongoose");
const {
    LeagueProfile,
    League,
    Match,
    Puan,
} = require("../models/league.model");
const Player = require("../models/player.model");
const CustomError = require("../utils/CustomError");

const createLeague = async (name, playerId) => {

    const session = await mongoose.startSession();
    session.startTransaction();
    try {
        //puan tablosu oluştur
        const puanTablosu = new Puan();
    
        //ligi oluştur
        const newLeague = new League({name: name, puanTablosu: puanTablosu});
        const savedLeague = await newLeague.save({session});
        
        //lig profilil oluşturur ve lige ekler
        const profile = new LeagueProfile({player: playerId, league: savedLeague._id});
        const savedProfile = await profile.save({session});
        newLeague.players.push(savedProfile._id);

        //puan tablosunun ligine belirle
        puanTablosu.league = savedLeague._id;
        puanTablosu.siralama.push(savedProfile._id);
        await puanTablosu.save({session: session});

        await session.commitTransaction();
        return savedLeague;

    } catch (error) {
        await session.abortTransaction();
        throw error;
    }finally{
        session.endSession();
    }

    //const puanTablosu = new Puan();
    //await puanTablosu.save();
    //const league = new League({ name: name, puanTablosu: puanTablosu._id });
    //await Player.updateOne({playerId}, {ligler: {$push: }});
    //const savedLeague = await league.save();
    //await Puan.updateOne({ _id: puanTablosu._id }, { league: savedLeague._id });
    //return savedLeague;
};

const createLeagueProfile = async (playerid, leagueid) => {
    const leagueProfile = new LeagueProfile({
        player: playerid,
        league: leagueid,
    });
    const saved = await leagueProfile.save();

    return saved;
};

const addPlayerToLeague = async (leagueid, playerid) => {
    const session = await mongoose.startSession();
    session.startTransaction();
    try {
        const league = await League.findById(leagueid).session(session);
        const player = await Player.findById(playerid).session(session);

        if (!league || !player)
            throw new CustomError("lig veya oyuncu bulunamadı", 404);

        if (player.ligler.includes(league._id))
            throw new CustomError("Oyuncu zaten bu ligte", 400);

        const leagueProfile = await createLeagueProfile(playerid, leagueid);

        await Puan.updateOne(
            { league: leagueid },
            { $push: { siralama: leagueProfile } },
            { session }
        );
        league.players.push(leagueProfile);
        player.ligler.push(league);

        await player.save({ session });
        const saved = await league.save({ session });

        await session.commitTransaction();
        return saved;
    } catch (error) {
        await session.abortTransaction();
        throw error;
    } finally {
        session.endSession();
    }
};

const getAllLeagues = async () => {
    const leagues = await League.find().select("-maclar -players -puanTablosu");
    return leagues;
};

const getLeagueById = async (id) => {
    const league = await League.findById(id)
        .populate({
            path: "maclar",
            select: "-league",
            populate: { path: "players", select: "name" },
        })
        .populate({
            path: "puanTablosu",
            select: "-league",
            populate: {
                path: "siralama",
                select: "-league",
                populate: { path: "player", select: "name" },
            },
        })
        .select("-players");
    if (!league) throw new CustomError("lig bulunamadı", 404);
    return league;
};

const getProfileById = async (profileId) => {
    console.log(profileId);
    const profile = await LeagueProfile.findById(profileId)
        .populate({
            path: "player",
            model: "Player",
            select: "name",
        })
        .populate({ path: "league", select: "name" });

    return profile;
};

const removeFromLeague = async (leagueid, playerid) => {
    const session = await mongoose.startSession();
    session.startTransaction();
    try {
        const league = await League.findById(leagueid).session(session);
        const player = await Player.findById(playerid).session(session);
        const leagueProfile = await LeagueProfile.findOneAndDelete({
            player: playerid,
        }).session(session);

        if (!league || !player || !leagueProfile)
            throw new CustomError("öyle bir ligte öyle bir oyuncu yok.", 404);

        const leagueProfileid = leagueProfile._id;
        const leagueProfileIndex = league.players.indexOf(leagueProfileid);
        if (leagueProfileIndex !== -1) {
            league.players.splice(leagueProfileIndex, 1);
            await league.save({ session });
        }

        const leagueIndex = player.leagues.indexOf(leagueid);
        if (leagueIndex !== -1) {
            player.leagues.splice(leagueIndex, 1);
            await player.save({ session });
        }

        await session.commitTransaction();
    } catch (error) {
        await session.abortTransaction();
        throw error;
    } finally {
        session.endSession();
    }
};

const addMatch = async (
    player1id,
    player2id,
    player1score,
    player2score,
    leagueId
) => {
    //yeni mongoDB oturumu açılıyor ve işlem başlıyor
    const session = await mongoose.startSession();
    session.startTransaction();
    try {
        //yeni maç belgesi oluşturuluyor
        const match = new Match({
            players: [player1id, player2id],
            scores: [player1score, player2score],
            league: leagueId,
        });

        //oyuncların maç listesine yeni maçlar ekleniyor
        const bulkOps = [
            {
                updateOne: {
                    filter: { _id: player1id, ligler: { $in: [leagueId] } },
                    update: { $push: { maclar: match } },
                },
            },
            {
                updateOne: {
                    filter: { _id: player2id, ligler: { $in: [leagueId] } },
                    update: { $push: { maclar: match } },
                },
            },
        ];

        //oyuncu belgeleri güncelleniyor
        await Player.bulkWrite(bulkOps, { session });

        //ligin maçlarına yeni maçlar ekleniyor
        await League.updateOne(
            { _id: leagueId },
            { $push: { maclar: match } },
            { session }
        );

        //oyuncluarın lig profilleri güncelleniyor
        const updateFields1 = {
            $inc: { om: 1, ag: player1score, yg: player2score },
        };
        const updateFields2 = {
            $inc: { om: 1, ag: player2score, yg: player1score },
        };

        //maçın sonucuna göre puanlar güncelleniyor
        if (player1score > player2score) {
            updateFields1.$inc.puan = 3;
        } else if (player1score < player2score) {
            updateFields2.$inc.puan = 3;
        } else {
            updateFields1.$inc.puan = 1;
            updateFields2.$inc.puan = 1;
        }

        //oyuncuların lig profilleri güneclleniyor
        const leagueProfile1 = await LeagueProfile.findOneAndUpdate(
            { player: player1id, league: leagueId },
            updateFields1,
            { new: true, session }
        );

        const leagueProfile2 = await LeagueProfile.findOneAndUpdate(
            { player: player2id, league: leagueId },
            updateFields2,
            { new: true, session }
        );

        leagueProfile1.averaj = leagueProfile1.ag - leagueProfile1.yg;
        leagueProfile2.averaj = leagueProfile2.ag - leagueProfile2.yg;

        await leagueProfile1.save({ session });
        await leagueProfile2.save({ session });

        //oyuncu bulunmazsa hata atılıyor
        if (!leagueProfile1 || !leagueProfile2)
            throw new CustomError("Oyuncular ligte bulunamadı", 404);

        //maç bilgisi kaydediliyor
        await match.save({ session });

        ///////////////////////////  PUAN TABLOSU GÜNCELLEME //////////////////////////7

        //lig profilleri fetch ediliyor
        let leagueProfiles = await LeagueProfile.find({ league: leagueId });

        //lig profillerindeki puan ve averaj değerlerine göre sıralanıyor
        leagueProfiles = leagueProfiles.sort((a, b) => {
            if (b.puan === a.puan) {
                return b.averaj - a.averaj;
            }
            return b.puan - a.puan;
        });

        //puan tablosu bulunuyor ve güncelleniyor
        const puan = await Puan.findOne({ league: leagueId });
        if (!puan) {
            throw new CustomError("Puan tablosu bulunamadı.", 404);
        }

        puan.siralama = leagueProfiles.map((profile) => profile._id);
        await puan.save();

        //işlem tamamlandı ve otrum sonlnadırıldı
        await session.commitTransaction();
    } catch (error) {
        // hata oluşursa işlem iptal ediliyor ve hata atılıyor
        await session.abortTransaction();
        throw error;
    } finally {
        session.endSession();
    }
};

const getAllMatches = async (leagueId) => {
    const matches = await Match.find({ league: leagueId })
        .populate({
            path: "players",
            model: "Player",
            select: "name",
        })
        .select("-league");
    return matches;
};

const getAllLeagueMatchesForProfile = async (leagueId, playerId) => {
    const matches = await Match.find({
        players: { $in: playerId },
        league: leagueId,
    })
        .populate({ path: "players", model: "Player", select: "name" })
        .select("-league");
    return matches;
};

const getAllProfiles = async (leagueId) => {
    const profiles = LeagueProfile.find({ league: leagueId })
        .populate({
            path: "player",
            model: "Player",
            select: "name",
        })
        .select("-league -om -ag -yg -averaj -puan");

    return profiles;
};

module.exports = {
    createLeague,
    addPlayerToLeague,
    getAllLeagues,
    removeFromLeague,
    getLeagueById,
    addMatch,
    getAllMatches,
    getProfileById,
    getAllLeagueMatchesForProfile,
    getAllProfiles,
};
