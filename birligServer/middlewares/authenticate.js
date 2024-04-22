const jwt = require("jsonwebtoken");
const Player = require("../models/player.model");
const CustomError = require("../utils/CustomError");
const asyncErrorHandler = require("../utils/asyncErrorHandler");

const authenticate = asyncErrorHandler(async (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        throw new CustomError("Authentication failed", 401);
    }
    const token = authHeader.split(" ")[1];
    let decoded;
    try {
        decoded = jwt.verify(token, process.env.SECRET_KEY);
    } catch (error) {
        throw new CustomError("Invalid or expired token", 401);
    }

    const player = await Player.findById(decoded.id);
    if (!player) {
        throw new CustomError("who are u? Authentication failed", 401);
    }

    req.user = player;
    next();
});

module.exports = { authenticate };
