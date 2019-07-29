pipeline {
  agent {
    label 'docker'
  }
  options {
    timestamps()
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr:'20'))
    timeout(time: 10, unit: 'MINUTES')
  }
  stages {
    stage('build') {
      steps {
        dir('devise_invalidatable') {
          sh """
            make -f Makefile.docker build
          """
        }
      }
    }
    stage('deliver') {
      steps {
        dir('devise_invalidatable') {
          script {
            echo "==> Publishing to Artifactory"
            def jfrog_cli_conf = readJSON(file:"${env.HOME}/.jfrog/jfrog-cli.conf")
            def server = Artifactory.newServer url: 'https://artifacts.tet.wtf', username: "${env.USER}", password: "${jfrog_cli_conf.artifactory[0].apiKey}"
            def uploadSpec = """{
              "files": [
                {
                  "pattern": "pkg/*.gem",
                  "target": "gems-local/gems/"
                }
              ]
            }"""
            def buildInfo = Artifactory.newBuildInfo()

             buildInfo.env.capture = true
            buildInfo.retention maxBuilds: 20
            server.upload spec: uploadSpec, buildInfo: buildInfo
            server.publishBuildInfo buildInfo
          }
        }
      }
    }
  }
}
