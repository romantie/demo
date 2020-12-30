--------------------------------
-- dw层数据预处理

-- 创建dw层宽表
create table if not exists dw_didi.t_user_cancel_order_wide(
    orderId string comment '订单ID',
    cstm_telephone string comment '客户联系电话',
    lng string comment '取消订单的经度',
    lat string comment '取消订单的纬度',
    province string comment '所在省份',
    city string comment '所在城市',
    es_distance double comment '预估距离',
    gender string comment '性别',
    profession string comment '行业',
    age_range string comment '年龄段',
    reason integer comment '取消订单原因（1 - 选择了其他交通方式、2 - 与司机达成一致，取消订单、3 - 投诉司机没来接我、4 - 已不需要用车、5 - 无理由取消订单）',
    reason_name string comment '取消订单原因名称',
    cancel_time string comment '取消时间',
    cancel_date string comment '格式化取消日期'
)
partitioned by (dt string comment '时间分区')
row format delimited fields terminated by ','
;

-- load data local inpath '/root/data/didi/cancal_order.csv' into table ods_didi.t_user_cancel_order partition(month='2020-04-12');

-- 加载dw层数据
insert overwrite table dw_didi.t_user_cancel_order_wide partition(dt='2020-04-12')
select
    orderId,
    cstm_telephone,
    lng,
    lat,
    province,
    city,
    es_distance,
    gender,
    profession,
    age_range,
    reason,
    case when reason = 1 then '选择了其他交通方式'
         when reason = 2 then '与司机达成一致，取消订单'
         when reason = 3 then '投诉司机没来接我'
         when reason = 4 then '已不需要用车'
         else '无理由取消订单'
    end,
    cancel_time,
    date_format(cancel_time, 'yyyy-MM-dd')
from
    ods_didi.t_user_cancel_order
where 
    dt = '2020-04-12';

