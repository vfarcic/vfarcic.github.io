cd cluster

export NAME=devops23.k8s.local

export BUCKET_NAME=devops23-$(date +%s)

aws s3api create-bucket --bucket $BUCKET_NAME \
    --create-bucket-configuration \
    LocationConstraint=$AWS_DEFAULT_REGION

export KOPS_STATE_STORE=s3://$BUCKET_NAME

kops create cluster --name $NAME --master-count 3 --node-count 2 \
    --node-size t2.medium --master-size t2.small --zones $ZONES \
    --master-zones $ZONES --ssh-public-key devops23.pub \
    --networking kubenet --authorization RBAC --yes

until kops validate cluster
do
  sleep 5
done

kubectl create -f \
    https://raw.githubusercontent.com/kubernetes/kops/master/addons/ingress-nginx/v1.6.0.yaml

kubectl -n kube-ingress \
    rollout status deploy ingress-nginx

CLUSTER_DNS=$(kubectl -n kube-ingress \
    get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

echo "Cluster DNS: $CLUSTER_DNS"

kubectl get nodes

cd ..
