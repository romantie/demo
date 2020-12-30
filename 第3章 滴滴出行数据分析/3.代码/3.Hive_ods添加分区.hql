-- 给ods_didi.t_user_order添加一个2020-04-12的分区
alter table ods_didi.t_user_order add if not exists partition (dt='2020-04-12');

show partitions ods_didi.t_user_order;