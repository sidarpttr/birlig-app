const { getPlayerById, getAllMatches, getAllPlayers } = require("../services/player");
const asyncErrorHandler = require("../utils/asyncErrorHandler");

exports.getPlayerById = asyncErrorHandler(async (req, res, next) => {
    const playerid = req.params.id;
    const player = await getPlayerById(playerid);
    res.status(200).json(player);
});

exports.getAllPlayers = asyncErrorHandler(async (req, res) => {
    const players = await getAllPlayers();
    res.status(200).json(players);
});

exports.getAllMatches = asyncErrorHandler(async (req, res, next) => {
    const { playerId } = req.params;
    const matches = await getAllMatches(playerId);
    res.status(200).json(matches);
});
