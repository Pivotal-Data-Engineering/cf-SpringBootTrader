{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    {######### Server Definitions ###########}
    {% for Server in Servers %}
    "{{ Server.Name }}" : {
      "Type" : "AWS::EC2::Instance",
      "Properties" : {
         "AvailabilityZone" : "{{ AvailabilityZone }}",
         "EbsOptimized" : true,
         "ImageId" : "{{ Server.ImageId }}",
         "InstanceInitiatedShutdownBehavior" : "stop",
         "InstanceType" : "{{ Server.InstanceType }}",
         "KeyName" : "{{ KeyPair }}",
         "PrivateIpAddress" : "192.168.1.{{ Server.ServerNumber }}",
         "SecurityGroupIds" : [ "{{SecurityGroupId}}"],
         "SubnetId" : "{{SubnetId}}",
         "Tags" : [
            {
              "Key": "Name",
              "Value" : "{{ EnvironmentName }}Server{{ Server.Name }}"
            },
            {
              "Key": "Environment",
              "Value" : "{{ EnvironmentName }}"
            }
          ],
          {#### ESB Volumes Are Attached Here ####}
         "Volumes" : [
         {% for Device in Server.BlockDevices if Device.DeviceType == 'EBS' %}
          {
            "Device" : "{{ Device.Device }}",
            "VolumeId" : "{{ Device.EBSVolumeId }}"
          }
        {% if not loop.last %},{% endif %}
        {% endfor %}
         ] ,
         {#### Ephemeral Volumes are Mapped Here ####}
         "BlockDeviceMappings" : [
         {% for Device in Server.BlockDevices if Device.DeviceType == 'Ephemeral' %}
            {
              "DeviceName" : "{{ Device.Device }}",
              "VirtualName" : "ephemeral{{ loop.index0 }}"
            } {% if not loop.last %},{% endif %}
          {% endfor %}
         ]
      }
    }
    {% if not loop.last %}, {% endif %}
    {% endfor %}
  },
  "Description": "{{ EnvironmentName }} Stack"
}
