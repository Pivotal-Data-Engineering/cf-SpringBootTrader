{
    "global-properties":{
        "gemfire": "/runtime/gemfire",
        "java-home" : "/runtime/java",
        "locators" : "192.168.1.101[10000],192.168.1.102[10000]",
        "cluster-home" : "/runtime/gem_cluster_1",
        "distributed-system-id": 1
    },
   "locator-properties" : {
        "remote-locators" : "192.168.1.201[10000],192.168.1.202[10000]",
        "port" : 10000,
        "jmx-manager-port" : 11099,
        "http-service-port" : 17070,
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
        "REMOTE_DISTRIBUTED_SYSTEM_ID" : 2,
        "enable-network-partition-detection" : "true",
        "jvm-options" : ["-Xmx24g","-Xms24g","-Xmn3g", "-XX:+UseConcMarkSweepGC", "-XX:+UseParNewGC", "-XX:CMSInitiatingOccupancyFraction=75"]
    },
    "hosts": {
    {% set firstOne = true %}
    {% for Server in Servers  %}
    {% for Installation in Server.Installations if Installation.Name == 'InstallGemFireCluster' %}
        "ip-192-168-1-{{ Server.ServerNumber }}" : {
            "host-properties" :  {
             },
             "processes" : {
                {% if Server.ServerNumber == 101 or Server.ServerNumber == 102 %}
                "locator{{ Server.ServerNumber }}" : {
                    "type" : "locator",
                    "bind-address" : "192.168.1.{{ Server.ServerNumber }}",
                    "jmx-manager-hostname-for-clients" : "{{ Server.PublicIpAddress }}",
                    "hostname-for-clients" : "{{ Server.PublicIpAddress }}"
                    {% if Server.ServerNumber == 101 %}
                    , "jmx-manager-start" : "true"
                    {% endif %}
                 },
                {% endif %}
                "server{{ Server.ServerNumber }}" : {
                    "type" : "datanode",
                    "server-bind-address" : "192.168.1.{{ Server.ServerNumber }}",
                    "hostname-for-clients" : "{{ Server.PublicIpAddress }}"
                    {% if Server.ServerNumber == 101 %}
                    , "http-service-port": 18080,
                    "start-dev-rest-api" : "true"
                    {% endif %}
                 }
             },
             "ssh" : {
                "host" : "{{ Server.PublicIpAddress }}",
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
