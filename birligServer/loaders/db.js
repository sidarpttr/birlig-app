const mongoose = require("mongoose");

const db = mongoose.connection;

db.once("open", () => console.log("connected to db"));

const connectDB = async () => {
    await mongoose.connect(process.env.DB_URL, {dbName: "birLig"});
};

module.exports = {
    connectDB,
};
