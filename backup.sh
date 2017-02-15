#!/bin/bash
# 原作者:ccbikai(miantiao.me)
# 修改者 ecareyu(www.ecareyu.com)


# 修复crontab执行时的报错
cd `dirname $0`

if [ ! -f ./config.ini ]; then
    echo "Please create the config.ini file";
    exit
fi

# 将配置信息存储session
source config.ini

if [ ! -f "$QSHELL" ]; then
    echo "Qshell not found, plese install from this link https://github.com/qiniu/qshell"
    exit
fi

# qshell设置用户
$QSHELL account $QINIU_ACCESS_KEY $QINIU_SECRET_KEY

if [ 0 != $? ]; then
    echo "Authorization error"
    exit;
fi

#精确到秒，统一秒内上传的文件会被覆盖
NOW=$(date +"%Y%m%d%H%M%S") 

mkdir -p $BACKUP_DIR

# 备份Mysql
echo "start dump mysql"
for db_name in $MYSQL_DBS
do
    mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS $db_name > "$BACKUP_DIR/$BACKUP_NAME-$db_name.sql"
done
echo "dump ok"

# 打包
echo "start tar"
BACKUP_FILENAME="$BACKUP_NAME-backup-$NOW.zip"
tarCommand="zip -q -r"

# 判定是否需要密码参数
if [ -n "$BACKUP_FILE_PASSWD" ]; then
    tarCommand="$tarCommand -P $BACKUP_FILE_PASSWD"
fi

$tarCommand $BACKUP_DIR/$BACKUP_FILENAME $BACKUP_DIR/*.sql $BACKUP_SRC
echo "tar ok"

# 上传,默认100条线程,管它呢
echo "start upload"
$QSHELL rput $QINIU_BUCKET $BACKUP_FILENAME $BACKUP_DIR/$BACKUP_FILENAME
echo "upload ok"

# 清理备份文件
rm -rf $BACKUP_DIR
echo "backup clean done"