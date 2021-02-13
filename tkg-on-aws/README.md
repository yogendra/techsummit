# TKG on AWS Setup

## Initialize environment

    ```
    direnv allow
    ```

## Setup Cluster
1.  Create cluster from TMC
    - Goto TMC -> Cluster -> Create
    - Follow instructions there

1.  Wait for a long time

1.  Download kubeconfig file into current directory `tkg-on-aws`
    - TMC -> Cluster 
    - Select cluster created in earlier step
    - In "Actions" menu -> Click "Access this cluster"
    - Download kubernetes config into current directory
    - Rename to .kubeconfig


## Install essentials

1.  Install Contour
    ```
    kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
    ```

    Configure route 53 to point to LB
    ```bash
    route53-update.sh $ENV_DOMAIN $HOSTED_ZONE_ID $(kubectl get svc -n projectcontour envoy -o "jsonpath={.status.loadBalancer.ingress[0].hostname}")
    ```
    or in Fish
    ```bash
    route53-update.sh $ENV_DOMAIN $HOSTED_ZONE_ID (kubectl get svc -n projectcontour envoy -o "jsonpath={.status.loadBalancer.ingress[0].hostname}")
    ```

1.  Cert manager
    ```
    kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml
    ```

1.  Craete Cluster Issuers for Let's Encrypt CA (staging and prod)
    ```
    kubectl apply -f ../letencrypt-issuers.yaml
    ```


## Setup Application

Follow instruction in [Application Installation](../APP-INSTALL.md) page

