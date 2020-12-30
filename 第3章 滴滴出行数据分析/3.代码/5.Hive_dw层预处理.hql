-- 一. 针对打车订单进行预处理开发
-- 1. 创建dw层打车订单宽表
create table if not exists dw_didi.t_user_order_wide(
    orderId string comment '订单id',
    telephone string comment '打车用户手机',
    lng string comment '用户发起打车的经度',
    lat string comment '用户发起打车的纬度',
    province string comment '所在省份',
    city string comment '所在城市',
    es_money double comment '预估打车费用',
    gender string comment '用户信息',
    profession string comment '用户信息',
    age_range string comment '年龄段（70后、80后、',
    tip double comment '小费',
    subscribe integer comment '是否预约（0 - 非预约、1 - 预约）',
    subscribe_name string comment '是否预约名称',
    sub_time string comment '预约时间',
    is_agent integer comment '是否代叫（0 - 本人、1 - 代叫）',
    is_agent_name string comment '是否代叫名称',
    agent_telephone string comment '预约人手机',
    order_date string comment '预约日期，yyyy-MM-dd',
    order_year integer comment '年',
    order_month integer comment '月',
    order_day integer comment '日',
    order_hour integer comment '小时',
    order_time_range string comment '时间段',
    order_time string comment '预约时间'
)
partitioned by (dt string comment '按照年月日来分区')
row format delimited fields terminated by ','
;

-- 编写HQL进行数据的预处理
-- 1. 编写select语句将ods层t_user_order的数据进行预处理
-- 1.1. 过滤掉order_time长度小于8的数据，如果小于8，表示这条数据不合法，不应该参加统计。
select
    *
from
    ods_didi.t_user_order
where
    dt = '2020-04-12' and
    length(order_time) >= 8
-- 1.2. 将一些0、1表示的字段，处理为更容易理解的字段。
-- 例如：subscribe字段，0表示非预约、1表示预约。我们需要添加一个额外的字段，用来展示非预约和预约，这样将来我们分析的时候，跟容易看懂数据。
select
    orderId,
    telephone,
    long,
    lat,
    province,
    city,
    es_money,
    gender,
    profession,
    age_range,
    tip,
    subscribe,
    case when subscribe = 0 then '非预约'
         when subscribe = 1 then '预约'
    end as subscribe_name,
    sub_time,
    is_agent,
    case when is_agent = 0 then '本人'
         when is_agent = 1 then '代叫'
    end as is_agent_name,
    agent_telephone,
    order_time
from
    ods_didi.t_user_order
where
    dt = '2020-04-12' and
    length(order_time) >= 8

-- 1.3. order_time字段为2020-4-12 1:15，为了将来更方便处理，我们统一使用类似 2020-04-12 01:15来表示，这样所有的order_time字段长度是一样的。
-- 并且将日期获取出来
-- 使用date_format日期函数来处理
select
    orderId,
    telephone,
    long,
    lat,
    province,
    city,
    es_money,
    gender,
    profession,
    age_range,
    tip,
    subscribe,
    case when subscribe = 0 then '非预约'
         when subscribe = 1 then '预约'
    end as subscribe_name,
    sub_time,
    is_agent,
    case when is_agent = 0 then '本人'
         when is_agent = 1 then '代叫'
    end as is_agent_name,
    agent_telephone,
    date_format(order_time, 'yyyy-MM-dd') as order_date,
    date_format(order_time, 'yyyy-MM-dd HH:mm') as order_time
from
    ods_didi.t_user_order
where
    dt = '2020-04-12' and
    length(order_time) >= 8

-- 1.4. 为了方便将来按照年、月、日、小时统计，我们需要新增这几个字段。
select
    orderId,
    telephone,
    long,
    lat,
    province,
    city,
    es_money,
    gender,
    profession,
    age_range,
    tip,
    subscribe,
    case when subscribe = 0 then '非预约'
         when subscribe = 1 then '预约'
    end as subscribe_name,
    sub_time,
    is_agent,
    case when is_agent = 0 then '本人'
         when is_agent = 1 then '代叫'
    end as is_agent_name,
    agent_telephone,
    date_format(order_time, 'yyyy-MM-dd') as order_date,
    year(order_time) as year,
    month(order_time) as month,
    day(order_time) as day,
    hour(order_time) as hour,
    date_format(order_time, 'yyyy-MM-dd HH:mm') as order_time
