WITH country_ud AS (
    SELECT
        day AS month,
        wikimedia_region AS region,
        uniques_estimate as unique_devices
    FROM wmf_readership.unique_devices_per_project_family_monthly ud
    LEFT JOIN canonical_data.countries cc
    ON ud.country_code = cc.iso_code
    WHERE
        project_family = 'wikipedia'
        AND day = '{metrics_month_first_day}'
)
SELECT
    month,
    -- Using these SUM(IF(...)) statements rather than a GROUP BY so that query output
    -- is wide rather than long, which is the format expected by the MetricSet abstraction
    -- in the calculation notebook
    SUM(IF(region = 'Central & Eastern Europe & Central Asia', unique_devices, 0))
        AS central_eastern_europe_central_asia_unique_devices,
    SUM(IF(region = 'East, Southeast Asia, & Pacific', unique_devices, 0))
        AS east_southeast_asia_pacific_unique_devices,
    SUM(IF(region = 'Latin America & Caribbean', unique_devices, 0))
        AS latin_america_caribbean_unique_devices,
    SUM(IF(region = 'Middle East & North Africa', unique_devices, 0))
        AS middle_east_north_africa_unique_devices,
    SUM(IF(region = 'North America', unique_devices, 0))
        AS north_america_unique_devices,
    SUM(IF(region = 'Northern & Western Europe', unique_devices, 0))
        AS northern_western_europe_unique_devices,
    SUM(IF(region = 'South Asia', unique_devices, 0))
        AS south_asia_unique_devices,
    SUM(IF(region = 'Sub-Saharan Africa', unique_devices, 0))
        AS subsaharan_africa_unique_devices
FROM country_ud
GROUP BY month
