# KiND Setup

## Initialize environment

    ```
    direnv allow
    ```
    
## Setup cluster

1.  Create kind cluster with ingress

    ```bash
    kind create cluster --config=kind.yaml
    ```

1.  Attach cluster to TMC
    - Goto TMC 
    - Cluster - > Click "Attach Cluster"
    - Follow the instruction
        - Provide a Name
        - Cluster Group
        - Description
        - Tags
    - Click Next
    - Get command for "Agent Installation"  and run it on the same command prompt where you ran `kind`

## Install Essentials

1.  Create Ingress controller (Contour)
    ```bash
    kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
    ```

    On Kind you need to allow scheduling on master node.

    ```bash
    kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'
    ```
1.  Update DNS 
    - local.cna-demo.ga -> localhost
    - *.local.cna-demo.ga -> localhost
    
    Example:
    ```bash
    route53-update.sh $ENV_DOMAIN $HOSTED_ZONE_ID localhost
    ```

1.  Install Cert Manager

    ```bash
    kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml
    ```

1.  Create cluster issuer with your own cert manager ca certs

    ```bash
    kubectl -n cert-manager create secret tls  mkcert-root-ca-cert   --cert="$(mkcert -CAROOT)/rootCA.pem" --key="$(mkcert -CAROOT)/rootCA-key.pem"
    kubectl -n cert-manager create -f mkcert-root-ca.yaml
    ```
1.  (Optional) Test the cluster issuer by creating a certificate

    ```bash
    kubectl -n cert-manager create -f test-cert.yaml
    ```

    Check certificatew is ready
    ```bash
    kubectl get secret,certificate,csr,order -n cert-manager
    ```
    Output:
    ```bash
    NAME                                         TYPE                                  DATA   AGE
    secret/cert-manager-cainjector-token-pxjwx   kubernetes.io/service-account-token   3      22m
    secret/cert-manager-token-8xkcd              kubernetes.io/service-account-token   3      22m
    secret/cert-manager-webhook-ca               Opaque                                3      22m
    secret/cert-manager-webhook-token-k5zt5      kubernetes.io/service-account-token   3      22m
    secret/default-token-92pv5                   kubernetes.io/service-account-token   3      22m
    secret/mkcert-root-ca-cert                   kubernetes.io/tls                     2      16m
    secret/test-certs                            kubernetes.io/tls                     3      11m

    NAME                               READY   SECRET       AGE
    certificate.cert-manager.io/test   True    test-certs   11m

    NAME                                                      AGE   SIGNERNAME                                    REQUESTOR                        CONDITION
    certificatesigningrequest.certificates.k8s.io/csr-lphnp   42m   kubernetes.io/kube-apiserver-client-kubelet   system:node:kind-control-plane   Approved,Issued
    ```

    Delete test certificate and secrets
    ```bash
    kubectl  -n cert-manager delete certificate test
    kubectl  -n cert-manager delete secret test-certs
    ```
    Check test certs are deletes
    ```bash
    kubectl get secret,certificate,csr,order -n cert-manager
    ```
    Output:
    ```bash
    NAME                                         TYPE                                  DATA   AGE
    secret/cert-manager-cainjector-token-pxjwx   kubernetes.io/service-account-token   3      25m
    secret/cert-manager-token-8xkcd              kubernetes.io/service-account-token   3      25m
    secret/cert-manager-webhook-ca               Opaque                                3      24m
    secret/cert-manager-webhook-token-k5zt5      kubernetes.io/service-account-token   3      25m
    secret/default-token-92pv5                   kubernetes.io/service-account-token   3      25m
    secret/mkcert-root-ca-cert                   kubernetes.io/tls                     2      18m

    NAME                                                      AGE   SIGNERNAME                                    REQUESTOR                        CONDITION
    certificatesigningrequest.certificates.k8s.io/csr-lphnp   45m   kubernetes.io/kube-apiserver-client-kubelet   system:node:kind-control-plane   Approved,Issued
    ```

## Application Installation

Follow instruction in [Application Installation](../APP-INSTALL.md) page
