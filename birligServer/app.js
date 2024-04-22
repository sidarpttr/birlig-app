require("dotenv").config();
const express = require("express");
const { leagueRoute, playerRoute, authRoute } = require("./routes");
const loaders = require("./loaders");
const CustomError = require("./utils/CustomError");
const globalErrorHandler = require("./controllers/errorController");
const app = express();
loaders();

app.use(express.json());

app.use("/lig", leagueRoute);
app.use("/player", playerRoute);
app.use('/auth',authRoute);

app.use("*", (req, res, next) => {
    const err = new CustomError("burada olmaman lazım", 404);
    next(err);
});

app.use(globalErrorHandler);

app.listen(process.env.PORT, () => {
    console.log(`server is listening on :${process.env.PORT}`);
});
