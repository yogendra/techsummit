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

1.  Update DNS 
    - local.cna-demo.ga -> localmachine ip
    - *.local.cna-demo.ga -> localmachine ip
    
    Example:
    ```bash
    route53-update.sh $ENV_DOMAIN $HOSTED_ZONE_ID 192.168.86.103 A
    ```

1.  Install Cert Manager

    ```bash
    kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml
    ```
1.  Set you aws key and secret  in `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variable
    ```
    export AWS_ACCESS_KEY_ID=...
    export AWS_SECRET_ACCESS_KEY=...    
    ```
    
1.  Create secret with AWS credentials for Route-53 resolvers

    ```bash    
    kubectl create secret generic aws-credentials-secret -n cert-manager --from-literal=access-key-id=$AWS_ACCESS_KEY_ID --from-literal=secret-access-key=$AWS_SECRET_ACCESS_KEY
    ```

1.  Generate `lets-encrypt-issuers-dns.yaml`     
    ```bash
    sed "s/MY_EMAIL/$MY_EMAIL/g;s/AWS_ACCESS_KEY_ID/$AWS_ACCESS_KEY_ID/g;s/AWS_REGION/$AWS_REGION/g" letsencrypt-issuers-dns.template.yaml  > letsencrypt-issuers-dns.yaml
    ```
1.  Remove AWS Credentials from env
    ```bash
    unset AWS_ACCESS_KEY_ID 
    unset AWS_SECRET_ACCESS_KEY
    ```
    Or on fish
    ```bash    
    set AWS_ACCESS_KEY_ID
    set AWS_SECRETE_ACCESS_KEY
    ```

1.  Create Cluster Issuer
    ```bash
    kubectl apply -f letsencrypt-issuers-dns.yaml
    ```

## Application Installation

Follow instruction in [Application Installation](../APP-INSTALL.md) page
