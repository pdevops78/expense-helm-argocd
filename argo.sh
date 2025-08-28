if [ "$1" == "install" ]; then
 kubectl create namespace argocd
 kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
 kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

 sleep 10

 echo url - https://$(kubectl get svc -n argocd argocd-server | awk '{print $4}' | tail -1)
 echo username - admin
 echo password - $(argocd admin initial-password -n argocd | head -1)
fi

if [ "$1" == "jobs" ]; then
    argocd login $(kubectl get svc -n argocd argocd-server | awk '{print $4}' | tail -1) --username admin --password $(argocd admin initial-password -n argocd | head -1) --insecure --grpc-web
    for app in backend frontend ; do
    argocd app create ${app} --repo https://github.com/pdevops78/expense-helm-argocd --path chart --upsert --dest-server https://kubernetes.default.svc --dest-namespace default.svc --insecure --skip-test-tls --grpc-web --values values/${app}.yml
    done
fi
