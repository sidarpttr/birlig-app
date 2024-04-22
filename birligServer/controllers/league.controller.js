const {
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
} = require("../services/league");
const CustomError = require("../utils/CustomError");
const asyncErrorHandler = require("../utils/asyncErrorHandler");

exports.createLeague = asyncErrorHandler(async (req, res, next) => {
    const { name, playerId } = req.body;
    const league = await createLeague(name, playerId);
    res.status(200).json({
        status: "success",
        data: league,
    });
});

exports.addPlayerToLeague = asyncErrorHandler(async (req, res, next) => {
    const { leagueId } = req.params;
    const { playerId } = req.body;
    if (!playerId) throw new CustomError("Oyuncu eksik", 400);

    const updatedLeague = await addPlayerToLeague(leagueId, playerId);
    res.status(200).json(updatedLeague);
});

exports.getAllLeagues = asyncErrorHandler(async (req, res, next) => {
    const leagues = await getAllLeagues();
    res.status(200).json(leagues);
});

exports.getLeagueById = asyncErrorHandler(async (req, res, next) => {
    const { leagueId } = req.params;
    const league = await getLeagueById(leagueId);
    res.status(200).json(league);
});

exports.removeFromLeague = asyncErrorHandler(async (req, res, next) => {
    const { leagueid } = req.params;
    const { playerid } = req.body;
    await removeFromLeague(leagueid, playerid);

    res.status(200).json({
        status: "success",
    });
});

exports.addMatch = asyncErrorHandler(async (req, res, next) => {
    const { leagueId } = req.params;
    const { player1id, player2id, player1score, player2score } = req.body;
    if (player1id === player2id) {
        throw new CustomError("2 farklı takım gir", 400);
    }

    //const _playerId = req.user.id;
    //if (player1id != _playerId && player2id != _playerId)
    //    throw new CustomError(
    //        "Yetkilendirilmediniz. Yalnızca kendi hesabınıza maç girebilirsiniz.",
    //        401
    //    );

    await addMatch(player1id, player2id, player1score, player2score, leagueId);

    res.status(200).json({
        status: "success",
    });
});

exports.getAllMatches = asyncErrorHandler(async (req, res, next) => {
    const { leagueId } = req.params;
    const matches = await getAllMatches(leagueId);
    res.status(200).json(matches);
});

exports.getProfileById = asyncErrorHandler(async (req, res, next) => {
    const { profileId } = req.params;
    if (!profileId) throw new CustomError("profil bulunamadı", 404);
    const profile = await getProfileById(profileId);
    res.status(200).json(profile);
});

exports.getAllLeagueMatchesForProfile = asyncErrorHandler(async (req, res) => {
    const { leagueId, playerId } = req.params;
    if (!leagueId || !playerId)
        throw new CustomError("Lig veya oyuncu bulunamadı", 404);

    const matches = await getAllLeagueMatchesForProfile(leagueId, playerId);
    res.status(200).json(matches);
});

exports.getAllProfiles = asyncErrorHandler(async (req, res) => {
    const { leagueId } = req.params;
    const profiles = await getAllProfiles(leagueId);
    res.status(200).json(profiles);
});
