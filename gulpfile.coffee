gulp = require 'gulp'
runSequence = require 'run-sequence'
spawn = require 'buffered-spawn'
path = require 'path'
config = require './config'
require './tasks/install'
require './tasks/repo'
require './tasks/upload'

# Gets a path relative to the root directory
global.local = path.join.bind(path, __dirname)

tmpTask = (task) ->
  # Run a task in the context of the tmp repo directory
  gulpBinary = path.join(__dirname, 'node_modules', '.bin', 'gulp')
  taskParams = [task]
  taskParams.push config.TEST if config.TEST
  
  gulp.task "tmp.#{task}", ->
    spawn gulpBinary, taskParams, cwd: config.TMP_REPO_DEST
    .progress (buff) -> process.stdout.write(buff.toString())
  return "tmp.#{task}"

gulp.task 'deploy', (done) ->
  # Deploy assets to S3. Creates a pristine copy of the "ads" repo, installs
  # packages, then uploads all public files / browserified files to S3
  runSequence 'repo.clone', tmpTask('install'), tmpTask('upload'), done
  
gulp.task 'freeze', (done) ->
  _ = require 'lodash'
  npm = require 'npm'
  path = require 'path'
  fs = require 'fs'
  
  child_process = require 'child_process'
  npm = child_process.execSync('which npm').toString().trim()
  
  packageJSONFile = path.join(__dirname, 'package.json')
  packageJSON = require(packageJSONFile)
  
  spawn npm, ['ls', '--depth=0']
  .then (stdout, stderr) ->
    if stderr? then done(stderr)
    
    stdout = stdout.toString()
    
    packages = stdout.split('├── ').map (pkg) -> pkg.trim()
    
    packages.forEach (pkg) ->
      pkg = _.last(pkg.split('└──')).trim()
      [__,name,ver] = pkg.match(/(.*)@(.*)/)
      ver = _.last(ver.split('(')).split(')')[0]
      
      if name in Object.keys(packageJSON.devDependencies)
        packageJSON.devDependencies[name] = ver
      
      if name in Object.keys(packageJSON.dependencies)
        packageJSON.dependencies[name] = ver
  
    contents = JSON.stringify(packageJSON, null, 2)
    fs.writeFile packageJSONFile, contents, done
  return