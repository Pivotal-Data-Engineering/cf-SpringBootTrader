{
    "SSHKeyPath" : "/home/rmay/gemfire_ops/id_rsa.pem",
    "Servers" : [
    {% for Server in Servers %}
        {
            "Name" : "server{{ Server.Number }}",
            "ServerNumber" : {{ Server.Number }},
            "SSHUser" : "rmay",
            "Installations" : [
                {
                    "Name": "AddHostEntries"
                },
                {
                    "Name": "AptInstallPackages",
                    "Packages": ["gcc","python-pip", "unzip"]
                },
                {
                    "Name": "PipInstallPackages",
                    "Packages": ["netifaces","awscli"]
                },
                {
                    "Name": "SetupFileSystem",
                    "Directories" : [
                        {
                            "Path" : "/home/rmay/runtime",
                            "Owner" : "rmay"
                        }
                    ]
                },
                {
                    "Name" : "CopyArchives",
                    "AWSAccessKeyId" : "AKIAJXWLAUH63ULBFOPA",
                    "AWSSecretAccessKey" : "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",
                    "AWSS3Region" : "us-west-2",
                    "Archives" : [
                        {
                            "Name" : "JDK 1.8.0_92",
                            "ArchiveURL" : "s3://rmay.pivotal.io.software/jdk-8u92-linux-x64.tar.gz",
                            "RootDir" : "jdk1.8.0_92",
                            "UnpackInDir" : "/home/rmay/runtime",
                            "LinkName" : "java"
                        },
                        {
                            "Name" : "GemFire 8.2.2",
                            "ArchiveURL" : "s3://rmay.pivotal.io.software/Pivotal_GemFire_822_b18324_Linux.tar.gz",
                            "RootDir" : "Pivotal_GemFire_822_b18324_Linux",
                            "UnpackInDir" : "/home/rmay/runtime",
                            "LinkName" : "gemfire"
                        }
                    ]
                },
                {
                    "Name" : "ConfigureProfile",
                    "Owner" : "rmay"
                }
                , {
                    "Name" : "InstallGemFireCluster",
                    "AWSAccessKeyId" : "AKIAJXWLAUH63ULBFOPA",
                    "AWSSecretAccessKey" : "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",
                    "AWSS3Region" : "us-west-2",
                    "ClusterScriptsS3Bucket": "s3://rmay.pivotal.io.software/gemfire-manager-1.5.zip",
                    "GemToolsS3Bucket": "s3://rmay.pivotal.io.software/gemfire-toolkit-1.0-runtime.tar.gz",
                    "ClusterHome" : "/home/rmay/runtime/gem_cluster_1"
                }
            ]
        } {%- if not loop.last %},{% endif %}
        {% endfor %}
    ]
}
