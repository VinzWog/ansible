Role Name
=========

Installs acd_cli and mounts your drive to ~/acd. Not extensively tested.

Requirements
------------

You will need to visit https://tensile-runway-92512.appspot.com, sign in with your Amazon account, authorize the application and place the downloaded oauth_data in the files directory of the role prior to running the role.

Role Variables
--------------

acd_mountpoint: The directory to mound the drive into, relative to your home directory.


Example Playbook
----------------

  - hosts: vms
    roles:
      - acd_cli

License
-------

GPLv2

Author Information
------------------