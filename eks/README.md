# AWS EKS Cluster

## Initialize environment

    ```
    direnv allow
    ```

## Setup Cluster
1.  Create cluster with eksctl

    ```
    eksctl create cluster \
      --name yogi-demo-ts-prod-eks \
      --version 1.18 \
      --region ap-southeast-1 \
      --nodegroup-name linux-nodes \
      --node-type t3.medium \
      --nodes 3 \
      --nodes-min 1 \
      --nodes-max 4 \
      --ssh-access \
      --ssh-public-key ~/.ssh/id_rsa.pub \
      --managed
    ```
1.  Wait for a long time

1.  Attach cluster to TMC
    - Goto TMC 
    - Cluster - > Click "Attach Cluster"
    - Follow the instruction
        - Provide a Name
        - Cluster Group
        - Description
        - Tags
    - Click Next
    - Get command for "Agent Installation"  and run it on the same command prompt where you ran `eksctl`
    

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
