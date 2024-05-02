const Player = require("../models/player.model");
const CustomError = require("../utils/CustomError");
const asyncErrorHandler = require("../utils/asyncErrorHandler");

const playerInLeague = asyncErrorHandler(async (req, res, next) => {
    const { leagueId } = req.params;
    const playerId = req.user.id;
    const player = await Player.findById(playerId);

    if (player.ligler.includes(leagueId)) {
        req.isMember = true;
    } else {
        req.isMember = false;
    }
    next();
});

const canChangeLeague = asyncErrorHandler( async (req, res, next) => {
    if(req.isMember){
        next();
    }else{
        throw new CustomError("bu ligte yetkin yok", 401);
    }
});

module.exports = { playerInLeague, canChangeLeague };
