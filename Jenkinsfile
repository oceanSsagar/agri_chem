pipeline {
  agent any
  stages {
    stage('Install Dependencies') {
      steps {
        sh '''#!/bin/bash -x
        export PATH=$PATH:/home/sagar/Development/flutter/bin:/home/sagar/Android/Sdk/platform-tools:/home/sagar/Android/Sdk/tools:/home/sagar/
        export JAVA_OPTS="-Dorg.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true"
          flutter --version
          flutter pub get
        '''
      }
    }

    stage('Build APK') {
      steps {
        sh 'flutter build apk --release'
      }
    }

    stage('Archive APK') {
      steps {
        echo '📦 Archiving APK...'
        archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
      }
    }

    // Optional: Firebase deployment or test stages can go here
  }
}
