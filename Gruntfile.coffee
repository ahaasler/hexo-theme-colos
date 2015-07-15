themeFiles = ['layout/**', 'scripts/**', 'languages/**']

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
      theme:
        files: [
          expand: true
          src: themeFiles
          dest: '.theme'
        ]
    watch:
      theme:
        files: themeFiles
        tasks: ['copy:theme']
    buildcontrol:
      options:
        dir: '.theme'
        commit: true
        push: true
        message: grunt.option('commit') || '<%= gitinfo.local.branch.current.lastCommitMessage.replace(/^\"/g, \'\').replace(/\"$/g, \'\') %>\n\nBuilt from <%= gitinfo.local.branch.current.SHA %>.'
        config:
          'user.name': process.env.GIT_NAME
          'user.email': process.env.GIT_EMAIL
      release:
        options:
          remote: 'https://github.com/ahaasler/hexo-theme-colos.git',
          branch: 'master'
          login: process.env.GH_LOGIN
          token: process.env.GH_TOKEN

  grunt.loadNpmTasks 'grunt-build-control'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-gitinfo'

  grunt.registerTask 'build', ['copy']
  grunt.registerTask 'release', ['gitinfo', 'buildcontrol']
  grunt.registerTask 'default', ['build', 'watch']
