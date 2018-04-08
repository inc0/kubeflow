#!/bin/bash
#
# Startup script.
# The purpose of this script is to create a unix user
# with the same id as the user on the host system to
# that we can read the user's home directory on the host
# so that we can uss kubeconfig, gcloud config and other things.
set -x

# Recreate env since we have proper k8s creds
ks env rm default
ks env add default

kubectl create namespace ${NAMESPACE}

ks env set default --namespace ${NAMESPACE}
ks generate kubeflow-core kubeflow-core

ks param set kubeflow-core jupyterNotebookPVCMount ${PVC_MOUNT_PATH}

ks apply default
