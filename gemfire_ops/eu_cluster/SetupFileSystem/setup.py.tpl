import os
import os.path
import pwd
import sys


ip='{{ Servers[ServerNum].PublicIpAddress }}'

if __name__ == '__main__':
{% for Directory in Servers[ServerNum].Installations[InstallationNum].Directories %}
   path = '{{ Directory.Path }}'
   {% if Directory.Owner %}
   owner = '{{Directory.Owner}}'
   {% else %}
   owner = None
   {% endif %}
   
   if os.path.isdir(path):
      print "{0} - directory {1} already exists, continuing".format(ip, path)
   else:
      os.makedirs(path)
      
   if owner is not None:
      try:
         uidentry = pwd.getpwnam(owner)
         os.chown(path, uidentry[2],uidentry[3])
      except KeyError:
         sys.exit('{0} - no user named "{1}" exists'.format(ip, owner))
      
   print '{0} - created path: {1} owned by {2}'.format(ip,path, owner)
{% endfor %}