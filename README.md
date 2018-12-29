# ansible-redis-sentinel-stunnel
This playbook installed Redis 4.0.10 along with Sentinel with master/slave mode. Redis does not natively support the SSL hence Stunnel is used for SSL/TLS 


# Pre-requisities

  - **Need atleast three nodes one master and two slaves


  - **Need to copy SSL/TLS certificates & Key
  
    - Name them as server.key and server.crt
    
    - place them in the playbookfolder/install/roles/redis/files/<env>/, where env variable
  
  - **Variables (see below)
  
    - Need lot of variables to define 

# Installation

  git clone <>

# **List of Variables**

Change the following variables in install/group_vars file
  ansible_system_user: root
  
  epel_repo: https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.
  
  subnet: 108
  
  env: stg
  
  domain: localdomain
  
  master_node: x.x.x.x
  
  masterauthpwd: inputpasswordhere 
  
  clientauthpwd: inputpasswordhere 
  
  cluster_name: redis-{{ env }}-cluster 
  
  vipaddress: x.x.x.x
  
  data_dir: /redis1/data
  

# Run the Playbook
  - ansible-playbook -i hosts install/redis.yml
  
# Few Notes
- Ports used
  
  - Redis 6379
  - Sentinel 16379
  - Stunnel 6380

- Applications will connect to 6380 port through a VIP IP address and VIP address will float to another master in case of primary fails through a script called /opt/redis-4.0.10/src/redis_switch_state.sh

- Password is used to connect to redis service, which is input through variable
