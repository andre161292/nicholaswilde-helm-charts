#!/bin/bash

APP_VERSION=0.1.0
CHARTS_DIR=charts

# Get the directory the script is in.
# https://stackoverflow.com/a/246128/1061279
CHARTS_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/${CHARTS_DIR}"
SCRIPT_NAME=$(basename "${0}")
readonly CHARTS_PATH
readonly SCRIPT_NAME

function help(){
   # Display Help
  echo "Update a helm chart."
  echo
  usage
  echo "options:"
  echo "  -h     Print this Help."
  echo "  -v     Print script version and exit."
}

function usage() {
  echo "Usage: ${SCRIPT_NAME} [REPOSITORY:TAG|-h|-v]"
}

# Echo usageerror if something isn't right.
function usageerror() {
  usage
  echo ""
  echo "Try ${SCRIPT_NAME} -h for more options."
  exit 1
}

function parse(){
  if [[ $# == 0 ]]; then
    echo "${SCRIPT_NAME}: missing repository and tag"
    usageerror
  fi
  echo "Parsing arguments"
  #eval REPOSITORY=$(echo $1 | awk -F ":" '{print $1}')
  eval REPOSITORY="$(echo "$1" | awk -F ":" '{print $1}')"
  #eval CHART_NAME=$(echo $(basename $1)|awk -F ":" '{print $1}')
  eval CHART_NAME="$(basename "$1"|awk -F ":" '{print $1}')"
  eval CHART_PATH="${CHARTS_PATH}/${CHART_NAME}"
  #eval TAG=$(echo $(basename $1)|awk -F ":" '{print $2}')
  eval TAG="$(basename "$1"|awk -F ":" '{print $2}')"
  #eval VERSION="$(echo ${TAG}|awk -F "-" '{print $1}')"
  eval VERSION="$(echo "${TAG}"|awk -F "-" '{print $1}')"
  if [ -z "${REPOSITORY}" ]; then
    echo "${SCRIPT_NAME}: missing repository"
    usageerror
  fi
  if [ -z "${CHART_NAME}" ]; then
    echo "${SCRIPT_NAME}: missing chart name"
    usageerror
  fi
  if [ -z "${TAG}" ]; then
    echo "${SCRIPT_NAME}: missing tag"
    usageerror
  fi
  # shellcheck disable=SC2153
  if [ -z "${CHART_PATH}" ]; then
    echo "${SCRIPT_NAME}: missing chart path"
    usageerror
  fi
  if [ -z "${VERSION}" ]; then
    echo "${SCRIPT_NAME}: missing version"
    usageerror
  fi
  echo "  REPOSITORY: ${REPOSITORY}"
  echo "  CHART_NAME: ${CHART_NAME}"
  echo "  CHART_PATH: ${CHART_PATH}"
  echo "  TAG:        ${TAG}"
  echo "  VERSION:    ${VERSION}"
}

# Do a bunch of checks
function checks(){
  echo "Doing checks"
  # Check if chart dir exists
  if [ ! -d "${CHART_PATH}" ]; then
    echo "Chart does not exist, ${CHART_NAME}"
    exit 1
  fi

  # Check if yq is installed
  if ! command -v yq &> /dev/null; then
    echo "yq is not installed"
    exit 1
  fi
}

function updatechart(){
  echo "Updating Chart.yaml"
  local CHART_FILE_PATH="${CHART_PATH}"/Chart.yaml
  # appVersion
  yq e ".appVersion=\"${VERSION}\"" -i "${CHART_FILE_PATH}"
  # Add the three hyphens to the top of the file
  sed  -i '1i ---' "${CHART_FILE_PATH}"
}

function updatevalues(){
  echo "Updating values.yaml"
  local VALUES_PATH="${CHART_PATH}"/values.yaml
  yq e ".image.repository=\"${REPOSITORY}\"" -i "${VALUES_PATH}"
  yq e ".image.tag=\"${TAG}\"" -i "${VALUES_PATH}"
  # Add the three hyphens to the top of the file
  sed -i '1i ---' "${VALUES_PATH}"
}

function main(){
  parse "$@"
  checks "$@"
  updatechart
  updatevalues
}

# https://www.jamescoyle.net/how-to/1774-bash-getops-example
# https://opensource.com/article/19/12/help-bash-program
# Get the options
while getopts ":hv" o; do
  case "${o}" in
    h) # display Help
      help
      exit 0;;
    v)
      echo "${SCRIPT_NAME} version ${APP_VERSION}"
      exit 0;;
    \?) # incorrect option
      usageerror;;
  esac
done

# https://unix.stackexchange.com/a/214151/93726
shift "$((OPTIND-1))"

main "$@"
