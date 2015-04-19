module.exports = (grunt) ->

  grunt.initConfig
    gitinfo:
      local:
        branch:
          current:
            SHA               : ''
            lastCommitMessage : ''
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
        message: grunt.option('commit') || '<%= gitinfo.local.branch.current.lastCommitMessage.replace(/^\"/g, \'\').replace(/\"$/g, \'\') %>\n\nBuilt from <%= gitinfo.local.branch.current.SHA %>.'
      release:
        options:
          remote: 'git@github.com:ahaasler/hexo-theme-colos.git',
          branch: 'master'

  grunt.loadNpmTasks 'grunt-build-control'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-gitinfo'

  grunt.registerTask 'build', ['copy']
  grunt.registerTask 'release', ['gitinfo', 'buildcontrol']
  grunt.registerTask 'default', ['build']
