
# ELK Stack Setup on Kubernetes using Helm

This guide walks through setting up the ELK (Elasticsearch, Logstash, Kibana) stack on Kubernetes using Helm.

---

## 🧠 Prerequisites

- Kubernetes Cluster (minikube/kind/production)
- kubectl configured
- Helm 3 installed
- Namespace: `elk`

---

## 🔧 Step-by-Step Installation

### 1. Add Helm Repos

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
```

### 2. Create Namespace

```bash
kubectl create ns elk
```

### 3. Install Elasticsearch

```bash
helm install elasticsearch elastic/elasticsearch -n elk
```

### 4. Install Kibana

```bash
helm install kibana elastic/kibana -n elk
```

### 5. Install Metricbeat

```bash
helm install metricbeat elastic/metricbeat -n elk
```

### 6. Get Elasticsearch Credentials

```bash
kubectl get secret elasticsearch-master-credentials -n elk -o jsonpath="{.data.username}" | base64 --decode; echo
kubectl get secret elasticsearch-master-credentials -n elk -o jsonpath="{.data.password}" | base64 --decode; echo
```

### 7. Port Forward Kibana to Access UI

```bash
kubectl port-forward svc/kibana-kibana 5601:5601 -n elk
```

Access: [http://localhost:5601](http://localhost:5601)

---

## ✅ Check Cluster Health

```bash
kubectl exec -n elk elasticsearch-master-0 -- curl -u <username>:<password> http://localhost:9200/_cluster/health?pretty
```

Example (if pod is a StatefulSet):

```bash
kubectl get pods -n elk  # Identify elasticsearch pod like elasticsearch-master-0
kubectl exec -n elk elasticsearch-master-0 -- curl -u elastic:<password> http://localhost:9200/_cluster/health?pretty
```

---

## 🔓 Expose Kibana via NodePort

(Separate YAML provided in repo)

Apply the service:

```bash
kubectl apply -f kibana-nodeport.yaml
```

---

## 📊 Creating Data View in Kibana

1. Login using elastic credentials.
2. Navigate to **Stack Management → Data Views**.
3. Click **Create Data View**.
4. Name: `filebeat` or `metricbeat`
5. Index pattern: `filebeat-*` or `metricbeat-*`
6. Timestamp field: Select the default timestamp.

---

## 🚀 Result

You now have:

- **Elasticsearch** storing logs/metrics
- **Kibana** for visualization
- **Metricbeat** sending metrics to ES

Ready to explore logs, metrics, and dashboards! 🎯

---

## 🔐 Notes

- Do not share credentials publicly.
- For production, configure persistent storage, resource limits, and secured access.

---

## 🧠 Reference Docs

- [Elastic Helm Charts](https://github.com/elastic/helm-charts)
- [Kibana Guide](https://www.elastic.co/guide/en/kibana/current/index.html)
