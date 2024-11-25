# https://kind.sigs.k8s.io/docs/user/quick-start
# For M1 / ARM Macs
[ $(uname -m) = arm64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.25.0/kind-darwin-arm64
chmod +x ./kind
mv ./kind ~/bin/kind # ~/bin must be in path

[ $(uname -m) = arm64 ] && curl -Lo ./cloud-provider-kind https://github.com/kubernetes-sigs/cloud-provider-kind/releases/download/v0.4.0/cloud-provider-kind_0.4.0_darwin_arm64.tar.gz
chmod +x ./cloud-provider-kind
mv ./cloud-provider-kind ~/bin/cloud-provider-kind # ~/bin must be in path