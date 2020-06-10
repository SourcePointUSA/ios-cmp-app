node {
    stage("Build_iOS_GDPR_PR"){
        build 'iOS_GDPR_PR'
    }
    stage("Build_Automation_iOS_GDPR_PR"){
        build job: 'Automation_iOS_GDPR_PR', parameters: [string(name: 'type', value: 'iOS-GDPR')]
    }
}
