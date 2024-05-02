const controller = require("../controllers/player.controller");
const playerRoute = require('express').Router();

playerRoute.get('/:id', controller.getPlayerById);
playerRoute.get('/:playerId/maclar', controller.getAllMatches);
playerRoute.get('/', controller.getAllPlayers);
playerRoute.get('/:playerId/ligler', controller.getAllLeaguesForPlayer);

module.exports = playerRoute;
