spawn   = require('child_process').spawn
carrier = require 'carrier'

class Capistrano
  execute: (project, command, msg) ->
    cap = spawn 'cap', ['-f', "#{process.env.HUBOT_CAP_DIR}/#{project}/deploy.rb", command]
    @streamResult cap, msg

  streamResult: (cap, msg) ->
    capOut = carrier.carry cap.stdout
    capErr = carrier.carry cap.stderr
    output = ""

    capOut.on 'line', (line) ->
      output += line + "\n"

    capErr.on 'line', (line) ->
      output += "*" + line + "*\n"

    # Send message out in a bulk
    setInterval ->
      if output != ""
        msg.send output.trim()
        output = ""
    , 500

module.exports = Capistrano
