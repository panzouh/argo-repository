### General vars ###
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BIN_DIR=${ROOT_DIR}/.bin/
MANIFESTS_DIR=${ROOT_DIR}/.bin/
ARCH?=darwin

### Deps ###
HELM_VERSION?=v3.9.3
KUBECTL_VERSION?=v1.24.1
HELM_BIN=${BIN_DIR}/helm
KUBECTL_BIN=${BIN_DIR}/kubectl

### Git secret management ###


export

install:
	@mkdir ${BIN_DIR} && cd ${BIN_DIR} && \
	echo "[+] Installing Helm" && \
	wget -q https://get.helm.sh/helm-${HELM_VERSION}-${ARCH}-amd64.tar.gz -O helm-${HELM_VERSION}-${ARCH}-amd64.tar.gz && \
	tar -xzf helm-${HELM_VERSION}-${ARCH}-amd64.tar.gz && \
	mv ${ARCH}-amd64/helm . && \
	rm -rf ${ARCH}-amd64 && rm helm-${HELM_VERSION}-${ARCH}-amd64.tar.gz && \
	echo "[+] Installing kubectl" && \
	curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${ARCH}/amd64/kubectl -o ${KUBECTL_BIN} && \
	chmod +x ${KUBECTL_BIN} && \
	echo "[+] Done! You can uninstall the binaries by running 'make uninstall'"

uninstall:
	@rm -rf ${BIN_DIR}

check-version:
	@echo "[+] Helm:" && ${HELM_BIN} version  2> /dev/null && echo "[+] Kubectl:" && ${KUBECTL_BIN} version  2> /dev/null

define gen_secret

endef