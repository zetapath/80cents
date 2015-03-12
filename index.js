"use strict";

require('coffee-script/register');
var path          = require("path");
var url           = require("url");
var fs            = require("fs");
var CONST         = require("./node_modules/zenserver/lib/zen.constants.coffee")
global.ZEN        = {
  path: path.join(__dirname, "../.."),
  file: path.join(__dirname, "../../80cents.yml") };
var Zen           = require('zenserver')

module.exports = {
  start: function() {
    var zen = Zen.start()

    // -- Default Endpoints
    var endpoints = {
      api: ["session", "order", "customer", "collection", "product", "image",
            "settings", "page", "discount", "checkout"],
      www: ["admin", "store.order", "store.profile", "store"]
    };
    var context, endpoint, values, _i, _len;
    for (context in endpoints) {
      values = endpoints[context];
      for (_i = 0, _len = values.length; _i < _len; _i++) {
        endpoint = values[_i];
        require(path.join(__dirname, "/" + context + "/" + endpoint))(zen)
      }
    }

    // -- Default assets
    zen.get("/assets/core", function(request, response) {
      var cache_modified, file, last_modified, mime_type, _ref;
      file = __dirname + url.parse(request.url).pathname.replace("/core", "");
      if (fs.existsSync(file)) {
        last_modified = fs.statSync(file).mtime;
        cache_modified = request.headers["if-modified-since"];
        if ((cache_modified != null) && __time(last_modified) === __time(cache_modified)) {
          mime_type = CONST.MIME[(_ref = path.extname(file)) != null ? _ref.slice(1) : void 0] || CONST.MIME.html;
          return response.run(null, 304, mime_type);
        } else {
          return response.file(file, 60, last_modified);
        }
      } else {
        return response.page("404", null, null, 404);
      }
    }, false);

    return zen;
  }
};

var __time = function (value) {
  return (new Date(value)).getTime();
}
