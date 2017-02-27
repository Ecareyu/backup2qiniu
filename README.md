# 备份网站到七牛

由于原来的工具貌似我机器不能玩，不知道为什么，
上传完成后也没到七牛上，本来决定自己用php搞一个，
后来发现七牛提供了很好的工具，所以还是不重复造轮子，直接拿来用。

# 依赖
* qshell [下载](https://github.com/qiniu/qshell)
* zip


# 配置
1. 下载七牛qshell工具
2. 拷贝config.ini.backup为config.ini
3. 按照说明修改配置

# 使用
```bash
sudo chmod +x backup.sh
./backup.sh
```

# 定时备份
```bash
crontab -e

# 填入以下,每天凌晨两点执行一次备份,这里可以根据活跃度进行调整
0 2 * * * /bin/bash /foo/backup.sh

# 我这边网站不活跃，这里配置成每月备份一次
* * * 1 * /bin/bash /foo/backup.sh
```

# 更新说明
* [issue-#1](https://github.com/Ecareyu/backup2qiniu/issues/1) 增加子目录配置项,为空时获取服务器hostname作为子目录名

# 参考
[backuptoqiniu](https://github.com/ccbikai/backuptoqiniu)