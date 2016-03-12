###
 myApp
 https://github.com/shaunmulligan/myapp

 Copyright (c) 2016 Shaun Mulligan
 Licensed under the MIT license.
###

console.log 'Starting Server'
express = require 'express'
app = express()

app.get '/', (req, res) ->
  res.send('Hello World')

app.listen(80)
