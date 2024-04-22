const Player = require("../models/player.model");
const CustomError = require("../utils/CustomError");
const asyncErrorHandler = require("../utils/asyncErrorHandler");

const playerInLeague = asyncErrorHandler(async (req, res, next) => {
    const { leagueId } = req.params;
    const playerId = req.user.id;
    const player = await Player.findById(playerId);
    if (leagueId in player.ligler) {
        next();
    } else {
        throw new CustomError("Bu ligte yetkiniz yok", 400);
    }
});

module.exports = { playerInLeague };
