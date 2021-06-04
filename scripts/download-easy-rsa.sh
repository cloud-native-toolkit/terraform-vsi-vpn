#!/usr/bin/env bash

OUTFILE="$1"
VERSION="$2"

if [[ -z "${VERSION}" ]]; then
  VERSION="3.0.7"
fi

mkdir -p $(cd $(dirname "${OUTFILE}"); pwd -P)

if command -v wget; then
  wget -O "${OUTFILE}" https://github.com/OpenVPN/easy-rsa/releases/download/v${VERSION}/EasyRSA-${VERSION}.tgz
elif command -v curl; then
  curl -Lo "${OUTFILE}" https://github.com/OpenVPN/easy-rsa/releases/download/v${VERSION}/EasyRSA-${VERSION}.tgz
fi
