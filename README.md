# marketing-analytics-dashboard
Cross-Channel Marketing Analytics Dashboard using BigQuery, SQL and Looker Studio
📊 Cross-Channel Marketing Analytics Dashboard
Project Overview
This project is an end-to-end marketing analytics solution built with Google BigQuery, SQL, and Looker Studio.
The goal was to combine marketing data from multiple advertising platforms into one unified dataset, calculate key marketing KPIs, validate the data, and build an interactive dashboard for business analysis.
The dashboard helps compare performance across Facebook Ads, Google Ads, and TikTok Ads.
________________________________________
Tech Stack
•	Google BigQuery
•	SQL
•	Looker Studio
•	CSV files
•	GitHub
________________________________________
Data Sources
Raw CSV files were uploaded into BigQuery as separate raw tables:
•	raw_facebook_ads
•	raw_google_ads
•	raw_tiktok_ads
These tables represent the original data before transformation.
________________________________________
Data Flow
Raw CSV Files
        ↓
BigQuery Raw Tables
        ↓
Unified Marketing Table
        ↓
Analytical Views
        ↓
Looker Studio Dashboard
________________________________________
Project Architecture
 
________________________________________
Dashboard Preview
 
________________________________________
1. Create Unified Marketing Table
The first step was to standardize data from Facebook Ads, Google Ads, and TikTok Ads into one unified table.
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
FROM `fifth-flash-489402-h9.improvado_assignment.raw_facebook_ads`

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
FROM `fifth-flash-489402-h9.improvado_assignment.raw_google_ads`

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
FROM `fifth-flash-489402-h9.improvado_assignment.raw_tiktok_ads`;
________________________________________
2. Create KPI View
This view calculates row-level marketing KPIs.
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
________________________________________
3. Create Campaign Performance View
This view is used for campaign-level analysis.
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
________________________________________
4. Create Channel Performance View
This view is used to compare Facebook Ads, Google Ads, and TikTok Ads.
CREATE OR REPLACE VIEW
`fifth-flash-489402-h9.improvado_assignment.vw_channel_performance`
AS

SELECT
    platform,

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

GROUP BY platform;
________________________________________
Data Validation Checks
I performed several checks in BigQuery to validate the dataset before building the dashboard.
1. Check row count by platform
SELECT
    platform,
    COUNT(*) AS row_count
FROM `fifth-flash-489402-h9.improvado_assignment.ads_marketing_performance`
GROUP BY platform;
2. Check date range
SELECT
    MIN(date) AS min_date,
    MAX(date) AS max_date,
    COUNT(*) AS total_rows
FROM `fifth-flash-489402-h9.improvado_assignment.ads_marketing_performance`;
3. Check totals by platform
SELECT
    platform,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(cost) AS spend,
    SUM(conversions) AS conversions,
    SUM(conversion_value) AS revenue
FROM `fifth-flash-489402-h9.improvado_assignment.ads_marketing_performance`
GROUP BY platform
ORDER BY spend DESC;
4. Check Revenue availability
SELECT
    platform,
    SUM(conversion_value) AS revenue
FROM `fifth-flash-489402-h9.improvado_assignment.ads_marketing_performance`
GROUP BY platform;
Revenue data was available only for Google Ads.
Because of this, revenue and ROAS should be interpreted only where revenue data exists.
5. Validate CTR calculation
SELECT
    AVG(ctr) AS avg_ctr,
    SUM(clicks) / SUM(impressions) AS weighted_ctr
FROM `fifth-flash-489402-h9.improvado_assignment.vw_marketing_performance`;
This check helped compare simple average CTR with weighted CTR.
6. Check for null values
SELECT
    COUNTIF(date IS NULL) AS null_dates,
    COUNTIF(platform IS NULL) AS null_platforms,
    COUNTIF(campaign_id IS NULL) AS null_campaign_ids,
    COUNTIF(impressions IS NULL) AS null_impressions,
    COUNTIF(clicks IS NULL) AS null_clicks,
    COUNTIF(cost IS NULL) AS null_cost,
    COUNTIF(conversions IS NULL) AS null_conversions
FROM `fifth-flash-489402-h9.improvado_assignment.ads_marketing_performance`;
________________________________________
KPIs Used
The dashboard tracks the following marketing KPIs:
KPI	Formula
CTR	Clicks / Impressions
CPC	Cost / Clicks
CPA	Cost / Conversions
Conversion Rate	Conversions / Clicks
ROAS	Revenue / Spend
Total Spend	SUM(Cost)
Total Revenue	SUM(Conversion Value)
Total Conversions	SUM(Conversions)
________________________________________
Dashboard Features
The Looker Studio dashboard includes:
•	KPI scorecards
•	Date range filter
•	Platform filter
•	Conversions by Platform
•	Spend by Platform
•	CTR by Platform
•	CPA by Platform
•	Top Campaigns
________________________________________
Key Insights
•	TikTok generated the highest number of conversions.
•	Google Ads showed the strongest CTR.
•	Facebook had the lowest CPA.
•	Total revenue was available only for Google Ads, so revenue-based analysis was limited to the available data.
•	The dashboard provides a centralized view of marketing performance across channels and campaigns.
________________________________________
Business Value
This project helps marketing stakeholders:
•	Compare performance across advertising channels
•	Identify top-performing campaigns
•	Monitor key marketing KPIs
•	Understand acquisition efficiency
•	Make data-driven budget optimization decisions
________________________________________
Author
Igor Mykoliv
Data Analyst | SQL | BigQuery | Snowflake | Tableau | Power BI | Looker Studio

