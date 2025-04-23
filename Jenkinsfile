pipeline {
  agent any

  environment {
    PATH = "/home/sagar/Development/flutter/bin:/home/sagar/Development/flutter/bin/cache/dart-sdk/bin:/home/sagar/Development/flutter/bin/cache/artifacts/engine/linux-x64:/home/sagar/Android/Sdk/platform-tools:/home/sagar/Android/Sdk/tools:/home/sagar/Android/Sdk/emulator:$PATH"
  }

  stages {
    stage('Install Dependencies') {
      steps {
        sh '''#!/bin/bash -x
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
