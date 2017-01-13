{
    "EnvironmentName" : "{{EnvironmentName}}",
    "RegionName" : "us-east-1",
    "AvailabilityZone" : "us-east-1a",
    "KeyPair" : "gemfire-keypair",
    "SSHKeyPath" : "../id_rsa.pem",
    "SecurityGroupId" : "{{SecurityGroupId}}",
    "SubnetId" : "{{SubnetId}}",
    "Servers" : [
    {% for Server in Servers %}
        {
            "Name" : "server{{ Server.Number }}",
            "ImageId" : "ami-6869aa05",
            "InstanceType" : "m4.2xlarge",
            "ServerNumber" : {{ Server.Number }},
            "SSHUser" : "ec2-user",
            "BlockDevices" : [
                {
                    "Size": 10,
                    "Device" : "/dev/xvdf",
                    "MountPoint" : "/runtime",
                    "Owner" : "ec2-user",
                    "FSType" : "ext4",
                    "DeviceType" : "EBS",
                    "EBSVolumeType" : "gp2"
                },
                {
                    "Size": 40,
                    "Device" : "/dev/xvdg",
                    "MountPoint" : "/data",
                    "Owner" : "ec2-user",
                    "FSType" : "ext4",
                    "DeviceType" : "EBS",
                    "EBSVolumeType" : "gp2"
                },
                {
                    "Size": 80,
                    "Device" : "/dev/xvdh",
                    "MountPoint" : "/backup",
                    "Owner" : "ec2-user",
                    "FSType" : "ext4",
                    "DeviceType" : "EBS",
                    "EBSVolumeType" : "gp2"
                }
            ],
            "Installations" : [
                {
                    "Name": "AddHostEntries"
                },
                {
                    "Name": "AptInstallPackages",
                    "Packages": ["gcc","python-pip"]
                },
                {
                    "Name": "PipInstallPackages",
                    "Packages": ["netifaces"]
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
                            "UnpackInDir" : "/runtime",
                            "LinkName" : "java"
                        },
                        {
                            "Name" : "GemFire 8.2.2",
                            "ArchiveURL" : "s3://rmay.pivotal.io.software/Pivotal_GemFire_822_b18324_Linux.tar.gz",
                            "RootDir" : "Pivotal_GemFire_822_b18324_Linux",
                            "UnpackInDir" : "/runtime",
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
                    "ClusterHome" : "/runtime/gem_cluster_1"
                }
            ]
        } {%- if not loop.last %},{% endif %}
        {% endfor %}
    ]
}
