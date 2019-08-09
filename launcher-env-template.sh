#!/usr/bin/env bash

#################################################
# Here you can find basic setup for this script #
#################################################

if [ -z "$KEYCLOAK" ]; then

    # Default KeyCloak will be used if KEYCLOAK variable is not set before.
    # Choose (uncomment) one of the 3 KeyCloak options below.

    KEYCLOAK=NO
    #KEYCLOAK=OFFICIAL

fi

if [ -z "$ECHO_ENV" ]; then

    # Display environment vars?
    ECHO_ENV=YES
    #ECHO_ENV=NO

fi

if [ -z "$UNSET_ENV" ]; then

    # Unset environment vars?
    UNSET_ENV=YES
    #UNSET_ENV=NO

fi

#################################################
#################################################

echo ----- Environment is using $KEYCLOAK KeyCloak -----

SCRIPT_DIR=$(cd "$(dirname "$BASH_SOURCE")" ; pwd -P)

#### DO NOT CHANGE - Reset environment variables
case "$UNSET_ENV" in
"YES")
  unset LAUNCHER_MISSIONCONTROL_OPENSHIFT_API_URL
  unset LAUNCHER_MISSIONCONTROL_OPENSHIFT_CONSOLE_URL
  unset LAUNCHER_MISSIONCONTROL_OPENSHIFT_USERNAME
  unset LAUNCHER_MISSIONCONTROL_OPENSHIFT_PASSWORD
  unset LAUNCHER_MISSIONCONTROL_OPENSHIFT_TOKEN
  unset LAUNCHER_MISSIONCONTROL_GITHUB_USERNAME
  unset LAUNCHER_MISSIONCONTROL_GITLAB_PRIVATE_TOKEN
  unset LAUNCHER_MISSIONCONTROL_GITLAB_USERNAME
  unset LAUNCHER_MISSIONCONTROL_GITHUB_TOKEN
  unset LAUNCHER_MISSIONCONTROL_BITBUCKET_USERNAME
  unset LAUNCHER_MISSIONCONTROL_BITBUCKET_APPLICATION_PASSWORD
  unset LAUNCHER_KEYCLOAK_URL
  unset LAUNCHER_KEYCLOAK_REALM
  unset LAUNCHER_MISSIONCONTROL_OPENSHIFT_CLUSTERS_FILE
  unset LAUNCHER_HOVERFLY_CAPTURE
  unset LAUNCHER_GIT_PROVIDERS_FILE
    ;;
esac
####

case "$KEYCLOAK" in
"NO")
    # No KeyCloak
    MSHIFT=$(minishift console --url | sed 's/\/console//')
    if [[ $MSHIFT != "https://"* ]]; then
        echo "WARNING: MiniShift is NOT running, start it and try again or make sure the following variables are set:"
        echo "   LAUNCHER_MISSIONCONTROL_OPENSHIFT_API_URL"
        echo "   LAUNCHER_MISSIONCONTROL_OPENSHIFT_CONSOLE_URL"
	return
    else
        export LAUNCHER_MISSIONCONTROL_OPENSHIFT_API_URL=$MSHIFT
        export LAUNCHER_MISSIONCONTROL_OPENSHIFT_CONSOLE_URL=$MSHIFT/console
    fi

    export LAUNCHER_MISSIONCONTROL_OPENSHIFT_USERNAME=developer
    export LAUNCHER_MISSIONCONTROL_OPENSHIFT_PASSWORD=developer
    # If set, will override username/password authentication scheme
        #export LAUNCHER_MISSIONCONTROL_OPENSHIFT_TOKEN=<token here>

    # Setup git providers default credentials (please look at README.md)
    export LAUNCHER_MISSIONCONTROL_GITHUB_USERNAME=`git config github.user`
    export LAUNCHER_MISSIONCONTROL_GITHUB_TOKEN=`git config github.token`
    export LAUNCHER_MISSIONCONTROL_GITLAB_USERNAME=`git config gitlab.user`
    export LAUNCHER_MISSIONCONTROL_GITLAB_PRIVATE_TOKEN=`git config gitlab.token`
    export LAUNCHER_MISSIONCONTROL_BITBUCKET_USERNAME=`git config bitbucket.user`
    export LAUNCHER_MISSIONCONTROL_BITBUCKET_APPLICATION_PASSWORD=`git config bitbucket.password`
    ;;
"OFFICIAL")
    # Official KeyCloak
    export LAUNCHER_KEYCLOAK_URL=https://sso.openshift.io/auth
    export LAUNCHER_KEYCLOAK_REALM=rh-developers-launch
    export LAUNCHER_MISSIONCONTROL_OPENSHIFT_CLUSTERS_FILE=$SCRIPT_DIR/clusters.yaml
    ;;
*)
    echo ERROR: Failed to setup environment. Please choose a KEYCLOAK mode.
    [ $PS1 ] && return || exit;
    ;;
esac

# This will be set to "staging" on a staging server and "production" on a production server
  #export LAUNCHER_BACKEND_ENVIRONMENT=development
# This will prevent boosters being downloaded at startup making development faster (default = true)
  export LAUNCHER_PREFETCH_BOOSTERS=false

# The supported Git providers
  export LAUNCHER_GIT_PROVIDERS_FILE=$SCRIPT_DIR/git-providers.yaml

# For launchpad-booster-catalog-service
  #export LAUNCHER_BOOSTER_CATALOG_REPOSITORY=https://github.com/fabric8-launcher/launcher-booster-catalog.git
  #export LAUNCHER_BOOSTER_CATALOG_REF=master

# This can be used to filter boosters depending on their properties
# Eg. `booster.mission.id == 'rest-http'`
  #export LAUNCHER_BOOSTER_CATALOG_FILTER=

# For launchpad-frontend
  #export LAUNCHER_MISSIONCONTROL_URL="ws://localhost:8080"
  #export LAUNCHER_BACKEND_URL="http://localhost:8080/api"
  #export LAUNCHER_CREATOR_ENABLED=true
  #export LAUNCHER_CREATOR_URL="http://localhost:8080/api/creator"

# Testing tracker token
  export LAUNCHER_TRACKER_SEGMENT_TOKEN=dMV5AjaweCpO3KZop7TuZ0961UO74AF0

# For OSIO frontend
  export FABRIC8_FORGE_API_URL=http://localhost:8080

case "$ECHO_ENV" in
"YES")
    # Display LAUNCHER environment
    env | grep 'LAUNCHER\|FABRIC8_FORGE_API_URL\|OPENSHIFT_API_URL\|JENKINS_URL'
    ;;
esac


