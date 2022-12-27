node_id=$1

if [ -z "$node_id" ];then
    node_id=1
fi

if [ ! -d ./tmp ];then
    mkdir ./tmp
fi

if [ ! -d ./log ];then
    mkdir ./log
fi

if [ -f ./log/node$node_id.log ];then
    if [ ! -d ./log/bak ];then
        mkdir ./log/bak
    fi
    mv ./log/node$node_id.log ./log/bak/node$node_id-`date "+%Y-%m-%d-%H:%M:%S"`.log
fi

./skynet/skynet ./etc/config.node$node_id

echo "start node$node_id"
