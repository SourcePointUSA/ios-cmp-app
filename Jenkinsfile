node {
    stage("Build_iOS_GDPR_PR"){
        checkout scm
        build 'iOS_GDPR_PR'
    }
    stage("Automation_iOS_GDPR_PR"){
        build job: 'Automation_iOS_GDPR_PR', parameters: [string(name: 'type', value: 'iOS-GDPR')]
    }
}
