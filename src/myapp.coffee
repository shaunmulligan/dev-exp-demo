###
 myApp
 https://github.com/shaunmulligan/myapp

 Copyright (c) 2016 Shaun Mulligan
 Licensed under the MIT license.
###

console.log 'Starting Server'
console.log 'hello'
express = require 'express'
app = express()

app.get '/', (req, res) ->
  res.send('Hello World...hello sync!')

app.listen(80)
