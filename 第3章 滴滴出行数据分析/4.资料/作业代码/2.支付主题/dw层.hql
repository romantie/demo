-- 创建dw层宽表
-- drop table dw_didi.t_user_pay_order_wide;
create table if not exists dw_didi.t_user_pay_order_wide(
    ID string comment '支付订单ID',
    orderId string comment '订单ID',
    longitude string comment '目的地的经度（支付地址）',
    latitude string comment '目的地的纬度（支付地址）',
    province string comment '省份',
    city string comment '城市',
    total_money double comment '车费总价',
    real_pay_money double comment '实际支付总额',
    passenger_additional_money double comment '乘客额外加价',
    base_money double comment '车费合计',
    has_coupon integer comment '是否使用优惠券（0 - 不使用、1 - 使用）',
    has_coupon_name string comment '是否使用优惠券（不使用、使用)',
    coupon_total string comment '优惠券合计',
    pay_way integer comment '支付方式（0 - 微信支付、1 - 支付宝支付、2 - QQ钱包支付、3 - 一网通银行卡支付）',
    pay_way_name string comment '支付方式名称',
    mileage string comment '里程（单位公里）',
    pay_time string comment '支付时间',
    pay_date string comment '支付日期'
)
partitioned by (dt string comment '年月日分区' )
row format delimited fields terminated by ',';

-- ods层数据进行拉宽后处理
insert overwrite table dw_didi.t_user_pay_order_wide partition(dt = '2020-04-12')
select
    ID,
    orderId,
    lng,
    lat,
    province,
    city,
    total_money,
    real_pay_money,
    passenger_additional_money,
    base_money,
    has_coupon,
    case when has_coupon = 1 then '使用优惠券'
         when has_coupon = 0 then '不使用优惠券'
    end,
    coupon_total,
    pay_way,
    case when pay_way = 0 then '微信支付'
         when pay_way = 1 then '支付宝支付'
         when pay_way = 2 then 'QQ钱包支付'
         when pay_way = 3 then '一网通银行卡支付'
         else '其他方式'
    end,
    mileage,
    pay_time,
    date_format(pay_time, 'yyyy-MM-dd')
from
    ods_didi.t_user_pay_order
where 
    dt = '2020-04-12' and total_money is not null;