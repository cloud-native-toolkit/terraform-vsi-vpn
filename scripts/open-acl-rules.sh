#!/usr/bin/env bash

NETWORK_ACL="$1"

## TODO more sophisiticated logic needed to 1) test for existing rules and 2) place this rule in the right order

ibmcloud is network-acl-rule-add "${NETWORK_ACL}" allow inbound all "0.0.0.0/0" "0.0.0.0/0" --name allow-all-ingress
ibmcloud is network-acl-rule-add "${NETWORK_ACL}" allow outbound all "0.0.0.0/0" "0.0.0.0/0" --name allow-all-egress

#ibmcloud is network-acl-rule-add "${NETWORK_ACL}" allow inbound tcp "0.0.0.0/0" "0.0.0.0/0" --name allow-ssh-ingress --source-port-min 22 --source-port-max 22 --destination-port-min 22 --destination-port-max 22
#ibmcloud is network-acl-rule-add "${NETWORK_ACL}" allow inbound udp "0.0.0.0/0" "0.0.0.0/0" --name allow-vpn-ingress --source-port-min 1194 --source-port-max 1194 --destination-port-min 1194 --destination-port-max 1194
