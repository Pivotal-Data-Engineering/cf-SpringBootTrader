{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "VPC" : {
       "Type" : "AWS::EC2::VPC",
       "Properties" : {
          "CidrBlock" : "192.168.1.0/24",
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{EnvironmentName}}VPC"
            }
          ]
       }
    },
    "PublicSubnet" : {
      "Type" : "AWS::EC2::Subnet",
      "Properties" : {
         "AvailabilityZone" : "{{AvailabilityZone}}",
         "CidrBlock" : { "Fn::GetAtt" : ["VPC","CidrBlock"]},
         "MapPublicIpOnLaunch" : true,
          "Tags" : [
            {
              "Key": "Name",
              "Value": "{{EnvironmentName}}Subnet"
            }
          ],
         "VpcId" : { "Ref" : "VPC" }
      }
    },
    "InternetGateway":{
      "Type" : "AWS::EC2::InternetGateway",
      "Properties" : {
        "Tags" : [
          {
            "Key": "Name",
            "Value": "{{EnvironmentName}}InternetGateway"
          }
        ]
      }
    },
    "RouteTable" : {
      "Type" : "AWS::EC2::RouteTable",
      "Properties" : {
        "VpcId" : {"Ref": "VPC"},
        "Tags" : [
          {
            "Key": "Name",
            "Value" : "{{EnvironmentName}}RouteTable"
          }
        ]
      }
    },
    "RouteToInternet" : {
      "Type" : "AWS::EC2::Route",
      "Properties" : {
        "DestinationCidrBlock" : "0.0.0.0/0",
        "GatewayId" : {"Ref": "InternetGateway"},
        "RouteTableId" : {"Ref":  "RouteTable"}
      },
      "DependsOn": ["VPCGatewayAttachment"]
    },
    "PublicSubnetRouteTableAssociation" : {
      "Type" : "AWS::EC2::SubnetRouteTableAssociation",
      "Properties" : {
         "RouteTableId" : {"Ref" : "RouteTable"},
         "SubnetId" : {"Ref" : "PublicSubnet"}
      }
    },
    "VPCGatewayAttachment":{
      "Type" : "AWS::EC2::VPCGatewayAttachment",
      "Properties" : {
         "InternetGatewayId" : {"Ref" : "InternetGateway"  },
         "VpcId" : {"Ref" : "VPC"}
      }
    },
    "SecurityGroup":{
      "Type" : "AWS::EC2::SecurityGroup",
      "Properties" : {
         "GroupDescription" : "{{EnvironmentName}}SecurityGroup",
         "VpcId" : {"Ref" : "VPC"},
         "SecurityGroupIngress" : [
            {
              "IpProtocol" : "-1",
               "CidrIp" : { "Fn::GetAtt": ["VPC","CidrBlock"]}
            },
            {
              "IpProtocol" : "tcp",
               "FromPort" : "22",
               "ToPort" : "22",
               "CidrIp" : "0.0.0.0/0"
            },
            {
              "IpProtocol" : "tcp",
               "FromPort" : "10000",
               "ToPort" : "19999",
               "CidrIp" : "0.0.0.0/0"
            }
          ],
          "Tags" : [
            {
              "Key": "Name",
              "Value" : "{{EnvironmentName}}SecurityGroup"
            }
          ]
      }

    }
  },
  "Description": "PFC GemFire Trader Network"
}
