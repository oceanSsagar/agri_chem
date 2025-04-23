pipeline {
  agent any
  stages {
    stage('Install Dependencies') {
      steps {
        sh '''#!/bin/bash -x
        export PATH=$PATH:/home/sagar/Development/flutter/bin:/home/sagar/Android/Sdk/platform-tools:/home/sagar/Android/Sdk/tools:/home/sagar/Android/Sdk/emulator
        export JAVA_OPTS="-Dorg.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true"
        echo $PATH
        which flutter
        flutter --version
        flutter pub get
        '''
      }
    }

    stage('Build APK') {
      steps {
        sh '''#!/bin/bash
        export PATH=$PATH:/home/sagar/Development/flutter/bin:/home/sagar/Android/Sdk/platform-tools:/home/sagar/Android/Sdk/tools:/home/sagar/Android/Sdk/emulator
        flutter build apk --release
        '''
      }
    }

    stage('Archive APK') {
      steps {
        echo '📦 Archiving APK...'
        archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
      }
    }
  }
}
