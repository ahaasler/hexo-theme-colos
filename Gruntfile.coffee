module.exports = (grunt) ->

  grunt.initConfig
    copy:
      docs:
        files: [
          expand: true
          src: ['LICENSE', 'README.md']
          dest: '.theme'
        ]
    buildcontrol:
      options:
        dir: '.theme'
        commit: true
        push: true
        message: grunt.option('commit') || 'Built %sourceName% from commit %sourceCommit% on branch %sourceBranch%'
      release:
        options:
          remote: 'git@github.com:ahaasler/hexo-theme-colos.git',
          branch: 'master'

  grunt.loadNpmTasks 'grunt-build-control'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask 'default', ['copy']
  grunt.registerTask 'release', ['copy', 'buildcontrol']
