CREATE OR REPLACE VIEW
`fifth-flash-489402-h9.improvado_assignment.vw_campaign_performance`
AS

SELECT
    platform,
    campaign_name,

    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(cost) AS spend,
    SUM(conversions) AS conversions,
    SUM(conversion_value) AS revenue,

    ROUND(SAFE_DIVIDE(SUM(clicks), SUM(impressions)), 4) AS ctr,
    ROUND(SAFE_DIVIDE(SUM(cost), SUM(clicks)), 2) AS cpc,
    ROUND(SAFE_DIVIDE(SUM(cost), SUM(conversions)), 2) AS cpa,
    ROUND(SAFE_DIVIDE(SUM(conversions), SUM(clicks)), 4) AS conversion_rate,
    ROUND(SAFE_DIVIDE(SUM(conversion_value), SUM(cost)), 2) AS roas

FROM `fifth-flash-489402-h9.improvado_assignment.ads_marketing_performance`

GROUP BY
    platform,
    campaign_name;
