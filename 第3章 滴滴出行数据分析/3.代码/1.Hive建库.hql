-- 在Hive中创建数据库用来保存不同分类的数据
-- 1. 原始日志数据对应的数据库
create database if not exists ods_didi;

-- 2. 预处理之后的数据对应的数据库
create database if not exists dw_didi;

-- 3. 分析结果数据对应的数据库
create database if not exists app_didi;

-- 使用VSCode的列编辑来进行批量操作
-- 进入列编辑快键键：alt + shift + 拉动鼠标左键

-- 使用beeline连接Hive
-- [root@node1 bin]# cd /export/server/spark-2.3.0-bin-hadoop2.7/bin/
-- [root@node1 bin]# ./beeline
-- Beeline version 1.2.1.spark2 by Apache Hive
-- beeline> !connect jdbc:hive2://node1.itcast.cn:10000
-- Connecting to jdbc:hive2://node1.itcast.cn:10000
-- Enter username for jdbc:hive2://node1.itcast.cn:10000: root
-- Enter password for jdbc:hive2://node1.itcast.cn:10000:
-- 2020-08-09 11:02:23 INFO  Utils:310 - Supplied authorities: node1.itcast.cn:10000
-- 2020-08-09 11:02:23 INFO  Utils:397 - Resolved authority: node1.itcast.cn:10000
-- 2020-08-09 11:02:23 INFO  HiveConnection:203 - Will try to open client transport with JDBC Uri: jdbc:hive2://node1.itcast.cn:10000
-- Connected to: Spark SQL (version 2.3.0)
-- Driver: Hive JDBC (version 1.2.1.spark2)
-- Transaction isolation: TRANSACTION_REPEATABLE_READ
-- 0: jdbc:hive2://node1.itcast.cn:10000>

-- 查看数据库是否创建成功
0: jdbc:hive2://node1.itcast.cn:10000> show databases;
+---------------+--+
| databaseName  |
+---------------+--+
| app_didi      |
| default       |
| dw_didi       |
| myhive        |
| ods_didi      |
+---------------+--+
5 rows selected (0.013 seconds)
