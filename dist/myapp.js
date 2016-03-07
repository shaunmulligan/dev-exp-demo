
/*
 myApp
 https://github.com/shaunmulligan/myapp

 Copyright (c) 2016 Shaun Mulligan
 Licensed under the MIT license.
 */
var app, express;

console.log('Starting Server');

express = require('express');

app = express();

app.get('/', function(req, res) {
  return res.send('Hello World...hello sync!');
});

app.listen(80);
