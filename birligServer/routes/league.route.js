const router = require("express").Router();
const { authenticate } = require("../middlewares/authenticate");
const {
    playerInLeague,
    canChangeLeague,
} = require("../middlewares/verifyPlayer");
const controller = require("../controllers/league.controller");

router.use(authenticate);

//TÜM LİGLER VE YENİ LİG
router.route("/").get(controller.getAllLeagues).post(controller.createLeague); // OK1 OK2

// lig getir
router.route("/:leagueId").get(playerInLeague, controller.getLeagueById); //OOK

//LİGTEKİ TÜM MAÇLAR VE YENİ MAÇ
router
    .route("/:leagueId/mac")
    .post(playerInLeague ,playerInLeague, controller.addMatch) //
    .get(controller.getAllMatches); //OK

//LİGTEKİ OYUNCULARIN HEPSİ VE LİGE YENİ OYUNCU
router
    .route("/:leagueId/player")
    .get(controller.getAllProfiles)
    .post(playerInLeague ,canChangeLeague ,controller.addPlayerToLeague); //OK

//LİGTEKİ BİR OYUNNCU
router.route("/profile/:profileId").get(controller.getProfileById); //OK

//LİGTEKİ BİR OYUNCUNUN O LİGTEKİ TÜM MAÇLARI
router
    .route("/:leagueId/profile/:playerId/mac")
    .get(controller.getAllLeagueMatchesForProfile);

module.exports = router;
