#!/usr/bin/env bash

########################
# include the magic
########################
. ~/bin/demo-magic.sh

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

clear

pei "# log_id from GitHub Action"

cmd

pe "rekor-cli get --log-index=$log_id --format=json | jq \".Body | .HashedRekordObj | .signature | .publicKey | .content\" | cut -d '\"' -f2 | base64 -D > cert-action.pem"

pe "openssl x509 -in cert-action.pem -text -noout"

pe 'tail -n 28 manifests/imagePolicy.yaml'

pe "kubectl apply -f manifests/imagePolicy.yaml --namespace next-demo"

pe "kubectl run bad-image --image=ghcr.io/lukehinds/blackhat-next-security-demo:main"

pe "kubectl run nginx --image=nginx:latest"

pe "kubectl run good-image --image=ghcr.io/lukehinds/redhat-next-security-demo:main"

pe "kubectl get pod good-image"

pe "kubectl delete pod good-image"

pe "tail -n 30 manifests/imagePolicy-email.yaml"

pe "kubectl apply -f manifests/imagePolicy-email.yaml --namespace next-demo"

pe "kubectl run good-image --image=ghcr.io/lukehinds/redhat-next-security-demo:main"

pe "podman sign ghcr.io/lukehinds/redhat-next-security-demo:main"

p "# log_id from email"

cmd

pe "rekor-cli get --log-index=$log_id --format=json | jq \".Body | .HashedRekordObj | .signature | .publicKey | .content\" | cut -d '\"' -f2 | base64 -D > cert-email.pem"

pe "openssl x509 -in cert-email.pem -text -noout"

pe "kubectl run good-image --image=ghcr.io/lukehinds/redhat-next-security-demo:main"

pe "kubectl delete pod good-image"
