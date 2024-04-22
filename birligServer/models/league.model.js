const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const leagueSchema = new Schema({
    name: {
        type: String,
        required: [true, "Name is required"],
    },
    players: [
        {
            type: Schema.Types.ObjectId,
            ref: "LeagueProfile",
        },
    ],
    maclar: [
        {
            type: Schema.Types.ObjectId,
            ref: "Match",
        },
    ],
    puanTablosu: {
        type: Schema.Types.ObjectId,
        ref: "Puan",
    },
});

const leagueProfileSchema = new Schema({
    player: {
        type: Schema.Types.ObjectId,
        ref: "Player",
        required: true,
    },
    league: {
        type: Schema.Types.ObjectId,
        ref: "League",
        required: true,
    },
    om: {
        type: Number,
        default: 0,
    },
    ag: {
        type: Number,
        default: 0,
    },
    yg: {
        type: Number,
        default: 0,
    },
    averaj: {
        type: Number,
        default: 0,
    },
    puan: {
        type: Number,
        default: 0,
    },
});

const matchSchema = new Schema({
    league: {
        type: Schema.Types.ObjectId,
        ref: "League",
    },
    players: [
        {
            type: Schema.Types.ObjectId,
            ref: "Player",
        },
    ],
    scores: {
        type: Array,
        of: Number,
    },
    date: {
        type: Date,
        default: Date.now,
    },
});

const puanSchema = new Schema({
    league: {
        type: Schema.Types.ObjectId,
        ref: "League",
    },
    siralama: [
        {
            type: Schema.Types.ObjectId,
            ref: "LeagueProfile",
        },
    ],
});

const League = mongoose.model("League", leagueSchema);
const LeagueProfile = mongoose.model("LeagueProfile", leagueProfileSchema);
const Match = mongoose.model("Match", matchSchema);
const Puan = mongoose.model("Puan", puanSchema);

module.exports = { League, LeagueProfile, Match, Puan };
