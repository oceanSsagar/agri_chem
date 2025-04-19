pipeline {
  agent any

  environment {
    PATH = "/usr/local/flutter/bin:$PATH"
  }

  // tools {
  //   flutter 'flutter' // Make sure this is configured under Jenkins > Global Tool Configuration
  // }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/oceanSsagar/agri_chem.git'
      }
    }

    stage('Install Dependencies') {
      steps {
        sh '''#!/bin/bash
                    flutter --version
                    flutter pub get
                    flutter build apk --release
                '''
      }
    }
    //flutter
    // stage('Run Tests') {
    //   steps {
    //     sh 'flutter test'
    //   }
    // }

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

    // stage('Deploy to Firebase') {
    //   when {
    //     allOf {
    //       expression { fileExists('firebase.json') }
    //       expression { env.FIREBASE_CREDENTIALS != null }
    //     }
    //   }
    //   steps {
    //     withCredentials([file(credentialsId: 'firebase-service-account', fileVariable: 'FIREBASE_CREDENTIALS')]) {
    //       sh '''
    //         echo "🔐 Authenticating with Firebase..."
    //         export GOOGLE_APPLICATION_CREDENTIALS="$FIREBASE_CREDENTIALS"
    //         firebase login:ci --token "$(cat $FIREBASE_CREDENTIALS)"
    //         firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
    //           --app your-firebase-app-id \
    //           --groups testers
    //       '''
    //     }
    //   }
    // }
  }

//   post {
//     always {
//       echo '🔍 Checking test results...'
//       junit '**/build/test-results/**/*.xml' // Optional: only if you generate junit test reports
//     }
//     failure {
//       mail to: 'your@email.com',
//            subject: "❌ Build Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
//            body: "Check Jenkins for details: ${env.BUILD_URL}"
//     }
//   }
}
