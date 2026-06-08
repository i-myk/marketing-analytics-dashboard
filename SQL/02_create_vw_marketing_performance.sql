CREATE OR REPLACE VIEW
`fifth-flash-489402-h9.improvado_assignment.vw_marketing_performance`
AS

SELECT
    date,
    platform,
    campaign_id,
    campaign_name,
    ad_group_id,
    ad_group_name,
    impressions,
    clicks,
    cost,
    conversions,
    conversion_value,

    SAFE_DIVIDE(clicks, impressions) AS ctr,
    SAFE_DIVIDE(cost, clicks) AS cpc,
    SAFE_DIVIDE(cost, conversions) AS cpa,
    SAFE_DIVIDE(conversions, clicks) AS conversion_rate,
    SAFE_DIVIDE(conversion_value, cost) AS roas

FROM `fifth-flash-489402-h9.improvado_assignment.ads_marketing_performance`;

