pipeline {
  options {
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  post { always { deleteDir() } }
  agent any
  environment {
    REGISTRY_HOST = "registry-jj.demo-rademade.com"
    PORTAINER_HOST = "portainer.demo-rademade.com"
    COMPOSE_YML = "docker-cloud.yml"
    PROJECT_NAME = "angular-cycle-gallery"
  }
  stages {
    stage('Build') {
      steps {
        // SOURCE_DIRECTORY - to find bin/build
        // BRANCH - to find out if branch is to be built
        // variables passed to bin/build:
        //   BRANCH=${PROJECT_TAG:-$BRANCH}
        //   REGISTRY_URL=$REGISTRY_HOST/$PROJECT_NAME
        // docker file: Dockerfile.${PROJECT_TAG:-$BRANCH}
        // image name: $REGISTRY_HOST/$PROJECT_NAME/{app,nginx}
        // image tag: ${PROJECT_TAG:-$BRANCH}
        build job: 'CreateImages',  parameters: [
          // Jenkins vars
          string(name: 'SOURCE_DIRECTORY', value: "$WORKSPACE"),
          string(name: 'BRANCH', value: "$BRANCH_NAME"),

          string(name: 'REGISTRY_HOST', value: "$REGISTRY_HOST"),
          string(name: 'PROJECT_NAME', value: "$PROJECT_NAME")
        ]
      }
    }
    stage('Deploy') {
      environment {
        PORTAINER_CREDS = credentials('portainer')
      }
      steps {
        // SOURCE_DIRECTORY - to find $COMPOSE_YML file
        // BRANCH - to find out if branch is to be built
        // PORTAINER_HOST - to make requests to portainer
        // PROJECT_NAME - stack name ($PROJECT_NAME or $PROJECT_NAME-${PROJECT_TAG:-$BRANCH})
        // COMPOSE_YML - to pass portainer possibly updated docker-cloud.yml
        // PORTAINER_CREDS - to authenticate to portainer
        // stack name: $PROJECT_NAME or $PROJECT_NAME-${PROJECT_TAG:-$BRANCH}
        build job: 'DeployImages',  parameters: [
          // Jenkins vars
          string(name: 'SOURCE_DIRECTORY', value: "$WORKSPACE"),
          string(name: 'BRANCH', value: "$BRANCH_NAME"),

          string(name: 'PORTAINER_HOST', value: "$PORTAINER_HOST"),
          string(name: 'PROJECT_NAME', value: "$PROJECT_NAME"),
          string(name: 'COMPOSE_YML', value: "$COMPOSE_YML"),
          string(name: 'PORTAINER_CREDS', value: "$PORTAINER_CREDS")
        ]
      }
    }
  }
}
