pipeline {
  agent any

  environment {
    PATH = "/usr/local/flutter/bin:$PATH"
  }

  // ❗ Removed the 'Checkout' stage since Jenkins does it by default using SCM settings

  stages {
    stage('Install Dependencies') {
      steps {
        sh '''#!/bin/bash
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

  // Optional: Add post actions like sending email on failure
  // post {
  //   always {
  //     echo '🔍 Checking test results...'
  //     junit '**/build/test-results/**/*.xml'
  //   }
  //   failure {
  //     mail to: 'your@email.com',
  //          subject: "❌ Build Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
  //          body: "Check Jenkins for details: ${env.BUILD_URL}"
  //   }
  // }
}
