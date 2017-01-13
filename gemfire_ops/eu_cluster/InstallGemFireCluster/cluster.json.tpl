{
    "global-properties":{
        "gemfire": "/home/rmay/runtime/gemfire",
        "java-home" : "/home/rmay/runtime/java",
        "locators" : "gem4[10000],gem5[10000]",
        "cluster-home" : "/home/rmay/runtime/gem_cluster_1",
        "distributed-system-id": 2
    },
   "locator-properties" : {
        "remote-locators" : "gem1[10000],gem2[10000]",
        "port" : 10000,
        "jmx-manager-port" : 11099,
        "http-service-port" : 8080,
        "jmx-manager" : "true",
        "log-level" : "config",
        "statistic-sampling-enabled" : "true",
        "statistic-archive-file" : "locator.gfs",
        "log-file-size-limit" : "10",
        "log-disk-space-limit" : "100",
        "archive-file-size-limit" : "10",
        "archive-disk-space-limit" : "100",
        "enable-network-partition-detection" : "true",
        "jvm-options" : ["-Xmx2g","-Xms2g", "-XX:+UseConcMarkSweepGC", "-XX:+UseParNewGC"]
    },
   "datanode-properties" : {
        "cache-xml-file" : "../config/cluster.xml",
        "conserve-sockets" : false,
        "log-level" : "config",
        "membership-port-range" : "10901-10999",
        "statistic-sampling-enabled" : "true",
        "statistic-archive-file" : "datanode.gfs",
        "log-file-size-limit" : "10",
        "log-disk-space-limit" : "100",
        "archive-file-size-limit" : "10",
        "archive-disk-space-limit" : "100",
        "tcp-port" : 10001,
        "server-port" : 10100,
        "GATEWAY_RECEIVER_PORT" : 15000,
        "REMOTE_DISTRIBUTED_SYSTEM_ID" : 1,
        "enable-network-partition-detection" : "true",
        "jvm-options" : ["-Xmx10g","-Xms10g","-Xmn1g", "-XX:+UseConcMarkSweepGC", "-XX:+UseParNewGC", "-XX:CMSInitiatingOccupancyFraction=85"]
    },
    "hosts": {
    {% set firstOne = true %}
    {% for Server in Servers  %}
    {% for Installation in Server.Installations if Installation.Name == 'InstallGemFireCluster' %}
        "gem{{ Server.ServerNumber - 101 }}" : {
            "host-properties" :  {
             },
             "processes" : {
                {% if Server.ServerNumber == 105 or Server.ServerNumber == 106 %}
                "locator{{ Server.ServerNumber }}" : {
                    "type" : "locator",
                    "bind-address" : "10.193.138.{{ Server.ServerNumber }}"
                    {% if Server.ServerNumber == 105 %}
                    , "jmx-manager-start" : "true"
                    {% endif %}
                 },
                {% endif %}
                "server{{ Server.ServerNumber }}" : {
                    "type" : "datanode",
                    "server-bind-address" : "10.193.138.{{ Server.ServerNumber }}"
                    {% if Server.ServerNumber == 107 %}
                    , "http-service-port": 8080,
                    "start-dev-rest-api" : "true"
                    {% endif %}
                 }
             },
             "ssh" : {
                "host" : "10.193.138.{{ Server.ServerNumber }}",
                "user" : "{{ Server.SSHUser }}",
                "key-file" : "{{ SSHKeyPath }}"
             }
        },
    {% endfor %}
    {% endfor %}
        "dummy" : {
            "processes": []
        }
   }
}
