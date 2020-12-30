-- 1. 需求：统计4月12日这一天的总订单数
-- 1.1. 编写HQL进行统计分析
select
    count(*)
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
;

-- 1.2. 在app_didi（app层）数据库中创建一个表，这个表专门用来保存结果数据
-- 1) 表中应该包含哪些字段？
-- 1. 日期，记录是哪一天的总订单数
-- 2. 总订单数
-- 2) 表是否需要分区，按照什么来分区
-- 按照月份来分区，使用年-月来进行分区
create table if not exists app_didi.t_user_order_total_cnt(
    date string comment '日期，记录是哪一天的总订单数',
    total_cnt integer comment '总订单数'
)
partitioned by (month string comment '按照月份来分区，使用年-月来进行分区')
row format delimited fields terminated by ','
;

-- 1.3. 将统计分析后的结果数据保存到这个表中
insert overwrite table app_didi.t_user_order_total_cnt partition(month = '2020-04')
select
    '2020-04-12',
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
;

-- 测试：查询数据是否正确加载到app表中
select * from app_didi.t_user_order_total_cnt where month = '2020-04'
;

-- 1.4 将2020-04-12的订单总数查询出来，并使用zeppelin展示
select * from app_didi.t_user_order_total_cnt where date = '2020-04-12'

-- 2. 预约订单/非预约订单占比分析
-- 2.1 编写HQL分析数据（按照预约字段进行统计分组就可以）
select
    '2020-04-12',
    subscribe_name,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by
    subscribe_name

-- 2.2 在app层创建表用于保存分析后的结果
create table if not exists app_didi.t_user_order_subscribe_analysis(
    date string comment '日期，记录是哪一天的总订单数',
    subscribe_name string comment '是否预约',
    total_cnt integer comment '总订单数'
)
partitioned by (month string comment '按照月份来分区，使用年-月来进行分区')
row format delimited fields terminated by ','
;

-- 2.3 将分析后的数据加载到app层表中
insert overwrite table app_didi.t_user_order_subscribe_analysis partition(month = '2020-04')
select
    '2020-04-12',
    subscribe_name,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by
    subscribe_name
;

-- 2.4 在zeppelin中以饼图的方式展示数据
select * from app_didi.t_user_order_subscribe_analysis where date = '2020-04-12'

-- 统计分析需求：
-- 1. 需求不同时段订单占比分析
-- 1.1 编写HQL分析数据
select
    '2020-04-12',
    order_time_range,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by 
    order_time_range
;

-- 1.2 创建app层表
create table if not exists app_didi.t_user_order_timerange_analysis(
    day string comment '日期记录是哪一天的总订单数',
    time_range string comment '一天的时段',
    total_cnt integer comment '总订单数'
)
partitioned by (month string comment '按照月份来分区，使用年-月来进行分区')
row format delimited fields terminated by ','
;

-- 1.3 将数据加载到app层表中
insert overwrite table app_didi.t_user_order_timerange_analysis partition(month = '2020-12')
select
    '2020-12-15',
    order_time_range,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-12-15'
group by 
    order_time_range
;

-- 1.4 使用zeppelin展示数据
select * from app_didi.t_user_order_timerange_analysis where date = '2020-04-12'

-- 2. 不同地域订单占比分析（省份）
-- 2.1 编写HQL分析数据
select
    '2020-04-12',
    province,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by 
    province
;

-- 2.2 创建app层表
create table if not exists app_didi.t_user_order_province_analysis(
    date string comment '日期，记录是哪一天的总订单数',
    province string comment '省份',
    total_cnt integer comment '总订单数'
)
partitioned by (month string comment '按照月份来分区，使用年-月来进行分区')
row format delimited fields terminated by ','
;

-- 2.3 将数据加载到app层表中
insert overwrite table app_didi.t_user_order_province_analysis partition(month = '2020-04')
select
    '2020-04-12',
    province,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by 
    province
;

-- 2.4 使用zeppelin展示数据
select * from app_didi.t_user_order_province_analysis where date = '2020-04-12'

-- 3. 不同年龄段订单占比分析
-- 3.1 编写HQL分析数据
select
    '2020-04-12',
    age_range,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by 
    age_range
;

-- 3.2 创建app层表
create table if not exists app_didi.t_user_order_age_range_analysis(
    date string comment '日期，记录是哪一天的总订单数',
    age_range string comment '年龄段',
    total_cnt integer comment '总订单数'
)
partitioned by (month string comment '按照月份来分区，使用年-月来进行分区')
row format delimited fields terminated by ','
;

-- 3.3 将数据加载到app层表中
insert overwrite table app_didi.t_user_order_age_range_analysis partition(month = '2020-04')
select
    '2020-04-12',
    age_range,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by 
    age_range
;

-- 2.4 使用zeppelin展示数据
select * from app_didi.t_user_order_age_range_analysis where date = '2020-04-12'


-- 4. 不同城市订单占比分析，只取TOP3（获取打车订单最多的3个城市）
-- 4.1 编写HQL分析数据
select
    '2020-04-12',
    city,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by 
    city
order by
    total_cnt
desc
limit 3
;

-- 3.2 创建app层表
create table if not exists app_didi.t_user_order_top3_city_analysis(
    date string comment '日期，记录是哪一天的总订单数',
    city string comment '城市',
    total_cnt integer comment '总订单数'
)
partitioned by (month string comment '按照月份来分区，使用年-月来进行分区')
row format delimited fields terminated by ','
;

-- 3.3 将数据加载到app层表中
insert overwrite table app_didi.t_user_order_top3_city_analysis partition(month = '2020-04')
select
    '2020-04-12',
    city,
    count(*) as total_cnt
from
    dw_didi.t_user_order_wide
where
    dt = '2020-04-12'
group by 
    city
order by
    total_cnt
desc
limit 3
;

-- 2.4 使用zeppelin展示数据
select * from app_didi.t_user_order_top3_city_analysis where date = '2020-04-12'