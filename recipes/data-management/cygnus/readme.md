# Cygnus

Here you can find recipes aimed at different usages of Cygnus, in particular, cygnus-ngsi. We assume you are already familiar with it, but if not, refer to the [official documentation](http://fiware-cygnus.readthedocs.io/en/latest/index.html).

If you are new to docker as well you probably want to start looking at the [simple recipe](./simple/readme.md) to have a first view of how using cygnus in a single-host simple scenario looks like.

Instructions on how to prepare your environment to test these recipes are given in [https://github.com/martel-innovate/smartsdk-recipes](https://github.com/martel-innovate/smartsdk-recipes).


## Considerations for HA

The first thing to note is that when we talk about high availability while using cygnus, we refer to the availability of data processed by cygnus agents before it's dropped to the final storage solution. So, as you can read from the [official documentation](http://fiware-cygnus.readthedocs.io/en/latest/index.html), different sinks can give you persistence in different storage solutions (mongodb, mysql, hdfs, etc). Keeping the persisted data in HA mode is a different challenge and the implementation will depend on the used solution. For the case of MongoDB, you can have a look at the [MongoDB Replicaset Recipe](../../utils/mongodb/replica/readme.md). The recipes will show you how to connect to some backends, but how you manage them is up to you.

Moreover, we will be discussing the deployment of the agent as a single configurable entity. But note that within an agent, there exist multiple available configurations (using single and multiple sources, channels and sinks), as described in [Advanced Cygnus Architectures](http://fiware-cygnus.readthedocs.io/en/latest/architecture/index.html#advanced-cygnus-architectures). How you setup those internal advanced architectures and the advantages of each will not be covered here, since this is already discussed in the official documentation.

That being said, in order to deploy Cygnus, we need to understand whether it's a stateless or stateful service. It turns out that source and sink parts of the agent do not persist data, however, the channels do, at least for a short period of time until data is processed and taken out of the channel by the sink[s]. As you can read from Cygnus and Flume's documentation, channels come in the form of MemoryChannel and FileChannel.

It's easy to see that MemoryChannel and Batching has a potential for data loss, for example, in the case when an agent crashes before events were taken out of the channel. In fact, to avoid storage access for each event, Cygnus comes with default values of batch size and batch flush timeouts. As a side note, it'd be nice if this could be dynamically changed according to dynamic demands, but this is an interesting point to investigate at a later point.

Therefore, the FileChannel could be used, at the cost of a higher latency, to give persistence to the "inflight data" and this way prevent a complete loss if there happens to be a software failure/crash at the agent. In the case of Cygnus running on a Docker Swarm, you would need to make sure that swarm restarts the service on the same node so as to keep using to the same file.

In any way, even with a FileChannel, if the failure happens at the node level (rather than agent software level), the channel file would be lost anyway and the data loss would be unavoidable. Keeping an on-the-fly cross-nodes replication of FileChannel would probably be inefficient and too much of an overhead. Instead, a whole duplication of the agent running in another node may be a more feasible (though expensive) solution in the need of such care regarding data losses. In this scenario, to keep the data replicated in different instances spread across different nodes, you would need to bypass swarm's load balancer because you'd need the notifications to be redirected to all the agents instead of being sent in round-robin to only one.

A different approach might be looking for Message-based solutions such as Solace to be used at the Channel level. But this of course, would involve some updates to Cygnus which are beyond the scope of this project.

<img src='http://g.gravizo.com/g?
  digraph G {
      rankdir=LR;
      	compound=true;
      	node [shape="record" style="filled"];
      	splines=line;
      	Client [fillcolor="aliceblue"];
      	subgraph cluster {
      		label="Docker Swarm Cluster";
      		"Load Balancer" [fillcolor="aliceblue"];
            subgraph clustern2 {
          		label="Node 2";
                "Cygnus Agent 2" [fillcolor="aliceblue"];
            }
            subgraph clustern1 {
          		label="Node 1";
                "Cygnus Agent" [fillcolor="aliceblue"];
            }
  			DB [fillcolor="aliceblue"];
      	}
      	Client -> "Load Balancer" [label="1026",lhead=cluster_0];
      	"Load Balancer" -> {"Cygnus Agent","Cygnus Agent 2"};
      	"Cygnus Agent" -> DB [lhead=cluster_1];
      	"Cygnus Agent 2" -> DB [lhead=cluster_1];
  }
'>
