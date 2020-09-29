cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: blue-green
  labels:
    app: blue-green  
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: blue-green
  namespace: blue-green
  labels:
    app: blue-green
spec:
  type: GitHub
  pathname: https://github.com/waynedovey/blue-green-rhacm.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: blue-green-dev-clusters
  namespace: blue-green
  labels:
    app: blue-green  
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions: []
    matchLabels:
      environment: dev
---
apiVersion: app.k8s.io/v1beta1
kind: Application
metadata:
  name: blue-green
  namespace: blue-green
  labels:
    app: blue-green  
spec:
  componentKinds:
  - group: apps.open-cluster-management.io
    kind: Subscription
  descriptor: {}
  selector:
    matchExpressions:
    - key: app
      operator: In
      values:
      - blue-green
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: blue-green
  namespace: blue-green
  labels:
    app: blue-green
  annotations:
      apps.open-cluster-management.io/github-path: resources/blue-green
spec:
  channel: blue-green/blue-green
  placement:
    placementRef:
      kind: PlacementRule
      name: blue-green-dev-clusters
      apiGroup: apps.open-cluster-management.io     
EOF
