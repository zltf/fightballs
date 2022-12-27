node_id=$1

if [ -z "$node_id" ];then
    node_id=1
fi

kill -9 `cat ./tmp/node$node_id.pid`

echo "stop$node_id"
