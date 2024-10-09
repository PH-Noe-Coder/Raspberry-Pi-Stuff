#!/bin/bash
SHARE="//192.168.100.10/Share"
BACKUP_MOUNT_PATH="/mnt/nas/"
BACKUP_PATH=${BACKUP_MOUNT_PATH}"RaspiBackup"
BACKUP_ANZAHL="5"
BACKUP_NAME="Sicherung"

# Share Mounten
mkdir -p ${BACKUP_MOUNT_PATH}
chmod -R 777 ${BACKUP_MOUNT_PATH}
mount -t cifs -o user=schule,password=schule123,rw,file_mode=0777,dir_mode=0777 ${SHARE} ${BACKUP_MOUNT_PATH}
mkdir -p ${BACKUP_PATH}

#Backup erstellen with pv
dd if=/dev/mmcblk0 | pv | dd of=${BACKUP_PATH}/${BACKUP_NAME}-$(date +%Y-%m-%d).img

#bs=100MB

#Alte Sicherung löschen
pushd ${BACKUP_PATH}; ls -tr ${BACKUP_PATH}/${BACKUP_NAME}* | head -n -${BACKUP_ANZAHL} | xargs rm; popd

#Festplatte auswerfen
umount ${BACKUP_MOUNT_PATH}