# 1. 将用户订单数据上传到分区对应的HDFS路径
hadoop fs -put /root/data/didi/order.csv /user/hive/warehouse/ods_didi.db/t_user_order/dt=2020-04-12

# 测试查询用户订单的数据
select * from ods_didi.t_user_order where dt = '2020-04-12'

