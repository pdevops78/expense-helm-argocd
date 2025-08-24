kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
echo ${kubectl get svc argocd-server  -n argocd | awk '{print $4}' | tail -1}
echo ${argocd admin initial-password -n argocd}

#kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
sleep 2

argocd app create backend --repo https://github.com/pdevops78/learn-kubernetes.git --path expense-chart/chart --upsert --dest-server https://kubernetes.default.svc --dest-namespace default.svc --insecure --skip-test-tls --grpc-web --values expense-chart/values/backend.yaml