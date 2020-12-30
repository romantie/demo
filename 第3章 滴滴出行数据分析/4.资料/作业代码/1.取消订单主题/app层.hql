-- 分析
-- 1. 今日取消订单笔数
create table if not exists app_didi.t_user_cancel_cnt(
    date string comment '日期',
    total_cnt integer comment '当天总订单笔数'
)
partitioned by (month string comment '年月分区')
row format delimited fields terminated by ','
;

insert overwrite table app_didi.t_user_cancel_cnt partition (month = '2020-04')
select
    '2020-04-12',
    count(orderId)
from
    dw_didi.t_user_cancel_order_wide
where
    dt = '2020-04-12';

-- 2. 取消订单原因分析
create table if not exists app_didi.t_cancel_reason_analysis(
     date string comment '日期',
     reason string comment '取消订单原因',
     total_cnt integer comment '订单笔数'
)
partitioned by (month string comment '年月分区')
row format delimited fields terminated by ','
;

insert overwrite table app_didi.t_cancel_reason_analysis partition (month = '2020-04')
select
    '2020-04-12',
    reason_name,
    count(orderId)
from
    dw_didi.t_user_cancel_order_wide
where
    dt = '2020-04-12'
group by 
    reason_name;