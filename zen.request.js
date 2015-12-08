"use strict"

var mongoose = require("zenserver").Mongoose;

mongoose.connect('mongodb://localhost/80cents',function() {
    mongoose.connection.db.dropDatabase();
    require('zenrequest').start();
});
