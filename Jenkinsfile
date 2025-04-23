pipeline {
  agent any
  environment {
    FLUTTER_HOME = "/opt/flutter"
    PATH = "/opt/flutter/bin:$PATH:/home/sagar/Android/Sdk/platform-tools:/home/sagar/Android/Sdk/tools:/home/sagar/Android/Sdk/emulator"
    JAVA_OPTS = "-Dorg.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true"
  }

  stages {

    stage('Install Dependencies') {
      steps {
        sh '''
        echo "PATH: $PATH"
        flutter --version
        flutter pub get
        '''
      }
    }

    stage('Build APK') {
      steps {
        sh '''
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
