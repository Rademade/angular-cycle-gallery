express         = require 'express'
http            = require 'http'
path            = require 'path'

# Create express app
app = express()

# Export environment
global.NODE_ENV = app.settings.env = 'development'

# Configure port
app.set 'port', process.env.PORT || process.argv[2]|| 3000

# Where static files are
app.use express.static path.join(__dirname, 'public')

# Disable 304
app.disable 'etag'

app.use (req, res) ->
  res.sendFile './public/index.html', root: __dirname

# Create server
server = http.createServer app

# Finally start listening requests
server.listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')