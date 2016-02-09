gulp = require 'gulp'
gutil = require 'gulp-util'
runSequence = require 'run-sequence'
Promise = require('es6-promise').Promise

gulp.task 'install.npmPackages', ->
  npm = require 'npm'
  path = require 'path'
    
  # Load package.json from clone
  configFilePath = path.join(local(), 'package.json')
  config = require configFilePath
  
  # Specify config specific to this run
  config.prefix = local()
  config['cache-min'] = '31536000'
  config['verbose'] = true
  config['production'] = true
  
  new Promise (resolve, reject) =>
    npm.load config, (err) ->
      if err? then return reject(err)
      
      npm.commands.install [], (err, data) ->
        if err? then return reject(err)
        resolve()

gulp.task 'install.bowerPackages', ->
  spawn = require 'buffered-spawn'
    
  bower = local './node_modules/.bin/bower'
  
  new Promise (resolve, reject) =>
    spawn bower, ['install'], cwd: @repoDir, (err, stdout, stderr) ->
      if err? && err.toString().length then return reject(err.toString())
      if stderr && stderr.toString().length then return reject(stderr.toString())
      
      resolve()
      
gulp.task 'install', (done) ->
  runSequence 'install.npmPackages', 'install.bowerPackages', done
