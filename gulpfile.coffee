gulp = require('gulp')
rimraf = require('rimraf')
deploy = require('gulp-deploy-git')
exec = require('child_process').exec

# Common directories
dir =
  theme: 'theme'
  dist: 'dist'
  demo: 'test/demo'
# Documentation files
docs = [
  'LICENSE'
  'README.md'
]
# Git deploy configuration
git =
  commit: '%B\nBuilt from %H.'
  login: process.env.GH_LOGIN
  token: process.env.GH_TOKEN
  repo: process.env.GIT_REPO

# Clean distribution folder
gulp.task 'clean:dist', (callback) ->
  rimraf dir.dist, callback

# Clean project
gulp.task 'clean', [ 'clean:dist' ]

# Copy theme
gulp.task 'copy:theme', [ 'clean' ], (callback) ->
  gulp.src("#{dir.theme}/**/*", base: dir.theme).pipe gulp.dest(dir.dist)

# Copy documentation files
gulp.task 'copy:docs', [ 'clean' ], (callback) ->
  gulp.src(docs).pipe gulp.dest(dir.dist)

# Copy files to distribution folder
gulp.task 'copy', [
  'copy:docs'
  'copy:theme'
]

# Build project
gulp.task 'build', [ 'copy' ]

gulp.task 'demo:generate', [ 'build' ], (callback) ->
  exec 'hexo generate', { cwd: dir.demo }, (err, stdout, stderr) ->
    callback err

gulp.task 'test', [ 'demo:generate' ]

# Deploy distribution folder to git
gulp.task 'deploy', (callback) ->
  exec "git log --format='#{git.commit}' -1", (err, stdout, stderr) ->
    gulp.src("#{dir.dist}/**/*").pipe deploy(
      repository: "https://#{git.login}:#{git.token}@#{git.repo}"
      branches: [ 'HEAD' ]
      remoteBranch: 'master'
      prefix: dir.dist
      message: stdout).on "error", (error) ->
        callback error
