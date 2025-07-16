# Japan Tourism Segmentation

## Overview
This project visualizes and analyzes **Japan tourism data on a regional level** collected across various categories (e.g., Accommodation Type, Nationality, Length of Stay). The goal is to identify characteristics of tourists that visit each region of Japan, which may provide some insight into which demographics each region may or may not appeal to and can allow for more informative tourism advertising such as in promotion of travel services and attractions. The original data was provided as a single **Excel** file with multiple sheets. After cleaning and restructuring in Google Sheets, the data was imported as multiple tables into **MySQL** that were unified and prepared for interactive exploration using **Tableau**.

The Tableau dashboard may be viewed on [Tableau Public](https://public.tableau.com/views/JapanTourismbyPrefectureRegion/Dashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).

## How to use
Data used in this project have been preprocessed and are stored as CSV files in the `data` folder. Please scroll down to the Data Source and Attribution section at the bottom of this README file for the original source.

Each individual CSV file should be imported into MySQL (there should be 11 tables in total). When importing the table from `Times Visited Japan.csv`, the field type for the 'Times Visited Japan' column should be set to 'text'. The `japan_tourism_view.sql` file contains the script to create a view that can be exported for use with Tableau.

https://public.tableau.com/views/JapanTourismbyPrefectureRegion/Dashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

## About the Dataset
This project uses data from the [International Visitor Survey (IVS)](https://www.mlit.go.jp/kankocho/en/siryou/toukei/syouhityousa.html) published by the Japan Tourism Agency.

According to the Japan Tourism Agency:
>IVS is aimed at obtaining baseline information for designing and evaluating measures to attract foreign tourists by assessing trends in consumption by international visitors to >Japan. IVS is made up of three quarterly surveys for different purposes:

>A1: National Survey: Designed to characterize international visitors to Japan as a whole by their attributes as well as by what they did and how – and how much – they spent in Japan.  
>B1: Regional Survey: Designed to characterize international visitors to each prefecture in Japan by their attributes as well as by what they did and how – and how much – they spent in Japan.
>B2: Cruise Survey: Designed to characterize international visitors to Japan with landing permission for cruise ship tourists by their attributes as well as by what they did and how – and how much – they spent in Japan.

The data is provided as Excel files for each yearly quarter and, for recent years, for calendar years. I will be using the data for `Calendar Year 2024`. The public data does not include data at an individual level, but instead aggregated numbers and percentages. For instance, public data based on the Regional Survey includes number of surveyees as well as percentages of surveyees that visited a prefecture based on certain characteristics (e.g. number of South Koreans who visited Hokkaido, number of solo travelers who visited Yamanashi, etc.) but individual surveyee data such as a specific surveyee's nationality, sex, age, etc. is not available.

The Excel file contains multiple sheets with tables based on the three afforementioned surveys (A1, B1, B2). For the purposes of this project, I am interested in statistic based on regions of Japan and data for people traveling for tourism (i.e. not traveling for business, visiting family, etc.), so I used data from the `Annex 12` sheet which use data from the B1: Regional Survey. This survey excludes tourists who traveled to Japan by cruise ship.

Each table from the sheet includes `Numbers` and `Ratio (%)` (i.e. percentages of surveyees with values 0-100) of surveyees visiting each area and belonging to specific categories, but for simplicity I will only use `Ratio (%)`. It is important to note that there is some margin of error to the values in the dataset, with certain values having large standard errors for reasons such as having a low number of responses. For instance, popular tourist destinations such as Tokyo and Kyoto may have a relatively low standard error while prefectures like Fukushima and Shimane with much less foreign tourists have high standard errors reaching as high as 10%.

Each table includes statistics for each of Japan's 48 prefectures (similar to U.S. states), but also data for each geographic region of Japan. The IVS groups each prefecture under each region as follows:
> Hokkaido Region : Hokkaido  
> Tohoku Region : Aomori, Iwate, Miyagi, Akita, Yamagata, Fukushima  
> Kanto Region : Ibaraki, Tochigi, Gunma, Saitama, Chiba, Tokyo, Kanagawa, Yamanashi  
> Hokuriku-Shin'etsu Region : Niigata, Toyama, Ishikawa, Nagano  
> Chubu Region : Fukui, Gifu, Shizuoka, Aichi, Mie  
> Kinki Region : Shiga, Kyoto, Osaka, Nara, Wakayama, Hyogo  
> Chugoku Region : Tottori, Shimane, Okayama, Hiroshima, Yamaguchi  
> Shikoku Region : Tokushima, Kagawa, Ehime, Kochi  
> Kyushu Region : Fukuoka, Saga, Nagasaki, Kumamoto, Oita, Miyazaki, Kagoshima  
> Okinawa Region : Okinawa  

## Project Workflow
### Preprocessing (Google Sheets)
- Imported Excel sheets into Google Sheets
- Cleaned header names and formats
- Unpivoted tables into format suitable for SQL/Tableau
- Saved each table as CSV file (store in `data` folder)

Each resulting table represents a certain category: `Nationality`, `Port of Entry`, `Port of Departure`, `Length of Stay`, `Sex/Age`, `Times Visited Japan`, `Travel Companions`, `Travel Arrangement`, `Accommodation Type`, `Means of Transportation`, and `Places to Shop`.
Each includes the percentage of surveyees that visited each prefecture/region that fall under a group in the respective category (e.g. 34.6% of surveyees who visited Hokkaido were South Korean nationals). Certain survey questions allow for multiple answers (e.g. Types of Accommodation, Means of Transportation, etc.) so percentages may add up to more than 10% depending on the category.

### Database Setup (MySQL)
Imported each cleaned sheet as a separate table in MySQL, and created a view `japan_tourism_stats` that:
- Unifies all sheets using UNION ALL
- Splits `Sex/Age` fields into separate `Sex` and `Age` columns (while also keeping the original column)
- Normalizes `Area of Visit` into `location` (name of prefecture or region) and `geographic_level` (Prefecture or Region)

### Visualization (Tableau)
- Connected Tableau to the MySQL view
- Developed an interactive dashboard enabling:
  - Filtering by geographic level, geographic location, category, and category group
  - Comparison of visitation patterns within each survey category
  - Exploration of demographic and behavioral patterns
 
## Limitations
When designing the dashboard, I wanted to fit as much functionality as I could within a single dashboard. The (admittedly) excessive use of filters may not as practical in a real world setting, but I mainly wanted to experiment with what could be done with filters. While the dashboard allows multiple plots to dynamically update together depending on which filters are selected, it does have some issues:
- Filtering is relatively slow, taking a couple seconds to update.
- Some plots may disappear or break when filters are applied or turned off while certain other filters are selected. In particular,
  - The treemap below the map should only be used to filter when "(All)" is selected in the Group filter. If "(All)" is not selected, a couple visuals will not be displayed unless the filtered treemap item also happens to be selected within the Group filter.
  - The Geographic Level and Region filters and Total Percentages of Selected Group(s) from [Category] bar plot filter don't play well together. The biggest issue occurs when changing the Geographic Level while the bar plot filter has been applied, so turning off the Region and bar plot filters before switching Geographic Levels can avoid this problem.

## Data Source and Attribution

Source: Created by editing the International Visitor Survey (Japan Tourism Agency)  
URL: https://www.mlit.go.jp/kankocho/en/siryou/toukei/syouhityousa.html  
Accessed on: 2025/07/01

This project is independent and is not affiliated with or endorsed by the Government of Japan.
