#
# Copyright (c) 2015-2016 Pivotal Software, Inc. All Rights Reserved.
#
import shutil

if __name__ == '__main__':
    ip = '10.193.138.104'
    shutil.copyfile('/tmp/setup/hosts', '/etc/hosts')
    print '{0} - added hostname entry to hosts file'.format(ip)