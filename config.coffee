args = require('yargs').argv
test = true if args.t or args.test

module.exports = config = {}
process.env.APP_PORT = config.APP_PORT = process.env.APP_PORT || 3000
process.env.AD_DIRNAME = config.AD_DIRNAME = process.env.AD_DIRNAME || 'ads'
config.AD_ROOT = require('path').join(__dirname, config.AD_DIRNAME)
config.AD_PATH_REGEX = new RegExp("^/#{config.AD_DIRNAME}/(\\w*)$")
config.AWS_ACCESS_KEY_ID = 'AKIAIJFARA6LFWN5LC7Q'
config.AWS_SECRET_ACCESS_KEY = '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'
config.PUBLIC_FOLDERS = ['./public']
config.PUBLIC_FILES = ['./bower_components/webcomponents.js/HTMLImports.min.js']
config.AWS_REGION = 'us-west-2'
config.TMP_REPO_SOURCE = require('path').join(__dirname)
config.TMP_REPO_DEST = require('path').join(__dirname, 'tmp', 'deploy')
config.STATIC_URL = "https://d1e0k6b3vhd1pj.cloudfront.net" # no trailing slash

config.BUCKET = "ads.britcdn.com"
config.BRANCH = "master"

if test
  config.BUCKET = "adtest.britcdn.com"
  config.BRANCH = "test"
  config.TEST = "-t"
  config.STATIC_URL = "http://adtest.britcdn.com"