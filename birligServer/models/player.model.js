const mongoose = require("mongoose");
const validator = require("validator");
const bcrypt = require("bcryptjs");
const Schema = mongoose.Schema;

const playerSchema = new Schema({
    name: {
        type: String,
        unique: true,
        required: [true, "Name is required"],
        trim: true,
        lowercase: true,
    },
    ligler: [
        {
            type: Schema.Types.ObjectId,
            ref: "League",
        },
    ],
    maclar: [
        {
            type: Schema.Types.ObjectId,
            ref: "Match",
        },
    ],
    email: {
        type: String,
        required: [true, "Email is required"],
        unique: true,
        lowercase: true,
        trim: true,
        validate: {
            validator: function (v) {
                return validator.isEmail(v);
            },
            message: (props) => `${props.value} is not a valid email`,
        },
    },
    password: {
        type: String,
        required: [true, "Password is required"],
    },
});

playerSchema.pre("save", async function (next) {
    if(this.isModified('password')){
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(this.password, salt);
        this.password = hashedPassword;
    }
    next();
});

const Player = mongoose.model("Player", playerSchema);

module.exports = Player;
