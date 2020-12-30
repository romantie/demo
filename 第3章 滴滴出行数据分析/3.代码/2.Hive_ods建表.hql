-- 创建：用户打车订单表，在ods_didi这个库中创建
-- 1. create table创建表，指定数据库名.表名
-- 2. 添加所有的列（列名 类的类型 comment '注释')
-- 3. 指定分区（按照年月日，按照天来分区，每一天保存数据到一个分区中）
-- 4. 指定使用什么样的分隔符来分隔字段
create table if not exists ods_didi.t_user_order(
    orderId string comment '订单id',
    telephone string comment '打车用户手机',
    long string comment '用户发起打车的经度',
    lat string comment '用户发起打车的纬度',
    province string comment '所在省份',
    city string comment '所在城市',
    es_money double comment '预估打车费用',
    gender string comment '用户信息 - 性别',
    profession string comment '用户信息 - 行业',
    age_range string comment '年龄段（70后、80后、...）',
    tip double comment '小费',
    subscribe integer comment '是否预约（0 - 非预约、1 - 预约）',
    sub_time string comment '预约时间',
    is_agent integer comment '是否代叫（0 - 本人、1 - 代叫）',
    agent_telephone string comment '预约人手机',
    order_time string comment '订单时间'
)
partitioned by (dt string comment '按照年月日，按照天来分区')
row format delimited fields terminated by ',';