const asyncErrorHandler = require("../utils/asyncErrorHandler");
const CustomError = require("../utils/CustomError");
const { signUp, logIn } = require("../services/auth");

exports.signUp = asyncErrorHandler(async (req, res) => {
    const { name, email, password } = req.body;
    if (!name || !email || !password)
        throw new CustomError("Bilgilerin hepsini gir!", 400);
    const player = await signUp(name, email, password);
    res.status(201).json({
        status: "success",
    });
});

exports.logIn = asyncErrorHandler(async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password)
        throw new CustomError("Lütfen bilgilerin hepsini gir.", 400);
    const { player, token } = await logIn(email, password);
    res.status(200).json({
        status: "success",
        data: {
            player,
            token,
        },
    });
});
