gulp = require 'gulp'
path = require 'path'
rimraf = require 'rimraf'
inquirer = require 'inquirer'
casper = require 'gulp-casperjs'
deploy = require 'gulp-deploy-git'
newer = require 'gulp-newer'
sequence = require 'run-sequence'
exec = require('child_process').exec
spawn = require('child_process').spawn

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
# Processes
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

# Dev task
gulp.task 'dev', [ 'demo:serve' ], ->
  gulp.watch("#{dir.theme}/**/*", [ 'copy' ]).on 'change', (ev) ->
    if ev.type == 'deleted'
      rimraf.sync path.relative('./', ev.path).replace(dir.theme, dir.dist.theme)

gulp.task 'demo:generate', [ 'build' ], (callback) ->
  exec 'hexo generate', { cwd: dir.demo }, (err, stdout, stderr) ->
    callback err

gulp.task 'demo:serve', [ 'build' ], (callback) ->
  server = spawn('hexo', [
    'serve'
    '-p 8000'
  ], cwd: dir.demo)
  server.stdout.on 'data', (data) ->
    if data.toString('utf8').indexOf('Hexo is running') > -1
      callback()
  server.stderr.on 'data', (data) ->
    console.log data.toString('utf8')
  server.on 'error', (err) ->
    callback err

gulp.task 'casper', [ 'demo:serve' ], ->
  gulp.src("#{dir.casper}/**/*").pipe(casper()).on 'end', ->
    if server
      server.kill 'SIGINT'

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
