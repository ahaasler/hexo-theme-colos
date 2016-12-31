gulp = require 'gulp'
path = require 'path'
del = require 'del'
inquirer = require 'inquirer'
cssnano = require 'cssnano'
cssnext = require 'postcss-cssnext'
postcssImport = require 'postcss-import'
postcssNesting = require 'postcss-nesting'
casper = require 'gulp-casperjs'
deploy = require 'gulp-deploy-git'
newer = require 'gulp-newer'
postcss = require 'gulp-postcss'
vulcanize = require 'gulp-vulcanize'
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
# Bower files
bowerFiles = [
  '.bowerrc'
  'bower.json'
]
# Unnecessary lib files
unnecessaryLibFiles = [
  "#{dir.dist.theme}/source/lib/*"
  "!#{dir.dist.theme}/source/lib/elements.html"
  "!#{dir.dist.theme}/source/lib/webcomponentsjs"
]
# Theme files
themeFiles = [
  "#{dir.theme}/**/*"
  "!#{dir.theme}/**/*.css"
]
# CSS files
cssFiles = [
  "#{dir.theme}/**/*.css"
  "!#{dir.theme}/**/partial/**/*.css"
]
# Demo files
demoFiles = [
  "#{dir.demo}/scaffolds/**/*"
  "#{dir.demo}/source/**/*"
  "#{dir.demo}/themes/**/*"
  "#{dir.demo}/_config_yml"
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
  del dir.dist.base, callback

# Clean lib folder
gulp.task 'clean:lib', (callback) ->
  del unnecessaryLibFiles, callback

# Clean project
gulp.task 'clean', [ 'clean:dist' ]

# Copy theme
gulp.task 'copy:theme', (callback) ->
  gulp.src(themeFiles, base: dir.theme).pipe(newer(dir.dist.theme)).pipe gulp.dest(dir.dist.theme)

gulp.task 'postcss', (callback) ->
  processors = [
    postcssImport
    postcssNesting
    cssnext(
      'browers': [ 'last 2 version' ]
      'customProperties': true
      'applyRule': true
      'colorFunction': true
      'customSelectors': true)
    cssnano autoprefixer: false
  ]
  gulp.src(cssFiles, base: dir.theme).pipe(postcss(processors)).pipe gulp.dest(dir.dist.theme)

gulp.task 'bower', (callback) ->
  execCommand 'bower install', callback

gulp.task 'vulcanize', ['bower', 'copy'], (callback) ->
  gulp.src("#{dir.dist.theme}/source/lib/elements.html").pipe(vulcanize(
    abspath: ''
    excludes: []
    stripExcludes: false)).pipe gulp.dest("#{dir.dist.theme}/source/lib")

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
  sequence 'clean', ['copy', 'postcss', 'bower', 'vulcanize'], 'clean:lib', 'demo:generate', callback

# Generate demo site
gulp.task 'demo:generate', (callback) ->
  exec 'hexo generate', { cwd: dir.demo }, (err, stdout, stderr) ->
    callback err

# Serve demo site
gulp.task 'demo:serve', [ 'build' ], (callback) ->
  server = gulp.src(dir.dist.demo).pipe webserver(path: '/hexo-theme-colos')

# Test demo site
gulp.task 'casper', [ 'demo:serve' ], (callback) ->
  gulp.src("#{dir.casper}/**/*").pipe(casper()).on 'end', ->
    if server
      server.emit 'kill'

# Test theme
gulp.task 'test', [ 'build', 'casper' ]

# Prepare git information
gulp.task 'git:info', (callback) ->
  exec "git log --format='#{git.template}' -1", (err, stdout, stderr) ->
    git.commit = stdout
    callback err

# Deploy distribution theme folder to git
gulp.task 'deploy:theme', [ 'git:info' ], (callback) ->
  gulp.src("#{dir.dist.theme}/**/*", read: false).pipe deploy(
    repository: "https://#{git.login}:#{git.token}@#{git.repo}"
    branches: [ 'HEAD' ]
    remoteBranch: 'master'
    prefix: dir.dist.theme
    message: git.commit).on 'error', (err) ->
      callback err

# Deploy distribution demo folder to git
gulp.task 'deploy:demo', [ 'git:info' ], (callback) ->
  gulp.src("#{dir.dist.demo}/**/*", read: false).pipe deploy(
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
gulp.task 'browsersync', [ 'build' ], (callback) ->
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

# Watch bower
gulp.task 'watch:bower', (callback) ->
  gulp.watch bowerFiles, [ 'bower' ]

# Watch theme
gulp.task 'watch:theme', (callback) ->
  gulp.watch themeFiles, [ 'copy:theme' ]

# Watch postcss
gulp.task 'watch:postcss', (callback) ->
  gulp.watch cssFiles[0], [ 'postcss' ]

# Watch demo
gulp.task 'watch:demo', (callback) ->
  gulp.watch demoFiles, [ 'demo:reload' ]

# Watch task
gulp.task 'watch', [
  'watch:bower'
  'watch:theme'
  'watch:postcss'
  'watch:demo'
]

# Dev task
gulp.task 'dev', ->
  sequence 'browsersync', 'watch'

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
