#!/bin/bash
#
# Startup script.
# The purpose of this script is to create a unix user
# with the same id as the user on the host system to
# that we can read the user's home directory on the host
# so that we can uss kubeconfig, gcloud config and other things.
set -x

# Remove fake kubeconfig and start k8s proxy
rm ~/.kube/config
kubectl proxy --port=8111 &

# Recreate env since we have proper k8s creds

ks env rm default
ks env add default --server=http://127.0.0.1:8111
kubectl create namespace ${NAMESPACE}

ks env set default --namespace ${NAMESPACE}
ks generate kubeflow-core kubeflow-core

ks param set kubeflow-core jupyterNotebookPVCMount ${PVC_MOUNT_PATH}

ks apply default --token=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
