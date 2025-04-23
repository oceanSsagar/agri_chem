pipeline {
  agent any
  stages {

    stage('Set Flutter Permissions') {
    steps {
        sh 'chmod -R +x /home/sagar/Development/flutter/bin'
    }
} 
    stage('Install Dependencies') {
      steps {
        sh '''#!/bin/bash -x
        export FLUTTER_HOME=/home/sagar/Development/flutter
        export PATH="$FLUTTER_HOME/bin:$PATH:/home/sagar/Android/Sdk/platform-tools:/home/sagar/Android/Sdk/tools:/home/sagar/Android/Sdk/emulator"
        export JAVA_OPTS="-Dorg.jenkinsci.plugins.durabletask.BourneShellScript.LAUNCH_DIAGNOSTICS=true"

        echo "PATH: $PATH"
        $FLUTTER_HOME/bin/flutter --version
        $FLUTTER_HOME/bin/flutter pub get
        '''
      }
    }

    stage('Build APK') {
      steps {
        sh '''#!/bin/bash
        export FLUTTER_HOME=/home/sagar/Development/flutter
        export PATH="$FLUTTER_HOME/bin:$PATH:/home/sagar/Android/Sdk/platform-tools:/home/sagar/Android/Sdk/tools:/home/sagar/Android/Sdk/emulator"
        $FLUTTER_HOME/bin/flutter build apk --release
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
a