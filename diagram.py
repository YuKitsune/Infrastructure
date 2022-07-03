from diagrams import Diagram, Cluster, Edge
from diagrams.digitalocean.storage import Space
from diagrams.onprem.network import Traefik
from diagrams.programming.language import Go
from diagrams.saas.cdn import Cloudflare
from diagrams.onprem.monitoring import Grafana
from diagrams.onprem.monitoring import Prometheus
from diagrams.onprem.logging import Loki
from diagrams.onprem.database import Mongodb
from diagrams.programming.framework import React
from diagrams.k8s.ecosystem import Helm
from diagrams.saas.chat import Discord

with Diagram("Overview", show=False):

    cloudflare = Cloudflare("Cloudflare") 
    space = Space("Space")
    mongodb = Mongodb("MongoDB")

    with Cluster("Digital Ocean Kubernetes Cluster"):

        with Cluster("traefik"):
            traefik = Traefik("Traefik")
            cloudflare >> Edge(label="*.yukitsune.dev") >> traefik

        with Cluster("monitoring"):
            loki = Loki("Loki")
            grafana = Grafana("Grafana")
            prometheus = Prometheus("Prometheus")
            alertmanager = Prometheus("Alert Manager")
            discordHook = Discord("Discord Alert Manager Hook")
            
            traefik >> Edge(label="grafana.yukitsune.dev") >> grafana
            traefik >> Edge(label="prometheus.yukitsune.dev") >> prometheus
            traefik >> Edge(label="alertmanager.yukitsune.dev") >> alertmanager

            alertmanager << prometheus
            grafana << prometheus
            grafana << loki
            alertmanager >> discordHook

        with Cluster("blog"):
            blog = Go("blog")
            traefik >> Edge(label="yukitsune.dev") >> blog

        with Cluster("maestro"):
            api = Go("API")
            frontend = React("Frontend")

            traefik >> Edge(label="maestro.yukitsune.dev/api") >> api >> mongodb
            traefik >> Edge(label="maestro.yukitsune.dev") >> frontend >> api

            prometheus << api
            loki << api

        with Cluster("dev"):
            chartMuseum = Helm("ChartMuseum")

            traefik >> Edge(label="charts.yukitsune.dev") >> chartMuseum >> space

        with Cluster("bots"):
            Discord("Muse bot")