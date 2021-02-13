# TechSummit - Demo 


This repository has demo environement setup and application.


There are 3 different environments setup in this. 
1. [EKS](eks/README.md)
2. [TKG on AWS](tkg-on-aws/README.md)
3. [KiND cluster on local Docker](kind/README.md)


## Requirement
1.  Own Domain
    - Get a free domain from [freenom](http://www.freenom.com) if you don't have one.
1.  AWS
    1.  AWS Account with Admin Access
    1.  AWS Programmatic Access (Access Key and Secret Key)
    1.  [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
    1.  [eksctl](https://eksctl.io/)
1.  VMware Tanzu
    1.  TMC Account
    1.  TO Account
    1.  [AWS Account Connected](https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-getstart/GUID-34E91A36-4D85-4AEF-9FDC-05D92E09BFFA.html)
1.  Kubernetes
    1.  [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
    1.  [kind cli](https://github.com/kubernetes-sigs/kind)
1.  Docker 
    1.  Docker Runtime
    1.  [docker cli](https://docs.docker.com/get-docker/)
1.  Essential Tools
    1.  Mac / Linux / WSL - need `bash` shell
    1.  [direnv](https://direnv.net/)
        - Unclutter your shell profile
    1.  [mkcert](http://mkcert.dev/)
        - This is easy way to create selfsigned CA and server certs (read again)

## How to get started

1.  Clone and detach 
    ```bash
    git clone --recurse-submodules -j8 https://github.com/yogendra/techsummit.git techsummit
    cd techsummit
    rm -rf .git
    ```
1.  Edit `.envrc` and update following variables
    - HOSTED_ZONE_ID - Put you Route 53 hosted zone id
    - ROOT_DOMAIN - Root domain for the demo. All the environemnes would be configured under this domain=. Example: aws.ROOT_DOMAIN, local.ROOT_DOMAIN, etc.
    
1.  Initialize env

    ```
    direnv allow
    ```


1.  Follow instruction in each env to setup the cluster and install applications
    1. [EKS](eks/README.md)
    2. [TKG on AWS](tkg-on-aws/README.md)
    3. [KiND cluster on local Docker](kind/README.md)
