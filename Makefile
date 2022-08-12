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
	echo "[+] Installing Helm" && \
	curl -Ls https://raw.github.com/robertpeteuil/terraform-installer/master/terraform-install.sh | bash /dev/stdin -c -i ${TF_VERSION} && \
	echo "[+] Successfully installed Terraform" && \
	echo "[+] Installation done, uninstall w/ 'make uninstall'"

check-version:
	@${HELM_BIN} version && ${KUBECTL_BIN} version

define gen_secret

endef