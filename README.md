
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Apache Server Low Idle Workers
---

This incident type indicates that the number of idle workers in the Apache server is abnormally low, which may result in slower request processing times. The alert is triggered when the average value of the idle workers metric falls below the predicted values.

### Parameters
```shell
# Environment Variables

export APACHE_CONFIG_FILE_PATH="PLACEHOLDER"

export APACHE_STATUS_URL="PLACEHOLDER"

export MAX_IDLE_WORKERS="PLACEHOLDER"

export NEW_IDLE_WORKER_VALUE="PLACEHOLDER"
```

## Debug

### Check the status of the Apache service
```shell
systemctl status apache2
```

### Check the number of idle workers
```shell
apachectl fullstatus | grep "IdleWorkers"
```

### Check the number of active workers
```shell
apachectl fullstatus | grep "BusyWorkers"
```

### Check the Apache error log for any relevant messages
```shell
tail -n 50 /var/log/apache2/error.log
```

### Check the Apache access log for any relevant messages
```shell
tail -n 50 /var/log/apache2/access.log
```

### Check the amount of free memory
```shell
free -m
```

### Check the cpu usage percentage of the system.
```shell
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'` 
```

### Check the disk usage of the system
```shell
df -h
```

### Check the network traffic on the server
```shell
iftop
```

### Check the number of connections to the server
```shell
netstat -na | grep :80 | wc -l
```

### Higher than normal traffic on the web server causing a higher number of requests and a lower number of idle workers.
```shell


#!/bin/bash



# Define variables

APACHE_STATUS_URL=${APACHE_STATUS_URL}

MAX_REQUESTS=${MAX_REQUESTS}

MAX_IDLE_WORKERS=${MAX_IDLE_WORKERS}



# Get Apache server status

STATUS=$(curl -s $APACHE_STATUS_URL)



# Extract number of requests and idle workers from the server status

REQUESTS=$(echo "$STATUS" | awk '/^Total Accesses/ {print $3}')

IDLE_WORKERS=$(echo "$STATUS" | awk '/^IdleWorkers/ {print $2}')



# Check if the number of requests exceeds the maximum allowed

if [ "$REQUESTS" -gt "$MAX_REQUESTS" ]; then

    echo "Error: Number of requests ($REQUESTS) exceeds maximum allowed ($MAX_REQUESTS)"

fi



# Check if the number of idle workers is below the minimum required

if [ "$IDLE_WORKERS" -lt "$MAX_IDLE_WORKERS" ]; then

    echo "Error: Number of idle workers ($IDLE_WORKERS) is below the minimum required ($MAX_IDLE_WORKERS)"

fi



# Exit with success status

exit 0


```

## Repair

### Backup the original Apache configuration file
```shell
cp ${APACHE_CONFIG_FILE_PATH} ${APACHE_CONFIG_FILE_PATH}.bak
```

### Replace the existing value of the number of idle workers with the desired value
```shell
sed -i 's/${EXISTING_IDLE_WORKER_VALUE}/${NEW_IDLE_WORKER_VALUE}/g' ${APACHE_CONFIG_FILE_PATH}
```

### Restart Apache service to apply the changes
```shell
systemctl restart apache2
```