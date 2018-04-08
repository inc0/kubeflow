docker run -it -v /home/inc0/.kube/:/root/.kube -e PVC_MOUNT_PATH=/home/jovyan -e NAMESPACE=kubeflow-catdetect   inc0/kubeflow-bootstrapper:latest
