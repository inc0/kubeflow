# TODO(jlewi): How can we make it work with golang:1.8.2-alpine
FROM golang:1.8.2

# We need gcloud to get gke credentials.
RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz && \
    tar xzf google-cloud-sdk.tar.gz -C / && \
    rm google-cloud-sdk.tar.gz && \
    /google-cloud-sdk/install.sh \
    --disable-installation-options \
    --bash-completion=false \
    --path-update=false \
    --usage-reporting=false

RUN ln -sf /google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud

# Install kubectl
# We don't install via gcloud because we want 1.10 which is newer than what's in gcloud.
RUN  curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin && \
    chmod a+x /usr/local/bin/kubectl

RUN git clone https://github.com/ksonnet/ksonnet.git /opt/ksonnet && \
	cd /opt/ksonnet && \
	git checkout 68d8f751791db6b0e0798c34f0d72bda24926d8d

# TODO(jlewi): bootstrap is using an early dev version of ks (0.10) so we need
# to build ks at the same commit because the generated app won't work with
# earlier versions of ks.
RUN cd /opt/ksonnet && \
	mkdir -p /tmp/go/src/github.com/ksonnet && \
	ln -sf /opt/ksonnet /tmp/go/src/github.com/ksonnet/ksonnet && \
    cd /tmp/go/src/github.com/ksonnet/ksonnet && \
	export GOPATH=/tmp/go && \
	make install && \
    cp /tmp/go/bin/ks /usr/local/bin && \
    chmod a+rx /usr/local/bin/ks

RUN mkdir -p /opt/kubeflow

RUN wget https://github.com/kubeflow/kubeflow/archive/v0.1.0.tar.gz && tar -xvzf v0.1.0.tar.gz && mv kubeflow-0.1.0/ /opt/kubeflow/kubeflow

COPY kubeconfig_fake.yml /root/.kube/config

ARG github_token

RUN export GITHUB_TOKEN=${github_token} && cd / && ks init kubeflow && \
    cd kubeflow && \
    ks registry add kubeflow github.com/kubeflow/kubeflow/tree/master/kubeflow && \
    ks pkg install kubeflow/core && \
    ks pkg install kubeflow/tf-serving && \
    ks pkg install kubeflow/tf-job && unset GITHUB_TOKEN
COPY bootstraper /opt/kubeflow/
COPY start.sh /opt/kubeflow/

RUN chmod a+rx /opt/kubeflow/*

WORKDIR /kubeflow
CMD ["/opt/kubeflow/start.sh"]
