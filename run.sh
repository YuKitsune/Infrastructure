# Setup Traefik
kubectl apply -f ./traefik/namespace.yaml
kubectl apply -f ./traefik/secrets/cloudflare.secret.yaml --namespace traefik
kubectl apply -f ./traefik/secrets/admin-auth.secret.yaml --namespace traefik
helm upgrade --install traefik traefik/traefik -f ./traefik/values.yaml -f ./traefik/secrets/traefik-args.secret.yaml --namespace traefik
kubectl apply -f ./traefik/admin-auth-middleware.yaml --namespace traefik
kubectl apply -f ./traefik/dashboard-ingress.yaml --namespace traefik

# Setup Blog
kubectl apply -f ./blog/namespace.yaml
kubectl apply -f ./blog/blog.yaml --namespace blog

# Setup dev stuff
## ChartMuseum
kubectl apply -f ./dev/namespace.yaml
helm repo add chartmuseum https://chartmuseum.github.io/charts
helm upgrade --install chartmuseum chartmuseum/chartmuseum --values ./dev/secrets/chartmuseum.values.secret.yaml --namespace dev
kubectl apply -f ./dev/chartmuseum-ingress.yaml --namespace dev

# Setup Maestro
kubectl apply -f ./maestro/namespace.yaml
helm repo add chartmuseum https://charts.yukitsune.dev
helm upgrade --install maestro yukitsune/maestro -f ./maestro/secrets/values.secret.yaml --namespace maestro
kubectl apply -f ./maestro/maestro-api-ingress.yaml 
kubectl apply -f ./maestro/maestro-frontend-ingress.yaml

# Setup Bots
kubectl apply -f ./bots/namespace.yaml

## Muse
kubectl apply -f ./bots/secrets/muse.secret.yaml
kubectl apply -f ./bots/muse.yaml

# Setup Monitoring
kubectl apply -f ./monitoring/namespace.yaml

## Prometheus Stack (incl. AlertManager)
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack -f ./monitoring/prometheus-values.yaml --namespace monitoring
kubectl apply -f ./monitoring/prometheus-ingress.yaml

## Grafana
helm upgrade --install grafana grafana/grafana -f ./monitoring/secrets/grafana-values.secret.yaml --namespace monitoring
kubectl apply -f ./monitoring/dashboards/maestro.yaml
kubectl apply -f ./monitoring/grafana-ingress.yaml

## Loki
helm upgrade --install loki grafana/loki -f ./monitoring/loki-values.yaml --namespace monitoring
