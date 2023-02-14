# DigitalOcean Infrastructure Terraform - Kubernetes and LoadBalancer

[DigitalOcean Cloud Dashboard](https://cloud.digitalocean.com/)

[DigitalOcean Kubernetes Dashboard](https://cloud.digitalocean.com/kubernetes/clusters)

[DigitalOcean PAT Tokens](https://cloud.digitalocean.com/account/api/tokens)

[DigitalOcean CLI Releases Page](https://github.com/digitalocean/doctl/releases)

[DigitalOcean CLI GitHub Repo](https://github.com/digitalocean/doctl/blob/main/README.md)

[DigitalOcean Kubernetes Documentation](https://docs.digitalocean.com/products/kubernetes/)

[Load Balancer Docs](https://docs.digitalocean.com/products/kubernetes/how-to/add-load-balancers/)
LB for Kubernetes can only be created as service of type: LoadBalancer. Do NOT use Terraform/API calls.

Download and extract CLI:

```curl -sL https://github.com/digitalocean/doctl/releases/download/v1.92.0/doctl-1.92.0-linux-amd64.tar.gz | tar -xzv```

Move file

```sudo mv ~/doctl /usr/local/bin```

CLI initialize (paste in PAT)

```doctl auth init```

CLI list Kubernetes available node types

```doctl kubernetes options sizes```

Export PAT as environment variable for Terraform:

```export DIGITALOCEAN_TOKEN=<PAT TOKEN>```

5m40s creation time via Terraform.

Download and install kubectl

```https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/```

e.g.

``` curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" ```

``` sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl ```

Configure kubeconfig via doctl

``` doctl kubernetes cluster kubeconfig save cluster1 ```

Example kubectl commands:

```kubectl config current-context```
```kubectl config get-contexts```
```kubectl config use-context <context>```

## Load Balancer

Terraform resource exists - `digitalocean_loadbalancer`

Used here to bind to underlying 'node' dropet (requires tags) - [Go continuous delivery with Terraform and Kubernetes](https://techsquad.rocks/blog/go_continuous_delivery_with_terraform_and_kubernetes/)

But official DO docs - [How to Add Load Balancers to Kubernetes Clusters](https://docs.digitalocean.com/products/kubernetes/how-to/add-load-balancers/) says:

> The DigitalOcean Cloud Controller supports provisioning DigitalOcean Load Balancers in a cluster’s resource configuration file. Load balancers created in the control panel or via the API cannot be used by your Kubernetes clusters.

Shows provisioning a load balancer via Yaml.

DO's own tutorial: [How To Set Up an Nginx Ingress on DigitalOcean Kubernetes Using Helm](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm) deploys nginx Type LoadBalancer using helm.

Also says here: [Service Annotations](https://github.com/digitalocean/digitalocean-cloud-controller-manager/blob/master/docs/controllers/services/annotations.md)

> DigitalOcean cloud controller manager watches for Services of type LoadBalancer and will create corresponding DigitalOcean Load Balancers matching the Kubernetes service. The Load Balancer can be configured by applying annotations to the Service resource.

Then, there is a question from someone unable to create a working load balancer and the root cause of his issue seems to be trying to configure a resource originally deployed via Terraform: [K8S Nginx LoadBalancer constant 503 No server is available to handle this request](https://www.digitalocean.com/community/questions/k8s-nginx-loadbalancer-constant-503-no-server-is-available-to-handle-this-request?comment=190456):

> This is your issue. You shouldn’t create a loadbalancer by hand, just create the ingress-nginx Helm release and add the annotations in that, and it will request the creation of the loadbalancer (correctly) automatically.

Finally, I realized that on the DO Kubernetes dashboard itself, there is a note that says:
> Important: Load balancers and volumes should only be created through kubectl.

**Conclusion: For a load-balancer, deploy Kubernetes resources and do not use Terraform resource.**

Options:
- Yaml example: [How to Add Load Balancers to Kubernetes Clusters](https://docs.digitalocean.com/products/kubernetes/how-to/add-load-balancers/)
- Yaml multiple examples (http, https, tcp): [Load Balancers - GitHub](https://github.com/digitalocean/digitalocean-cloud-controller-manager/tree/master/docs/controllers/services/examples)
- Helm chart: [How To Set Up an Nginx Ingress on DigitalOcean Kubernetes Using Helm](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-on-digitalocean-kubernetes-using-helm)

Important: limit load-balancer to a single 'node'. More load-balancer nodes means more capacity but costs more. Default size is 1 node.
