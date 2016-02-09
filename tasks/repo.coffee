Git = require 'nodegit'
gulp = require 'gulp'
gutil = require 'gulp-util'

gulp.task 'repo.clone', (done) ->
  # Create a temporary pristine copy of the repo, that way we make sure we aren't
  # deploying any user-specific changes that haven't been commited to master

  path = require 'path'
  del = require 'del'
  spawn = require 'buffered-spawn'
  config = require '../config'

  # Delete current tmp repo if it exists
  del.sync config.TMP_REPO_DEST

  spawn('ssh-add').then ->
    Git.Repository.open(config.TMP_REPO_SOURCE).then (repo) ->
      Git.Remote.lookup(repo, 'origin')
  .then (@remote) ->
    gutil.log "cloning repo to #{config.TMP_REPO_DEST}"
    Git.Clone.clone(config.TMP_REPO_SOURCE, config.TMP_REPO_DEST)

  .then (@repo) ->
    Git.Remote.delete(@repo, 'origin')

  .then ->
    Git.Remote.create(@repo, 'origin', @remote.url())

  .then ->
    @repo.fetch 'origin',
      callbacks:
        credentials: (url, userName) ->
          Git.Cred.sshKeyFromAgent(userName)

  .then ->
    @repo.getBranchCommit("origin/#{config.BRANCH}")

  .then (commit) ->
    Git.Reset.reset(@repo, commit, Git.Reset.TYPE.HARD)

  .then ->
    @repo.getBranchCommit('HEAD')

  .then (commit) ->
    if not commit? then return done('commit not found')

    gutil.log "reset to commit #{commit}"

    done()
  .catch (err) ->
    done err

  return
