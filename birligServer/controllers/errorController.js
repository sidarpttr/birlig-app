class ValidationError extends Error {
    constructor(message){
        super(message);
        this.name = "ValidationError";
        this.statusCode = 400;
    }
}

class DatabaseError extends Error{
    constructor(message){
        super(message);
        this.name = "DatabaseError";
        this.statusCode = 500;
    }
}

module.exports = (error, req, res, next) => {
    //check the type of the error
    if(error.name === 'MongoError' && error.code === 11000) {
        error = new ValidationError('Dublicate field value entered');
    } else if(error.name  === 'ValidationError') {
        error = new ValidationError(error.message);
    } else if(error.name === 'CastError') {
        error = new DatabaseError('Invalid ID');
    }

    //set defaul values for the error status and status code
    error.statusCode = error.statusCode || 500;
    error.status = error.status || "fail";

    //send different errror emessages based on the enviroment
    if (process.env.NODE_ENV == "development") {
        //in development mode
        res.status(error.statusCode).json({
            status: error.status,
            error: error,
            message: error.message,
            stack: error.stack,
        });
    } else if (process.env.NODE_ENV == "production") {
        //in production mode
        res.status(error.statusCode).json({
            status: error.status,
            message: error.message,
        });
    }

    //res.status(error.statusCode).json({ error: error.message });
};
