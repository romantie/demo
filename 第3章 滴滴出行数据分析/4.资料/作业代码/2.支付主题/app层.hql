--总支付金额/总优惠券金额/用户打赏总金额
create table if not exists app_didi.t_user_pay_order_total_cnt(
    date string comment '时间',
    total_pay_money double comment '总支付金额',
    total_coupon_money double comment '总优惠券金额',
    total_add_money double comment '用户打赏金额'
)
partitioned by (month string comment '按照年月分区')
row format delimited fields terminated by ',';

insert overwrite table app_didi.t_user_pay_order_total_cnt partition(month = '2020-04')
select
    '2020-04-12',
    sum(real_pay_money),                -- 总支付金额
    sum(coupon_total),                  -- 总优惠券金额
    sum(passenger_additional_money)     -- 总用户打赏金额
from 
    dw_didi.t_user_pay_order_wide
where
    dt = '2020-04-12';

--不同支付方式订单总额分析
create table if not exists app_didi.t_user_pay_order_payway_analysis(
    date string comment '时间',
    pay_way string comment '支付方式',
    pay_money double comment '总支付金额'
)
partitioned by (month string comment '按照年月分区')
row format delimited fields terminated by ',';

insert overwrite table app_didi.t_user_pay_order_payway_analysis partition(month = '2020-04')
select
    '2020-04-12',
    pay_way_name,                       -- 支付方式
    sum(real_pay_money)                -- 总支付金额
from 
    dw_didi.t_user_pay_order_wide
where
    dt = '2020-04-12'
group by pay_way_name;

select * from app_didi.t_user_pay_order_payway_analysis;

--不同区域支付总额分析
create table if not exists app_didi.t_user_pay_order_region_analysis(
    date string comment '日期',
    province string comment '省份',
    total_money double comment '总支付金额'
)
partitioned by (month string comment '按照年月分区')
row format delimited fields terminated by ',';

insert overwrite table app_didi.t_user_pay_order_region_analysis  partition(month = '2020-04')
select
    '2020-04-12',
    province,                           -- 省份
    sum(real_pay_money)                 -- 总支付金额
from 
    dw_didi.t_user_pay_order_wide
where
    dt = '2020-04-12'
group by province;

select * from app_didi.t_user_pay_order_region_analysis;