# Install ACME Fitness 


## Deploy application
Following instructions from the [ACME fitness Git repo][acme-gitrepo].

### Pre-requisites:
1.  Ingress Controller - Contour Setup
2.  Cert Manager is Setup
3.  DNS is configured to point to ingress controller external/load balancer IP

You can follow environemnt specific instruction for this:
1. [KiND](kind-1/README.md)
1. [EKS](eks-1/README.md)
1. [TKG on AWS](tkgaws-1/README.md)

**Note:** Deploying in `default` namespace

### Deploy Cart Service
1.  Create password for redis
    ```bash
    kubectl create secret generic cart-redis-pass --from-literal=password=password
    ```
1.  Deploy redis and cart service

    ```bash
    kubectl apply -f $APP_ROOT/kubernetes-manifests/cart-redis-total.yaml
    kubectl apply -f $APP_ROOT/kubernetes-manifests/cart-total.yaml
    ```

### Deploy catalog service

1.  Create password for mongodb
    ```bash
    kubectl create secret generic catalog-mongo-pass --from-literal=password=password
    ```
1.  Create config map
    ```bash
    kubectl create -f $APP_ROOT/kubernetes-manifests/catalog-db-initdb-configmap.yaml
    ```
1.  Create mongodb and catalog service
    ```bash
    kubectl apply -f $APP_ROOT/kubernetes-manifests/catalog-db-total.yaml
    kubectl apply -f $APP_ROOT/kubernetes-manifests/catalog-total.yaml
    ```

### Payment Service
1.  Create payment service
    ```bash
    kubectl apply -f $APP_ROOT/kubernetes-manifests/payment-total.yaml
    ```
  
### Order Service
1.  Create postgres password
    ```bash
    kubectl create secret generic order-postgres-pass --from-literal=password=password
    ```
1.  Create postgres and order service
    ```bash
    kubectl apply -f $APP_ROOT/kubernetes-manifests/order-db-total.yaml
    kubectl apply -f $APP_ROOT/kubernetes-manifests/order-total.yaml
    ```

### Users Service

1.  Create mongo and redis password
    ```bash
    kubectl create secret generic users-mongo-pass --from-literal=password=password
    kubectl create secret generic users-redis-pass --from-literal=password=password
    ```
1.  Init DB
    ```bash
    kubectl create -f $APP_ROOT/kubernetes-manifests/users-db-initdb-configmap.yaml
    ```
1.  Create user mongo, redis and service
    ```bash
    kubectl apply -f $APP_ROOT/kubernetes-manifests/users-db-total.yaml
    kubectl apply -f $APP_ROOT/kubernetes-manifests/users-redis-total.yaml
    kubectl apply -f $APP_ROOT/kubernetes-manifests/users-total.yaml
    ```
### Frontends
1.  Deploy frontend
    ```bash
    kubectl apply -f $APP_ROOT/kubernetes-manifests/frontend-total.yaml
    ```
1.  Deploy frontend service and ingress
    ```bash
    kubectl apply -f frontend-service.yaml
    ```
1.  Deploy Point of Sale
    ```bash
    kubectl apply -f $APP_ROOT/kubernetes-manifests/point-of-sales-total.yaml
    ```
1.  Updatee pos-config and restart deployment
    ```bash
    kubectl apply -f pos-config.yaml
    kubectl rollout restart deployment pos
    ```

1.  Deploy pos service and ingress
    ```bash    
    kubectl apply -f pos-service.yaml
    ```

[acme-gitrepo]: https://github.com/yogendra/acme_fitness_demo/tree/master/kubernetes-manifests
