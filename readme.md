# VRising Server 

Server using wine and steamcmd as base image. 
Stuff you probably want to mount: 
    - /vrising/persistentdata/Saves - progress saves 
    - /vrising/logs  - server & wine logs 
    - /vrising/persistentdata/Settings - Server and Host settings 
All of the above are in docker-compose for reference. 

All the server settings can be changed in vrising/persistantdata/Settings files (or if you're using docker-compose simply settings).
If change port or queryport make sure to update your port forwarding.

You can update your timezone but setting environemt variable TZ to [tzdata](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) values.