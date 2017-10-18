node('windows'){
    def msbuild = tool 'MSBuild-default'
    stage('Build (Debug-Local for testing)') {
       checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: '**']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'PruneStaleBranch']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '7da7b86f-cf6b-4b99-8acb-1c59795b0133', url: 'https://github.com/jfouchard/ansible-role-acd-cli.git']]]
       echo "${BRANCH_NAME}"
    }
}

