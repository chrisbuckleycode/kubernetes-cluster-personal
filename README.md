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
