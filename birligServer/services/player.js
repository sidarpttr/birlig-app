const Player = require("../models/player.model");
const { Match, LeagueProfile } = require("../models/league.model");
const CustomError = require("../utils/CustomError");

const getPlayerById = async (id) => {
    const player = await Player.findById(id).populate({
        path: "leagues",
        model: "League",
        select: "name",
    });

    if (!player) throw new CustomError("Kullanıcı bulunamadı", 400);

    return player;
};

const getAllLeagueProfilesForPlayer = async (id) => {
    const profiles = await LeagueProfile.find({ player: id });
    return profiles;
};

const getAllMatches = async (id) => {
    const matches = await Match.find({ players: { $in: id } }).select(
        "-league -players"
    );
    return matches;
};

const getAllPlayers = async () => {
    const players = await Player.find().select("name");
    return players;
};

const getAllLeaguesForPlayer = async (playerId) => {
    const player = await Player.findById(playerId)
        .populate({ path: "ligler", model: "League", select: "name" })
        .select("ligler");
    if (!player) throw new CustomError("kullanıcı bulunamadı", 400);
    return player["ligler"];
};

module.exports = {
    getPlayerById,
    getAllMatches,
    getAllPlayers,
    getAllLeaguesForPlayer,
};
