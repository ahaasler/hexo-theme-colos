gulp = require 'gulp'
path = require 'path'
rimraf = require 'rimraf'
inquirer = require 'inquirer'
casper = require 'gulp-casperjs'
deploy = require 'gulp-deploy-git'
newer = require 'gulp-newer'
webserver = require 'gulp-webserver'
sequence = require 'run-sequence'
exec = require('child_process').exec
spawn = require('child_process').spawn
browserSync = require('browser-sync').create()

execCommand = (command, callback) ->
  exec command, (err, stdout, stderr) ->
    console.log stdout
    console.log stderr
    callback err

gitPush = (callback) ->
  execCommand 'git push & git push --tags', callback

# Common directories
dir =
  theme: 'theme'
  dist:
    base: 'dist'
    theme: 'dist/theme'
    demo: 'dist/demo'
  demo: 'test/demo'
  casper: 'test/casper'
# Documentation files
docs = [
  'CHANGELOG.md'
  'LICENSE'
  'README.md'
]
# Git deploy configuration
git =
  template: '%B\nBuilt from %H.'
  commit: undefined
  login: process.env.GH_LOGIN
  token: process.env.GH_TOKEN
  repo: process.env.GIT_REPO
# Streams
server = undefined

# Clean distribution folder
gulp.task 'clean:dist', (callback) ->
  rimraf dir.dist.base, callback

# Clean project
gulp.task 'clean', [ 'clean:dist' ]

# Copy theme
gulp.task 'copy:theme', (callback) ->
  gulp.src("#{dir.theme}/**/*", base: dir.theme).pipe(newer(dir.dist.theme)).pipe gulp.dest(dir.dist.theme)

# Copy documentation files
gulp.task 'copy:docs', (callback) ->
  gulp.src(docs).pipe(newer(dir.dist.theme)).pipe gulp.dest(dir.dist.theme)

# Copy files to distribution folder
gulp.task 'copy', [
  'copy:docs'
  'copy:theme'
]

# Build project
gulp.task 'build', (callback) ->
  sequence 'clean', 'copy', callback

# Generate demo site
gulp.task 'demo:generate', [ 'build' ], (callback) ->
  exec 'hexo generate', { cwd: dir.demo }, (err, stdout, stderr) ->
    callback err

# Serve demo site
gulp.task 'demo:serve', [ 'demo:generate' ], (callback) ->
  server = gulp.src(dir.dist.demo).pipe webserver(path: '/hexo-theme-colos')

# Test demo site
gulp.task 'casper', [ 'demo:serve' ], (callback) ->
  gulp.src("#{dir.casper}/**/*").pipe(casper()).on 'end', ->
    if server
      server.emit 'kill'

# Test theme
gulp.task 'test', [ 'demo:generate', 'casper' ]

# Prepare git information
gulp.task 'git:info', (callback) ->
  exec "git log --format='#{git.template}' -1", (err, stdout, stderr) ->
    git.commit = stdout
    callback err

# Deploy distribution theme folder to git
gulp.task 'deploy:theme', [ 'git:info' ], (callback) ->
  gulp.src("#{dir.dist.theme}/**/*").pipe deploy(
    repository: "https://#{git.login}:#{git.token}@#{git.repo}"
    branches: [ 'HEAD' ]
    remoteBranch: 'master'
    prefix: dir.dist.theme
    message: git.commit).on 'error', (err) ->
      callback err

# Deploy distribution demo folder to git
gulp.task 'deploy:demo', [ 'git:info' ], (callback) ->
  gulp.src("#{dir.dist.demo}/**/*").pipe deploy(
    repository: "https://#{git.login}:#{git.token}@#{git.repo}"
    branches: [ 'HEAD' ]
    remoteBranch: 'gh-pages'
    prefix: dir.dist.demo
    message: git.commit).on 'error', (err) ->
      callback err

# Deploy in order, or the temporary deploy dir may be the same
gulp.task 'deploy', (callback) ->
  sequence 'deploy:theme', 'deploy:demo', callback

# Initialize browsersync for development
gulp.task 'browsersync', [ 'demo:generate' ], (callback) ->
  browserSync.init {
    server:
      baseDir: dir.dist.demo
      routes: "/hexo-theme-colos": dir.dist.demo
    port: 8080
  }, callback

# Reload demo for browsersync
gulp.task 'demo:reload', [ 'demo:generate' ], (callback) ->
  browserSync.reload()
  callback()

# Dev task
gulp.task 'dev', [ 'browsersync' ], ->
  gulp.watch "#{dir.theme}/**/*", [ 'demo:reload' ]

gulp.task 'git-show', (callback) ->
  execCommand 'git show -1', callback

gulp.task 'git-push', (callback) ->
  gitPush callback

gulp.task 'git-push:confirm', [ 'git-show' ], (callback) ->
  inquirer.prompt [ {
    type: 'confirm'
    message: 'Push version?'
    default: false
    name: 'push'
  } ], (answers) ->
    if answers.push
      gitPush callback
    else
      callback()

gulp.task 'release', [ 'git-push:confirm' ]
