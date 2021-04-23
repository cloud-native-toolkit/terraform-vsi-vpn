#!/usr/bin/env bash

# Verify the database has been provisioned?

if [[ -n "${IBMCLOUD_API_KEY}" ]]; then
  echo "IBM Cloud api key provided"
else
  echo "IBM Cloud api key not provided"
fi
