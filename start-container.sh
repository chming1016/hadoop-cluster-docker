#!/bin/bash

# the default node number is 4
N=${1:-4}

# start hadoop master container
echo "start hadoop-master container..."
docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                hadoop-spark:cluster &> /dev/null

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
    echo "start hadoop-slave$i container..."
    docker run -itd \
                    --net=hadoop \
                    --name hadoop-slave$i \
                    --hostname hadoop-slave$i \
                    hadoop-spark:cluster &> /dev/null
    i=$(( $i + 1 ))
done 

sleep 1
docker exec -it hadoop-master sh -c 'service ssh start' > /dev/null
docker exec -it hadoop-slave1 sh -c 'service ssh start' > /dev/null
docker exec -it hadoop-slave2 sh -c 'service ssh start' > /dev/null
docker exec -it hadoop-slave3 sh -c 'service ssh start' > /dev/null