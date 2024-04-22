module.exports = (handler) => {
    return (req, res, next) => {
        handler(req, res, next).catch((err) => next(err));
    };
};
