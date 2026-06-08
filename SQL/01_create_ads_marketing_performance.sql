CREATE OR REPLACE TABLE
`fifth-flash-489402-h9.improvado_assignment.ads_marketing_performance`
AS

-- Facebook Ads
SELECT
    date,
    'Facebook' AS platform,
    campaign_id,
    campaign_name,
    ad_set_id AS ad_group_id,
    ad_set_name AS ad_group_name,
    impressions,
    clicks,
    spend AS cost,
    conversions,
    NULL AS conversion_value,
    video_views,
    engagement_rate,
    reach,
    frequency,
    NULL AS likes,
    NULL AS shares,
    NULL AS comments
FROM `fifth-flash-489402-h9.improvado_assignment.raw_facebook_ads`   ---project.dataset.raw_facebook_ads

UNION ALL

-- Google Ads
SELECT
    date,
    'Google Ads' AS platform,
    campaign_id,
    campaign_name,
    ad_group_id,
    ad_group_name,
    impressions,
    clicks,
    cost,
    conversions,
    conversion_value,
    NULL AS video_views,
    NULL AS engagement_rate,
    NULL AS reach,
    NULL AS frequency,
    NULL AS likes,
    NULL AS shares,
    NULL AS comments
FROM `fifth-flash-489402-h9.improvado_assignment.raw_google_ads` ---project.dataset.raw_google_ads

UNION ALL

-- TikTok Ads
SELECT
    date,
    'TikTok' AS platform,
    campaign_id,
    campaign_name,
    adgroup_id AS ad_group_id,
    adgroup_name AS ad_group_name,
    impressions,
    clicks,
    cost,
    conversions,
    NULL AS conversion_value,
    video_views,
    NULL AS engagement_rate,
    NULL AS reach,
    NULL AS frequency,
    likes,
    shares,
    comments
FROM `fifth-flash-489402-h9.improvado_assignment.raw_tiktok_ads`;  ---project.dataset.raw_tiktok_ads
