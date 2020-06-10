node {
    agent none
    options {
        skipDefaultCheckout true
    }
    stage("Build_iOS_GDPR_PR"){
        build 'iOS_GDPR_PR'
    }
    stage("Automation_iOS_GDPR_PR"){
        build job: 'Automation_iOS_GDPR_PR', parameters: [string(name: 'type', value: 'iOS-GDPR')]
    }
}