from
    ods_didi.t_user_order
where
    dt = '2020-04-12' and
    length(order_time) >= 8

-- 1.5. 根据订单的下单时间，来判断当前的订单是属于一天中的哪个时间段。映射关系：
-- 1：00 – 5:00	凌晨
-- 5:00 – 8:00	早上
-- 8:00 – 11:00	上午
-- 11:00 – 13:00	中午
-- 13:00 – 17:00	下午
-- 17:00 – 19:00	晚上
-- 19:00 – 20:00	半夜
-- 21:00 – 24:00	深夜
-- 0:00 – 1:00	凌晨
select
    orderId,
    telephone,
    long,
    lat,
    province,
    city,
    es_money,
    gender,
    profession,
    age_range,
    tip,
    subscribe,
    case when subscribe = 0 then '非预约'
         when subscribe = 1 then '预约'
    end as subscribe_name,
    sub_time,
    is_agent,
    case when is_agent = 0 then '本人'
         when is_agent = 1 then '代叫'
    end as is_agent_name,
    agent_telephone,
    date_format(order_time, 'yyyy-MM-dd') as order_date,
    year(order_time) as year,
    month(order_time) as month,
    day(order_time) as day,
    hour(order_time) as hour,
    case when hour(order_time) >= 1 and hour(order_time) < 5 then '凌晨'
        when hour(order_time) >= 5 and hour(order_time) < 8 then '早上'
        when hour(order_time) >= 8 and hour(order_time) < 11 then '上午'
        when hour(order_time) >= 11 and hour(order_time) < 13 then '中午'
        when hour(order_time) >= 13 and hour(order_time) < 17 then '下午'
        when hour(order_time) >= 17 and hour(order_time) < 19 then '晚上'
        when hour(order_time) >= 19 and hour(order_time) < 20 then '半夜'
        when hour(order_time) >= 20 and hour(order_time) < 24 then '深夜'
        when hour(order_time) >= 0 and hour(order_time) < 1 then '凌晨'
    end as order_time_range,
    date_format(order_time, 'yyyy-MM-dd HH:mm') as order_time
from
    ods_didi.t_user_order
where
    dt = '2020-04-12' and
    length(order_time) >= 8

-- 2. 将预处理后的数据加载到dw成的宽表中
insert overwrite table dw_didi.t_user_order_wide partition(dt = '2020-12-15')
select
    orderId,
    telephone,
    long,
    lat,
    province,
    city,
    es_money,
    gender,
    profession,
    age_range,
    tip,
    subscribe,
    case when subscribe = 0 then '非预约'
         when subscribe = 1 then '预约'
    end as subscribe_name,
    sub_time,
    is_agent,
    case when is_agent = 0 then '本人'
         when is_agent = 1 then '代叫'
    end as is_agent_name,
    agent_telephone,
    date_format(order_time, 'yyyy-MM-dd') as order_date,
    year(order_time) as year,
    month(order_time) as month,
    day(order_time) as day,
    hour(order_time) as hour,
    case when hour(order_time) >= 1 and hour(order_time) < 5 then '凌晨'
        when hour(order_time) >= 5 and hour(order_time) < 8 then '早上'
        when hour(order_time) >= 8 and hour(order_time) < 11 then '上午'
        when hour(order_time) >= 11 and hour(order_time) < 13 then '中午'
        when hour(order_time) >= 13 and hour(order_time) < 17 then '下午'
        when hour(order_time) >= 17 and hour(order_time) < 19 then '晚上'
        when hour(order_time) >= 19 and hour(order_time) < 20 then '半夜'
        when hour(order_time) >= 20 and hour(order_time) < 24 then '深夜'
        when hour(order_time) >= 0 and hour(order_time) < 1 then '凌晨'
    end as order_time_range,
    date_format(order_time, 'yyyy-MM-dd HH:mm') as order_time
from
    ods_didi.t_user_order
where
    dt = '2020-12-15' and
    length(order_time) >= 8
;

-- 验证数据是否已经成功加载到dw层的宽表中
select * from dw_didi.t_user_order_wide limit 10