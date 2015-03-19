#!/bin/bash

export GH_ORG=${GH_ORG:-cloudfoundry-community}
export GH_REPO=${GH_REPO:-cf-plugin-kibana-me-logs}
export NAME=${NAME:-"cf cli plugin for kibana-me-logs"}
export DESCRIPTION=${DESCRIPTION:-"Launches the Kibana UI (from [kibana-me-logs](https://github.com/cloudfoundry-community/kibana-me-logs)\) for an application."}
export PKG_DIR=${PKG_DIR:=out}

if [[ "${VERSION}X" == "X" ]]; then
  echo "USAGE: VERSION=X.Y.Z ./bin/release.sh"
  exit 1
fi

if [[ "$(which github-release)X" == "X" ]]; then
  echo "Please install github-release. Read https://github.com/aktau/github-release#readme"
  exit 1
fi


echo "Creating tagged release v${VERSION} of $GH_ORG/$GH_REPO."
read -n1 -r -p "Ok to proceed? (Ctrl-C to cancel)..." key

github-release release \
    --user $GH_ORG --repo $GH_REPO \
    --tag v${VERSION} \
    --name "${NAME}" \
    --description "${DESCRIPTION}"

oses=( darwin linux windows )
for os in "${oses[@]}"; do
  asset=$(ls ${PKG_DIR}/${GH_REPO}_${os}_amd64* | head -n 1)
  filename="${asset##*/}"

  echo "Uploading $filename..."
  github-release upload \
    --user $GH_ORG --repo $GH_REPO \
    --tag v${VERSION} \
    --name $filename \
    --file ${asset}
done

echo "Release complete: https://github.com/$GH_ORG/$GH_REPO/releases/tag/v$VERSION"