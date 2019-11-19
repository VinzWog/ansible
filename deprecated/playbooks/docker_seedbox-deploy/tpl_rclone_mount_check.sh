#!/bin/bash
# 1. Change paths
# 2. for mount and log file & create mountchek file.
# 3. Add to crontab -e (paste the line bellow, without # in front)
# * * * * *  /home/plex/scripts/rclone-mount-check.sh >/dev/null 2>&1
# Make script executable with: chmod a+x /home/plex/scripts/rclone-mount-check.sh

RCLONE_PATH="/usr/sbin"
LOGFILE="/var/log/rclone-{{ rclone_connection_name }}-mount_check.log"
RCLONEREMOTE="{{ rclone_connection_name }}:"
MPOINT="{{ rclone_mount_point }}"
CHECKFILE="mountcheck.ini"

if pidof -o %PPID -x "$0"; then
    echo "$(date "+%d.%m.%Y %T") EXIT: Already running." | tee -a "$LOGFILE"
    exit 1
fi

if [[ -f "$MPOINT/$CHECKFILE" ]]; then
    echo "$(date "+%d.%m.%Y %T") INFO: Check successful, $MPOINT mounted." | tee -a "$LOGFILE"
    exit
else
    echo "$(date "+%d.%m.%Y %T") ERROR: $MPOINT not mounted, remount in progress." | tee -a "$LOGFILE"
    # Unmount before remounting
    while mount | grep "on ${MPOINT} type" > /dev/null
    do
        echo "($wi) Unmounting {{ rclone_connection_description }}"
        fusermount -uz $MPOINT | tee -a "$LOGFILE"
        cu=$(($cu + 1))
        if [ "$cu" -ge 5 ];then
            echo "$(date "+%d.%m.%Y %T") ERROR: Folder could not be unmounted exit" | tee -a "$LOGFILE"
            exit 1
            break
        fi
        sleep 1
    done
	systemctl start rclone-mount-{{ rclone_connection_name }}.service

    while ! mount | grep "on ${MPOINT} type" > /dev/null
    do
        echo "($wi) Waiting for mount $mount"
        c=$(($c + 1))
        if [ "$c" -ge 4 ] ; then break ; fi
        sleep 1
    done
    if [[ -f "$MPOINT/$CHECKFILE" ]]; then
        echo "$(date "+%d.%m.%Y %T") INFO: Remount successful." | tee -a "$LOGFILE"
    else
      echo "$(date "+%d.%m.%Y %T") CRITICAL: Remount failed." | tee -a "$LOGFILE"
    fi
fi
exit

