alias find-ipfs-aws-addrs="aws ec2 describe-instances --filters 'Name=tag:Name,Values=sam-ipfs-testing' --query 'Reservations[].Instances[].PublicDnsName' | jq --raw-output '.[]'"
