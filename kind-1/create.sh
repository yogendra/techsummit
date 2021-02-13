#!/usr/bin/env bash
SCRIPT_ROOT=$( cd `dirname $0`; pwd)

kind create cluster --config=kind.yaml

kubectl apply -f https://projectcontour.io/quickstart/contour.yaml

kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml


kubectl -n cert-manager create secret tls  mkcert-root-ca-cert   --cert="$(mkcert -CAROOT)/rootCA.pem" --key="$(mkcert -CAROOT)/rootCA-key.pem"


kubectl -n cert-manager create -f mkcert-root-ca.yaml
