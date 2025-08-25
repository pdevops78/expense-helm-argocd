# to install argocd
if [ $1 == "install" ]; then
  kubectl create namespace argocd
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
  sleep 2
  echo $(kubectl get svc argocd-server  -n argocd | awk '{print $4}' | tail -1)
  echo admin
  echo $(argocd admin initial-password -n argocd} | head -1)

  #kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
fi
#  to add jobs in argocd
  if [ $1 == "jobs" ]; then
   argocd login ${kubectl get svc argocd-server  -n argocd | awk '{print $4}' | tail -1} --username admin --password $(argocd admin initial-password -n argocd | head -1) --insecure --grpc-web
   for app in frontend backend; do
   argocd app create ${app} --repo https://github.com/pdevops78/expense-helm-argocd.git --path chart --upsert --dest-server https://kubernetes.default.svc --dest-namespace default --insecure  --grpc-web --values values/${app}.yaml
  done
fi
