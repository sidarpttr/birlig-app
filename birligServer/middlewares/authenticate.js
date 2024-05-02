const jwt = require("jsonwebtoken");
const Player = require("../models/player.model");
const CustomError = require("../utils/CustomError");
const asyncErrorHandler = require("../utils/asyncErrorHandler");

const authenticate = asyncErrorHandler(async (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({authFail:true, error: "Authentication Failed"});
        return;
    }
    const token = authHeader.split(" ")[1];
    let decoded;
    try {
        decoded = jwt.verify(token, process.env.SECRET_KEY);
    } catch (error) {
        res.status(401).json({authFail:true, error: "Invalid or expired token"});
        return;
    }

    const player = await Player.findById(decoded.id);
    if (!player) {
        res.status(401).json({authFail:true, error: "who are u? Authentication failed"});
        return;
    }

    req.user = player;
    next();
});

module.exports = { authenticate };
