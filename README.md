# Cross-Channel Marketing Analytics Dashboard

A marketing analytics project that combines Facebook Ads, Google Ads, and TikTok Ads data into a unified reporting dataset using SQL and BigQuery.

## Dashboard Preview

![Dashboard](images/dashboard_overview.png)

________________________________________
## Project Overview

This project demonstrates how to build a complete marketing analytics workflow using raw CSV files, SQL transformations, BigQuery, and Looker Studio.

The goal was to create a unified reporting layer for cross-channel performance analysis across Facebook Ads, Google Ads, and TikTok Ads.

The project includes:

- Data ingestion from CSV files
- Data standardization across platforms
- SQL transformations in BigQuery
- Data validation checks
- Reporting views for analytics
- Interactive dashboard in Looker Studio
________________________________________
## Technologies Used

- Google BigQuery
- SQL
- Looker Studio
- GitHub
- CSV Data Sources
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

---

## Project Workflow

### Step 1: Raw Data Upload

The project started with three raw CSV files:

- Facebook Ads
- Google Ads
- TikTok Ads

The files were uploaded into BigQuery as separate raw tables:

- `raw_facebook_ads`
- `raw_google_ads`
- `raw_tiktok_ads`

These tables represent the original source data before any transformation.

---

### Step 2: Data Standardization

Each advertising platform used different field names and metrics.

Examples:

| Facebook Ads | Google Ads | TikTok Ads | Standardized Name |
|-------------|------------|------------|------------------|
| ad_set_id | ad_group_id | adgroup_id | ad_group_id |
| ad_set_name | ad_group_name | adgroup_name | ad_group_name |
| spend | cost | cost | cost |

The data was standardized to create a consistent structure across all platforms.

---

### Step 3: Create Unified Marketing Table

A unified table called `ads_marketing_performance` was created using SQL and `UNION ALL`.

The table combines Facebook Ads, Google Ads, and TikTok Ads into a single reporting layer.

**Output Table**

```sql
ads_marketing_performance
```

**SQL File**

```text
SQL/01_create_ads_marketing_performance.sql
```

---

### Step 4: Create KPI View

A reporting view was created to calculate row-level marketing KPIs.

Calculated metrics:

- CTR
- CPC
- CPA
- Conversion Rate
- ROAS

**Output View**

```sql
vw_marketing_performance
```

**SQL File**

```text
SQL/02_create_vw_marketing_performance.sql
```

---

### Step 5: Create Campaign Performance View

A campaign-level reporting view was created to analyze campaign performance.

Metrics included:

- Spend
- Impressions
- Clicks
- Conversions
- CTR
- CPC
- CPA
- Conversion Rate
- ROAS

**Output View**

```sql
vw_campaign_performance
```

**SQL File**

```text
SQL/03_create_vw_campaign_performance.sql
```

---

### Step 6: Create Channel Performance View

A channel-level reporting view was created to compare advertising platforms.

Platforms:

- Facebook Ads
- Google Ads
- TikTok Ads

**Output View**

```sql
vw_channel_performance
```

**SQL File**

```text
SQL/04_create_vw_channel_performance.sql
```

---

### Step 7: Data Validation

Before building the dashboard, several validation checks were performed in BigQuery.

#### Row Count Validation

Validated the number of records loaded from each platform.

#### Date Range Validation

Verified minimum and maximum dates in the dataset.

#### Metric Reconciliation

Validated:

- Impressions
- Clicks
- Spend
- Conversions
- Revenue

across all platforms.

#### Revenue Validation

Revenue data was available only for Google Ads.

Because of this, ROAS calculations are available only where revenue exists.

#### KPI Validation

CTR calculations were compared using:

- Average CTR
- Weighted CTR

to ensure KPI accuracy.

#### Null Checks

Validated critical fields:

- date
- platform
- campaign_id
- impressions
- clicks
- cost
- conversions

---

### Step 8: Build Looker Studio Dashboard

The final step was creating an interactive dashboard in Looker Studio.

Dashboard components include:

- KPI Scorecards
- Date Range Filter
- Platform Filter
- Conversions by Platform
- Spend by Platform
- CTR by Platform
- CPA by Platform
- Top Campaigns

---

## Data Flow

```text
Raw CSV Files
        ↓
BigQuery Raw Tables
        ↓
Unified Marketing Table
        ↓
Analytical Views
        ↓
Looker Studio Dashboard
```

---

## Project Architecture

![Architecture](images/architecture_diagrams.png)

---

## Dashboard Preview

![Dashboard](images/dashboard_overview.png)

---

## Project Structure

```text
marketing-analytics-dashboard
│
├── data
│   ├── 01_facebook_ads.csv
│   ├── 02_google_ads.csv
│   └── 03_tiktok_ads.csv
│
├── SQL
│   ├── 01_create_ads_marketing_performance.sql
│   ├── 02_create_vw_marketing_performance.sql
│   ├── 03_create_vw_campaign_performance.sql
│   └── 04_create_vw_channel_performance.sql
│
├── images
│   ├── architecture_diagram.png
│   └── dashboard_overview.png
│
└── README.md
```

---

## KPIs Used

| KPI | Formula |
|------|---------|
| CTR | Clicks / Impressions |
| CPC | Cost / Clicks |
| CPA | Cost / Conversions |
| Conversion Rate | Conversions / Clicks |
| ROAS | Revenue / Spend |
| Total Spend | SUM(Cost) |
| Total Conversions | SUM(Conversions) |
| Revenue | SUM(Conversion Value) |

---

## Key Insights

- TikTok generated the highest number of conversions.
- Google Ads showed the strongest CTR, meaning users engaged more frequently with those ads.
- Facebook Ads had the lowest CPA, making it the most cost-efficient channel for conversions.
- Revenue data was available only for Google Ads, limiting revenue-based analysis for other channels.
- The dashboard provides a centralized view of marketing performance across channels and campaigns.

---

## Business Value

This project helps marketing stakeholders:

- Compare performance across advertising channels
- Identify top-performing campaigns
- Monitor marketing KPIs
- Understand acquisition efficiency
- Optimize marketing spend
- Make data-driven budget allocation decisions

---










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

