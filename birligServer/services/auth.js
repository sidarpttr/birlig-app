const Player = require("../models/player.model");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const CustomError = require("../utils/CustomError");

const signUp = async (name, email, password) => {
    const existingUser = await Player.findOne({ email });
    if (existingUser) throw new CustomError("Kullanıcı zaten mevcut", 400);

    const newPlayer = new Player({ name, email, password });
    const savedPlayer = await newPlayer.save();

    return savedPlayer;
};

const logIn = async (email, password) => {
    const _player = await Player.findOne({ email }).select("-ligler -maclar");
    if (!_player) throw new CustomError("Kullanıcı bulunamadı", 404);

    const isMatch = await bcrypt.compare(password, _player.password);
    if (!isMatch) throw new CustomError("Hatalı Şifre", 400);

    const token = jwt.sign({ id: _player._id }, process.env.SECRET_KEY, {
        expiresIn: "2h",
    });

    const new_player = Object.assign({}, _player._doc);
    delete new_player.password;

    return { player: new_player, token };
};

module.exports = { signUp, logIn };
