# Setup Traefik
kubectl apply -f ./traefik/namespace.yaml
kubectl apply -f ./traefik/secrets/cloudflare.secret.yaml --namespace traefik
helm upgrade --install traefik traefik/traefik -f ./traefik/values.yaml -f ./traefik/secrets/traefik-args.secret.yaml --namespace traefik

# Setup Blog
kubectl apply -f ./blog/namespace.yaml
kubectl apply -f ./blog/blog.yaml --namespace blog

# Setup ChartMuseum
kubectl apply -f ./dev/namespace.yaml
helm repo add chartmuseum https://chartmuseum.github.io/charts
helm upgrade --install chartmuseum chartmuseum/chartmuseum --values ./secrets/chartmuseum.values.secrets.yaml --namespace dev

# Setup Maestro
kubectl apply -f ./maestro/namespace.yaml
helm upgrade --install maestro yukitsune/maestro -f ./maestro/secrets/values.secret.yaml --namespace maestro
kubectl apply -f ./maestro/maestro-api-ingress.yaml -f ./maestro/maestro-frontend-ingress.yaml

# Setup Bots
## Muse
kubectl apply -f ./bots/namespace.yaml
kubectl apply -f ./bots/secrets/muse.secret.yaml
kubectl apply -f ./bots/muse.yaml
