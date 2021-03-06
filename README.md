#Hadoop Cluster(1 master and 3 slaves)

```
Hadoop v2.7.3
Docker v1.12.5
```

##Using Docker Containers

###1. git clone

```
git clone https://github.com/chming1016/hadoop-cluster-docker.git
```

###2. docker built

```
docker built -it hadoop-spark:cluster <Dockerfile Directory>
```

###3. create hadoop network

```
docker network create --driver=bridge hadoop
```

###4. start all container

sh start-container.sh
```
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
```

###5. start hadoop

```
docker exec -it hadoop-master bash
```

root@hadoop-master:
```
start-all.sh
```