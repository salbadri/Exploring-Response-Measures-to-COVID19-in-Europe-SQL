/* version 8.0.25
Sarah Al Badri
Email: sarah.albadri.ds@gmail.com
Portfolio: https://salbadri.github.io/SarahAlBadri.github.io/
*/

select version();
Create Database COVID19;
select * from COVID19Cases; 
select * from responseToCOVID19; 

-- Lets Explore responseToCOVID19 dataset further
SELECT* From responseToCOVID19; 
SELECT distinct Response_measure From responseToCOVID19;

-- Lets check for null, NA, and empty string " ";

SELECT * From responseToCOVID19 where Response_measure is NuLL;
SELECT * From responseToCOVID19 where Response_measure = 'NA';
SELECT count(*) FROM responseToCovid19 WHERE Response_measure = 'NA';
SELECT * From responseToCOVID19 where Response_measure = " ";
SELECT * From responseToCOVID19 where date_start is NuLL;
SELECT * From responseToCOVID19 where date_start = 'NA';
SELECT * From responseToCOVID19 where date_start = " ";
SELECT * From responseToCOVID19 where date_end is NuLL;
SELECT * From responseToCOVID19 where date_end = 'NA';
SELECT count(*) FROM responseToCovid19 WHERE date_end = 'NA';
SELECT * From responseToCOVID19 where date_end = " ";

-- replace all NA in response measures to COVID19 with date of Data compiling 

select * From responseToCOVID19 where date_end = 'NA';
SELECT count(*) FROM responseToCovid19 WHERE date_end = '2020-03-16';
UPDATE responseToCovid19 SET date_end = '2022-06-23' WHERE date_end ='NA';
SELECT count(*) FROM responseToCovid19 WHERE date_end = 'NA';


 -- Add 3 columns to responseToCOVID19 tabel daysDiffStartToEnd, YearWeek_start, YearWeek_end

Alter Table responseToCOVID19 
Add column daysDiffStartToEnd Varchar(30) ,
Add column YearWeek_start Varchar(30) , 
Add column YearWeek_end Varchar(30)  ;

-- Calculate day difference: days from start_date to the end_date of each reponse measure

UPDATE responseToCovid19
SET daysDiffStartToEnd = (select DATEDIFF(date_end, date_start));

-- Lets make sure the query worked

select * From responseToCOVID19;

-- Calculate YearWeek for Date_start in YearWeek_start column 


-- UPDATE responseToCovid19 
SET YearWeek_start  = (select  DATE_FORMAT(date_start,'%X-%V'));

select * from responseToCOVID19;
  -- Calculate Yearweek for Date_end in YearWeek_end column 

UPDATE responseToCovid19
SET YearWeek_end  = (select DATE_FORMAT(date_end,'%X-%V'));

select * from responseToCOVID19;

-- Lets explore and clean COVID19 Dataset

SELECT * FROM COVID19Cases;


-- I am intrested in country,indicator, weekly_count, and year_week , cumulative_count columns for the continent Europe

SELECT * FROM COVID19Cases WHERE country = 'NA' AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE indicator = 'NA' AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  weekly_count = 'NA' AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  year_week = 'NA' AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  cumulative_count = 'NA' AND continent = 'Europe';

SELECT * FROM COVID19Cases WHERE country is Null  AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE indicator is Null AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  weekly_count is Null AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  year_week is Null AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  cumulative_count is null AND continent = 'Europe';

-- check for empty string:

SELECT * FROM COVID19Cases WHERE country = " " AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE indicator = " " AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  weekly_count = " " AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  year_week = " " AND continent = 'Europe';
SELECT * FROM COVID19Cases WHERE  cumulative_count = " " AND continent = 'Europe';

-- Now we join responseToCOVID19 tabel with COVID19Cases using inner join (NOTE: COVID19Cases tabel had data for Cases and deaths due to COVID19

Create table MeasuresAndCOVID19CasesEurope AS
SELECT responseToCovid19.country, 
responseToCovid19.Response_measure, 
responseToCovid19.YearWeek_start AS Response_YearWeekStart, responseToCovid19.YearWeek_end AS Response_YearWeekEnd, 
responseToCovid19.daysDiffStartToEnd, COVID19Cases.indicator AS COVID19Indicator, COVID19Cases.year_week AS COVID19_YearWeek, COVID19Cases.weekly_count AS COVID19_WeeklyCount, COVID19Cases.cumulative_count
FROM responseToCovid19
INNER JOIN COVID19Cases
ON
responseToCovid19.country=COVID19Cases.country
AND responseToCovid19.yearWeek_end = COVID19Cases.year_week;

-- Lets check what response measure used the most?

SELECT response_measure, COUNT( * )
FROM MeasuresAndCOVID19CasesEurope
GROUP BY response_measure
ORDER BY COUNT( * ) DESC
LIMIT 1;

-- Lets explore what reponse measures to COVID19 were adapted for more than 90 days?
SELECT * 
FROM MeasuresAndCOVID19CasesEurope  
HAVING daysDiffStartToEnd > '90';

SELECT distinct Response_measure , daysDiffStartToEnd
FROM MeasuresAndCOVID19CasesEurope  
HAVING daysDiffStartToEnd > '90';


-- Lets check measures used each year and then check distinct measures:

    -- 2020
select * 
FROM MeasuresAndCOVID19CasesEurope  
Where Response_YearWeekStart >='2020' AND Response_YearWeekStart < '2021'  ;

select distinct Response_measure, daysDiffStartToEnd, Response_YearWeekStart 
FROM MeasuresAndCOVID19CasesEurope  
Where Response_YearWeekStart >='2020' AND Response_YearWeekStart < '2021'  ;

	-- 2021
SELECT * 
FROM MeasuresAndCOVID19CasesEurope 
Where (Response_YearWeekStart >= '2021' AND Response_YearWeekStart < '2022');

select distinct Response_measure, daysDiffStartToEnd, Response_YearWeekStart 
FROM MeasuresAndCOVID19CasesEurope  
Where (Response_YearWeekStart >= '2021' AND Response_YearWeekStart < '2022');

	-- 2022
SELECT * 
FROM MeasuresAndCOVID19CasesEurope 
Where (Response_YearWeekStart >= '2022');

select distinct Response_measure, daysDiffStartToEnd, Response_YearWeekStart 
FROM MeasuresAndCOVID19CasesEurope  
Where (Response_YearWeekStart >= '2022');


-- Lets check frequency of each response measure for each year
-- 2020: YearWeek_start >='2020' AND YearWeek_start < '2021'
-- 2021: YearWeek_start >= '2021' AND YearWeek_start < '2022'
-- 2022: YearWeek_start >=  '2022'

-- 2020
SELECT DISTINCT Response_measure, count(*) As Frequency
FROM MeasuresAndCOVID19CasesEurope
Where Response_YearWeekStart >='2020' AND Response_YearWeekStart < '2021'
GROUP BY Response_measure
ORDER by count(*) DESC;

-- 2021
SELECT DISTINCT Response_measure, count(*) As Frequency
FROM MeasuresAndCOVID19CasesEurope
Where Response_YearWeekStart >= '2021' AND Response_YearWeekStart < '2022'
GROUP BY Response_measure
ORDER by count(*) DESC;

-- 2022
SELECT DISTINCT Response_measure, count(*) As Frequency
FROM MeasuresAndCOVID19CasesEurope
Where Response_YearWeekStart >=  '2022'
GROUP BY Response_measure
ORDER by count(*) DESC;


-- Lets explore how many countries adapted stay at home order (lockdown)? 

Select Distinct country
FROM MeasuresAndCOVID19CasesEurope;

Select country,  (Response_measure = 'StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')
FROM MeasuresAndCOVID19CasesEurope;


-- Lets explore lockdown each year:
-- 2020
SELECT * 
FROM MeasuresAndCOVID19CasesEurope
WHERE (Response_measure = 'StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')
AND (Response_YearWeekStart >='2020' AND Response_YearWeekStart < '2021');

create view Lockdown_2020 AS
SELECT * 
FROM MeasuresAndCOVID19CasesEurope
WHERE (Response_measure = 'StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')
AND (Response_YearWeekStart >='2020' AND Response_YearWeekStart <= '2021');

-- 2021
SELECT * 
FROM MeasuresAndCOVID19CasesEurope
WHERE (Response_measure = 'StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')
AND (Response_YearWeekStart >= '2021' AND Response_YearWeekStart < '2022');

Create View Lockdown_2021 AS
SELECT * 
FROM MeasuresAndCOVID19CasesEurope
WHERE (Response_measure = 'StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')
AND (Response_YearWeekStart >= '2021' AND Response_YearWeekStart < '2022');

-- 2022
SELECT * 
FROM MeasuresAndCOVID19CasesEurope
WHERE (Response_measure = 'StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')
AND (Response_YearWeekStart >=  '2022');

-- Let explore which countries did not adapt lockdown?

Select country,YearWeek_start, (Response_measure = 'StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')
From responseToCOVID19
Where (YearWeek_start >= '2020' AND YearWeek_start < '2022');

-- Who never adapted lockdown?

Select distinct country,
(select  Response_measure = (Response_measure='StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')=1)
From responseToCOVID19
Where (YearWeek_start >= '2020' AND YearWeek_start < '2022');


-- Lets explore which contries never adapted lockdown?

Select country,Response_YearWeekStart, (Response_measure = 'StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')
FROM MeasuresAndCOVID19CasesEurope
Where (Response_YearWeekStart >= '2020' AND Response_YearWeekStart < '2022');

-- Who never adapted lockdown?

Select distinct country,
(select  Response_measure = (Response_measure='StayHomeOrder' OR Response_measure ='RegionalStayHomeOrder' OR Response_measure ='StayHomeGen')=1)
FROM MeasuresAndCOVID19CasesEurope
Where (Response_YearWeekStart >= '2020' AND Response_YearWeekStart < '2022');

-- We have cases and deaths; Lets explore them separately.
-- Lets explore cases only by creating a view out of the Measures and COVID19 view: 

CREATE VIEW covid19casesandmeausres As
SELECT *
FROM MeasuresAndCOVID19CasesEurope
WHERE COVID19Indicator ='cases'
ORDER BY COVID19_WeeklyCount DESC;


-- Cases
 -- Now Lets explore highest number of cases weekly_count, highest number of cases cumulative_count
 -- lowest number of weekly_count cases, lowest cases of cumulative_count, avergae of weekly_count cases 
 -- and average of cumulative count 

select * 
From covid19casesandmeausres;
-- Max
	-- max weekly_count of cases
select *
From covid19casesandmeausres
where COVID19_WeeklyCount = (select max(COVID19_WeeklyCount) from covid19casesandmeausres) ;

	-- Max cases of cumulative_count
select *
From covid19casesandmeausres
where cumulative_count = (select max(cumulative_count) from covid19casesandmeausres);

-- Min:

	-- Min weekly_count cases
select * 
From covid19casesandmeausres
where COVID19_WeeklyCount = (select min(COVID19_WeeklyCount) from covid19casesandmeausres) ;

select Distinct country
From covid19casesandmeausres
where COVID19_WeeklyCount = (select min(COVID19_WeeklyCount) from covid19casesandmeausres);

	-- Min cumualtive count
select * 
From covid19casesandmeausres
where cumulative_count = (select min(cumulative_count) from covid19casesandmeausres);

select Distinct country
From covid19casesandmeausres
where cumulative_count = (select min(cumulative_count) from covid19casesandmeausres);

-- Average:
	-- average of weekly_count cases
select round(avg(COVID19_WeeklyCount),2)
From covid19casesandmeausres;
	-- average cumulative count cases
select round(avg(cumulative_count),2)
From covid19casesandmeausres;

-- Median:
	-- median of  weekly-count of cases
SET @rowindex := -1;
SELECT
   AVG(w.COVID19_WeeklyCount) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           covid19casesandmeausres.COVID19_WeeklyCount AS COVID19_WeeklyCount
    FROM covid19casesandmeausres
    ORDER BY covid19casesandmeausres.COVID19_WeeklyCount) AS w
WHERE
w.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

	-- median of cumualtive count
SET @rowindex := -1;
SELECT
   AVG(c.cumulative_count) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           covid19casesandmeausres.cumulative_count AS cumulative_count
    FROM covid19casesandmeausres
    ORDER BY covid19casesandmeausres.cumulative_count) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

-- deaths
	-- Lets Create a view for death indicator 
CREATE VIEW covid19deathsandmeausres As
SELECT *
FROM MeasuresAndCOVID19CasesEurope
WHERE COVID19Indicator ='deaths'
ORDER BY COVID19_WeeklyCount DESC;

-- Deaths
 -- Now Lets explore highest number of weekly_count deaths, highest number of cumulative_count of deaths
 -- ,lowest number of weekly_count deaths, lowest  cumulative_count of deaths, avergae of weekly_count deaths 
 -- and  average of cumulative count deaths

select * 
From covid19deathsandmeausres;
-- MAX
	-- max weekly_count of cases
select *
From covid19deathsandmeausres
where COVID19_WeeklyCount = (select max(COVID19_WeeklyCount) from covid19deathsandmeausres);

	-- Max cases of cumulative_count
select *
From covid19deathsandmeausres
where cumulative_count = (select max(cumulative_count) from covid19deathsandmeausres);

	-- Min weekly_count cases
select * 
From covid19deathsandmeausres
where COVID19_WeeklyCount = (select min(COVID19_WeeklyCount) from covid19deathsandmeausres) ;

select Distinct country
From covid19deathsandmeausres
where COVID19_WeeklyCount = (select min(COVID19_WeeklyCount) from covid19deathsandmeausres) ;


	-- Min cumualtive count
select * 
From covid19deathsandmeausres
where cumulative_count = (select min(cumulative_count) from covid19deathsandmeausres) ;

select Distinct country
From covid19deathsandmeausres
where cumulative_count = (select min(cumulative_count) from covid19deathsandmeausres) ;

-- average of weekly_count cases
select round(avg(COVID19_WeeklyCount),2)
From covid19deathsandmeausres;
-- average cumulative count cases
select round(avg(cumulative_count),2)
From covid19deathsandmeausres;

-- median of weekly count 
SET @rowindex := -1;
SELECT
   AVG(c.COVID19_WeeklyCount) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           covid19deathsandmeausres.COVID19_WeeklyCount AS COVID19_WeeklyCount
    FROM covid19deathsandmeausres
    ORDER BY covid19deathsandmeausres.COVID19_WeeklyCount) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

-- median of cumualtive count
SET @rowindex := -1;
SELECT
   AVG(c.cumulative_count) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           covid19deathsandmeausres.cumulative_count AS cumulative_count
    FROM covid19deathsandmeausres
    ORDER BY covid19deathsandmeausres.cumulative_count) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

-- Lets divide measure to strict, relaxed, and partial_inbtween

-- Strict Measures 
Create Table StrictMeasuresAndCOVID19 AS
Select *
FROM MeasuresAndCOVID19CasesEurope
WHERE (Response_measure= 'StayHomeOrder' or 
Response_measure= 'BanOnAllEvents' or  
Response_measure= 'ClosDaycare' or
Response_measure=  'ClosHigh' or
Response_measure=  'ClosPrim' or
Response_measure=  'ClosSec' or
Response_measure=  'ClosureOfPublicTransport' or
Response_measure=  'MasksMandatoryAllSpaces' or 
Response_measure=  'ClosPubAny' or
Response_measure=  'NonEssentialShops' or
Response_measure=  'PlaceOfWorship' or 
Response_measure=  'PrivateGatheringRestrictions' or
Response_measure=  'QuarantineForInternationalTravellers' or 
Response_measure=  'RegionalStayHomeOrder' or 
Response_measure=  'RestaurantsCafes' or 
Response_measure=  'StayHomeGen' or 
Response_measure=  'EntertainmentVenues' or 
Response_measure=  'Teleworking' or 
Response_measure=  'WorkplaceClosures' or
Response_measure ='GymsSportsCentres' or
Response_measure ='HotelsOtherAccommodation' ); 

-- Cases

SELECT *
from StrictMeasuresAndCOVID19
where COVID19Indicator = 'cases';

create view cases_under_strictmeasures AS
SELECT *
from StrictMeasuresAndCOVID19
where COVID19Indicator = 'cases'; 

-- Cases
 -- Min 
	-- weekly count:
SELECT *
From cases_under_strictmeasures
where COVID19_WeeklyCount = (SELECT min(COVID19_WeeklyCount) from cases_under_strictmeasures);

SELECT distinct country, COVID19_WeeklyCount
From cases_under_strictmeasures
where COVID19_WeeklyCount = (SELECT min(COVID19_WeeklyCount) from cases_under_strictmeasures);

	-- cumulative count:
SELECT *
From cases_under_strictmeasures
where cumulative_count = (SELECT min(cumulative_count) from cases_under_strictmeasures);
    
SELECT distinct country, cumulative_count
From cases_under_strictmeasures
where cumulative_count = (SELECT min(cumulative_count) from cases_under_strictmeasures);

 -- Max
	-- weekly count
SELECT *
From cases_under_strictmeasures
where COVID19_WeeklyCount = (SELECT max(COVID19_WeeklyCount) from cases_under_strictmeasures);

SELECT distinct country, COVID19_WeeklyCount
From cases_under_strictmeasures
where COVID19_WeeklyCount = (SELECT max(COVID19_WeeklyCount) from cases_under_strictmeasures);

    -- cumulative count
SELECT *
From cases_under_strictmeasures
where cumulative_count = (SELECT max(cumulative_count) from cases_under_strictmeasures);

SELECT distinct country, cumulative_count
From cases_under_strictmeasures
where cumulative_count = (SELECT max(cumulative_count) from cases_under_strictmeasures);

-- Average     
	-- Average weekly count 
SELECT round(avg(COVID19_WeeklyCount),2)
FROM cases_under_strictmeasures; 

	-- Average of cumulative count 
SELECT round(avg(cumulative_count),2)
FROM cases_under_strictmeasures; 

	-- median of weekly count
SET @rowindex := -1;
SELECT
   AVG(c.COVID19_WeeklyCount) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           cases_under_strictmeasures.COVID19_WeeklyCount AS COVID19_WeeklyCount
    FROM cases_under_strictmeasures 
    ORDER BY cases_under_strictmeasures.COVID19_WeeklyCount) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

	-- median cumulative count: 

SET @rowindex := -1;
SELECT
   AVG(c.cumulative_count) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           cases_under_strictmeasures.cumulative_count AS cumulative_count
    FROM cases_under_strictmeasures 
    ORDER BY cases_under_strictmeasures.cumulative_count) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));


-- Deaths under strict measures:
Create view deaths_under_strictmeasures AS
select *
From StrictMeasuresAndCOVID19
where COVID19Indicator ='deaths';

	-- Max weekly count
SELECT *
FROM deaths_under_strictmeasures
where COVID19_WeeklyCount = (select max(COVID19_WeeklyCount) FROM deaths_under_strictmeasures );

SELECT distinct country, COVID19_WeeklyCount
FROM deaths_under_strictmeasures
where COVID19_WeeklyCount = (select max(COVID19_WeeklyCount) FROM deaths_under_strictmeasures );

	-- Max cumulative count
SELECT *
FROM deaths_under_strictmeasures
where cumulative_count = (select max(cumulative_count) FROM deaths_under_strictmeasures);

SELECT distinct country, cumulative_count
FROM deaths_under_strictmeasures
where cumulative_count = (select max(cumulative_count) FROM deaths_under_strictmeasures);

-- MIN 
	-- weekly count
SELECT  *
FROM deaths_under_strictmeasures
WHERE COVID19_WeeklyCount =(
SELECT min(COVID19_WeeklyCount)
From deaths_under_strictmeasures
);

SELECT  DISTINCT country, COVID19_WeeklyCount
FROM deaths_under_strictmeasures
WHERE COVID19_WeeklyCount =(
SELECT min(COVID19_WeeklyCount)
From deaths_under_strictmeasures
);

	-- cumulative count
SELECT  *
FROM deaths_under_strictmeasures 
WHERE cumulative_count =(
SELECT min(cumulative_count)
From deaths_under_strictmeasures
);

SELECT  DISTINCT country, cumulative_count
FROM deaths_under_strictmeasures 
WHERE cumulative_count =(
SELECT min(cumulative_count)
From deaths_under_strictmeasures
);

-- Average
	-- Average weekly count
select round(avg(COVID19_WeeklyCount),2)
From deaths_under_strictmeasures;

	-- Avergage cumulative count
select round(avg(cumulative_count),2)
From deaths_under_strictmeasures;

-- Median:
	-- Median of weekly count 
SET @rowindex := -1;
SELECT
   AVG(c.COVID19_WeeklyCount) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           deaths_under_strictmeasures.COVID19_WeeklyCount AS COVID19_WeeklyCount
    FROM deaths_under_strictmeasures 
    ORDER BY deaths_under_strictmeasures.COVID19_WeeklyCount) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));


	-- Median cumulative count :

SET @rowindex := -1;
SELECT
   AVG(c.cumulative_count) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           deaths_under_strictmeasures.cumulative_count AS cumulative_count
    FROM deaths_under_strictmeasures 
    ORDER BY deaths_under_strictmeasures.cumulative_count) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));


-- Let’s explore cases when relaxed measures used:
SELECT Response_measure
FROM MeasuresAndCOVID19CasesEurope
WHERE Response_measure= 'AdaptationOfWorkplacePartial' or  
Response_measure= 'IndoorOver1000' or
Response_measure=  'IndoorOver500' or
Response_measure=  'MasksVoluntaryAllSpacesPartial' or
Response_measure=  'MasksVoluntaryClosedSpaces' or
Response_measure=  'MasksVoluntaryClosedSpacesPartial' or
Response_measure=  'MasksMandatoryClosedSpacesPartial' or 
Response_measure=  'MasksVoluntaryAllSpaces' or
Response_measure=  'OutdoorOver1000' or
Response_measure=  'SocialCirclePartial' or 
Response_measure=  'StayHomeRiskGPartial' ;

-- Lets create a table
CREATE table RelaxedMeasuresAndCOVID19 AS
SELECT *
FROM MeasuresAndCOVID19CasesEurope
WHERE Response_measure= 'AdaptationOfWorkplacePartial' or  
Response_measure= 'IndoorOver1000' or
Response_measure=  'IndoorOver500' or
Response_measure=  'MasksVoluntaryAllSpacesPartial' or
Response_measure=  'MasksVoluntaryClosedSpaces' or
Response_measure=  'MasksVoluntaryClosedSpacesPartial' or
Response_measure=  'MasksMandatoryClosedSpacesPartial' or 
Response_measure=  'MasksVoluntaryAllSpaces' or
Response_measure=  'OutdoorOver1000' or
Response_measure=  'SocialCirclePartial' or 
Response_measure=  'StayHomeRiskGPartial' ;

 select * from RelaxedMeasuresAndCOVID19
 WHERE COVID19Indicator = 'cases';

--  create a view
create view cases_under_relaxedmeasures AS 
select * 
from RelaxedMeasuresAndCOVID19
where COVID19Indicator ='cases';

-- cases

 -- Max
	-- weekly count
SELECT  *
FROM cases_under_relaxedmeasures
WHERE COVID19_WeeklyCount = (
SELECT max(COVID19_WeeklyCount)
FROM cases_under_relaxedmeasures
);

SELECT  DISTINCT country, COVID19_WeeklyCount
FROM cases_under_relaxedmeasures
WHERE COVID19_WeeklyCount = (
SELECT max(COVID19_WeeklyCount)
FROM cases_under_relaxedmeasures
);

	-- cumulative count 
SELECT  *
FROM cases_under_relaxedmeasures
WHERE cumulative_count= (
SELECT max(cumulative_count)
FROM cases_under_relaxedmeasures);

SELECT  DISTINCT country, cumulative_count
FROM cases_under_relaxedmeasures
WHERE cumulative_count= (
SELECT max(cumulative_count)
FROM cases_under_relaxedmeasures);

-- Min
	-- Min weekly count
SELECT  *
FROM cases_under_relaxedmeasures
WHERE COVID19_WeeklyCount= (
SELECT min(COVID19_WeeklyCount)
FROM cases_under_relaxedmeasures);

SELECT  DISTINCT country, COVID19_WeeklyCount
FROM cases_under_relaxedmeasures
WHERE COVID19_WeeklyCount= (
SELECT min(COVID19_WeeklyCount)
FROM cases_under_relaxedmeasures);

	-- Min cumulative count
SELECT  *
FROM cases_under_relaxedmeasures
WHERE cumulative_count= (
SELECT min(cumulative_count)
FROM cases_under_relaxedmeasures
);

SELECT  DISTINCT country, cumulative_count
FROM cases_under_relaxedmeasures
WHERE cumulative_count= (
SELECT min(cumulative_count)
FROM cases_under_relaxedmeasures
);

-- Average 
	-- Avg weekly count
SELECT  round(avg(COVID19_WeeklyCount),2)
FROM cases_under_relaxedmeasures; 

	-- Avg cumulative count
SELECT  round(avg(cumulative_count),2)
FROM cases_under_relaxedmeasures;

	-- Median of Weekly count:
    
SET @rowindex := -1;
SELECT
   AVG(c.COVID19_WeeklyCount) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           cases_under_relaxedmeasures.COVID19_WeeklyCount AS COVID19_WeeklyCount
    FROM cases_under_relaxedmeasures 
    ORDER BY cases_under_relaxedmeasures.COVID19_WeeklyCount) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

	-- median of cumulative cases: 

SET @rowindex := -1;
SELECT
   AVG(c.cumulative_count) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           cases_under_relaxedmeasures.cumulative_count AS cumulative_count
    FROM cases_under_relaxedmeasures 
    ORDER BY cases_under_relaxedmeasures.cumulative_count) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));


-- Deaths 
create view deaths_under_relaxedmeasures AS 
select * from RelaxedMeasuresAndCOVID19
where COVID19Indicator ='deaths';

 -- Max
	-- weekly count 

SELECT  *
FROM deaths_under_relaxedmeasures
WHERE COVID19_WeeklyCount = (
SELECT max(COVID19_WeeklyCount)
FROM deaths_under_relaxedmeasures
);

SELECT  DISTINCT country, COVID19_WeeklyCount
FROM deaths_under_relaxedmeasures
WHERE COVID19_WeeklyCount = (
SELECT max(COVID19_WeeklyCount)
FROM deaths_under_relaxedmeasures
);
    -- cumulative count
SELECT  *
FROM deaths_under_relaxedmeasures
WHERE cumulative_count= (
SELECT max(cumulative_count)
FROM deaths_under_relaxedmeasures
);

SELECT  DISTINCT country, cumulative_count
FROM deaths_under_relaxedmeasures
WHERE cumulative_count= (
SELECT max(cumulative_count)
FROM deaths_under_relaxedmeasures
);

 -- Min
	-- wwekly count
SELECT  *
FROM deaths_under_relaxedmeasures
WHERE COVID19_WeeklyCount= (
SELECT min(COVID19_WeeklyCount)
FROM deaths_under_relaxedmeasures
);

SELECT  DISTINCT country, COVID19_WeeklyCount
FROM deaths_under_relaxedmeasures
WHERE COVID19_WeeklyCount= (
SELECT min(COVID19_WeeklyCount)
FROM deaths_under_relaxedmeasures
);

	-- cumulative count
SELECT  *
FROM deaths_under_relaxedmeasures
WHERE cumulative_count= (
SELECT min(cumulative_count)
FROM deaths_under_relaxedmeasures
);

SELECT  DISTINCT country, cumulative_count
FROM deaths_under_relaxedmeasures
WHERE cumulative_count= (
SELECT min(cumulative_count)
FROM deaths_under_relaxedmeasures
);

 --  Average 
	-- weekly count
SELECT  round(avg(COVID19_WeeklyCount),2)
FROM deaths_under_relaxedmeasures;

SELECT  round(avg(cumulative_count),2)
FROM deaths_under_relaxedmeasures;

	-- Median of cumulative count

SET @rowindex := -1;
SELECT
   AVG(c.cumulative_count) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           deaths_under_relaxedmeasures.cumulative_count AS cumulative_count
    FROM deaths_under_relaxedmeasures 
    ORDER BY deaths_under_relaxedmeasures.cumulative_count) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));


	-- median of weekly count of deaths  

SET @rowindex := -1;
SELECT
   AVG(c.COVID19_WeeklyCount) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           deaths_under_relaxedmeasures.COVID19_WeeklyCount AS COVID19_WeeklyCount
    FROM deaths_under_relaxedmeasures 
    ORDER BY deaths_under_relaxedmeasures.COVID19_WeeklyCount) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));



-- Lets explore cases when partial measures used
SELECT Response_measure
FROM MeasuresAndCOVID19CasesEurope
WHERE 
Response_measure= 'BanOnAllEventsPartial' or  
Response_measure= 'AdaptationOfWorkplace' or
Response_measure=  'ClosDaycarePartial' or
Response_measure=  'ClosHighPartial' or
Response_measure=  'ClosPrimPartial' or
Response_measure=  'ClosPubAnyPartial' or
Response_measure=  'ClosSecPartial' or 
Response_measure=  'ClosureOfPublicTransportPartial' or
Response_measure=  'EntertainmentVenuesPartial' or
Response_measure= 'MassGatherAllPartial ' or  
Response_measure= 'GymsSportsCentresPartial' or
Response_measure=  'HotelsOtherAccommodationPartial' or
Response_measure=  'IndoorOver100' or
Response_measure=  'MassGather50' or
Response_measure=  'MassGather50Partial' or
Response_measure=  'IndoorOver50' or 
Response_measure=  'MasksMandatoryAllSpacesPartial' or
Response_measure=  'MassGatherAll' or
Response_measure=  'NonEssentialShopsPartial' or 
Response_measure=  'OutdoorOver100' or
Response_measure=  'OutdoorOver50' or 
Response_measure=  'OutdoorOver500' or
Response_measure=  'PlaceOfWorshipPartial' or 
Response_measure=  'PrivateGatheringRestrictionsPartial' or
Response_measure=  'QuarantineForInternationalTravellersPartial' or 
Response_measure=  'RegionalStayHomeOrderPartial' or
Response_measure=  'RestaurantsCafesPartial' or 
Response_measure=  'SocialCircle' or 
Response_measure=  'StayHomeGenPartial' or 
Response_measure=  'StayHomeOrderPartial' or 
Response_measure=  'StayHomeRiskG' or 
Response_measure=  'TeleworkingPartial' or 
Response_measure=  'WorkplaceClosuresPartial' or 
Response_measure=  'MasksMandatoryClosedSpaces' ;


-- Lets create a table
create table Partial_InBtwMeasuresAndCOVID19 AS
SELECT *
FROM MeasuresAndCOVID19CasesEurope
WHERE 
Response_measure= 'BanOnAllEventsPartial' or  
Response_measure= 'AdaptationOfWorkplace' or
Response_measure=  'ClosDaycarePartial' or
Response_measure=  'ClosHighPartial' or
Response_measure=  'ClosPrimPartial' or
Response_measure=  'ClosPubAnyPartial' or
Response_measure=  'ClosSecPartial' or 
Response_measure=  'ClosureOfPublicTransportPartial' or
Response_measure=  'EntertainmentVenuesPartial' or
Response_measure= 'MassGatherAllPartial ' or  
Response_measure= 'GymsSportsCentresPartial' or
Response_measure=  'HotelsOtherAccommodationPartial' or
Response_measure=  'IndoorOver100' or
Response_measure=  'MassGather50' or
Response_measure=  'MassGather50Partial' or
Response_measure=  'IndoorOver50' or 
Response_measure=  'MasksMandatoryAllSpacesPartial' or
Response_measure=  'MassGatherAll' or
Response_measure=  'NonEssentialShopsPartial' or 
Response_measure=  'OutdoorOver100' or
Response_measure=  'OutdoorOver50' or 
Response_measure=  'OutdoorOver500' or
Response_measure=  'PlaceOfWorshipPartial' or 
Response_measure=  'PrivateGatheringRestrictionsPartial' or
Response_measure=  'QuarantineForInternationalTravellersPartial' or 
Response_measure=  'RegionalStayHomeOrderPartial' or
Response_measure=  'RestaurantsCafesPartial' or 
Response_measure=  'SocialCircle' or 
Response_measure=  'StayHomeGenPartial' or 
Response_measure=  'StayHomeOrderPartial' or 
Response_measure=  'StayHomeRiskG' or 
Response_measure=  'TeleworkingPartial' or 
Response_measure=  'WorkplaceClosuresPartial' or 
Response_measure=  'MasksMandatoryClosedSpaces' ;

select * 
from Partial_InBtwMeasuresAndCOVID19;

-- Cases 
-- create view 
create view cases_under_Partial_InBtwMeasuresAndCOVID19 AS
select * 
From Partial_InBtwMeasuresAndCOVID19
where COVID19Indicator ='cases';

-- Max
	-- weekly count
SELECT *
from cases_under_Partial_InBtwMeasuresAndCOVID19
where COVID19_WeeklyCount = (
SELECT max(COVID19_WeeklyCount)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
);

SELECT distinct country, COVID19_WeeklyCount
from cases_under_Partial_InBtwMeasuresAndCOVID19
where COVID19_WeeklyCount = (
SELECT max(COVID19_WeeklyCount)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
);
	-- cumulative count
SELECT *
from cases_under_Partial_InBtwMeasuresAndCOVID19
where  cumulative_count = (
SELECT max(cumulative_count)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
);

SELECT distinct country, cumulative_count
from cases_under_Partial_InBtwMeasuresAndCOVID19
where  cumulative_count = (
SELECT max(cumulative_count)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
);

-- MIN
	-- weekly count
SELECT *
from cases_under_Partial_InBtwMeasuresAndCOVID19
where COVID19_WeeklyCount = (
SELECT min(COVID19_WeeklyCount)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
);

SELECT distinct country, COVID19_WeeklyCount
from cases_under_Partial_InBtwMeasuresAndCOVID19
where COVID19_WeeklyCount = (
SELECT min(COVID19_WeeklyCount)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
);
	-- cumulative count
SELECT *
from cases_under_Partial_InBtwMeasuresAndCOVID19
where cumulative_count = (
SELECT min(cumulative_count)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
);

SELECT distinct country, cumulative_count
from cases_under_Partial_InBtwMeasuresAndCOVID19
where cumulative_count = (
SELECT min(cumulative_count)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
);
-- Avergae
	-- Average weekly count 
SELECT round(avg(COVID19_WeeklyCount),2)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19;
 
	-- Avergae cumulative count
SELECT round(avg(cumulative_count),2)
FROM cases_under_Partial_InBtwMeasuresAndCOVID19; 


-- median 
	-- median of weekly count of cases :
    
SET @rowindex := -1;
SELECT
   AVG(c.COVID19_WeeklyCount) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           cases_under_Partial_InBtwMeasuresAndCOVID19.COVID19_WeeklyCount AS COVID19_WeeklyCount
    FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
    ORDER BY cases_under_Partial_InBtwMeasuresAndCOVID19.COVID19_WeeklyCount) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

	-- median of cumualtive count of cases :
    
SET @rowindex := -1;
SELECT
   AVG(c.cumulative_count) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           cases_under_Partial_InBtwMeasuresAndCOVID19.cumulative_count AS cumulative_count
    FROM cases_under_Partial_InBtwMeasuresAndCOVID19 
    ORDER BY cases_under_Partial_InBtwMeasuresAndCOVID19.cumulative_count) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

-- Deaths 
-- create view 
create view deaths_under_partial_inbtwmeasuresandcovid19 AS 
select * from Partial_InBtwMeasuresAndCOVID19
where COVID19Indicator ='deaths';

	-- Max weekly count
SELECT *
FROM deaths_under_partial_inbtwmeasuresandcovid19
where  COVID19_WeeklyCount = (select max(COVID19_WeeklyCount) FROM deaths_under_partial_inbtwmeasuresandcovid19 );

SELECT distinct country, COVID19_WeeklyCount
FROM deaths_under_partial_inbtwmeasuresandcovid19
where  COVID19_WeeklyCount = (select max(COVID19_WeeklyCount) FROM deaths_under_partial_inbtwmeasuresandcovid19 );

	-- max cumulative count
SELECT distinct *
FROM deaths_under_partial_inbtwmeasuresandcovid19
where cumulative_count = (select max(cumulative_count) FROM deaths_under_partial_inbtwmeasuresandcovid19);

SELECT distinct country, cumulative_count
FROM deaths_under_partial_inbtwmeasuresandcovid19
where cumulative_count = (select max(cumulative_count) FROM deaths_under_partial_inbtwmeasuresandcovid19);

-- MIN
	-- weekly count
SELECT  *
FROM deaths_under_partial_inbtwmeasuresandcovid19 
WHERE COVID19_WeeklyCount =(
SELECT min(COVID19_WeeklyCount)
From deaths_under_partial_inbtwmeasuresandcovid19
);

SELECT  DISTINCT country, COVID19_WeeklyCount
FROM deaths_under_partial_inbtwmeasuresandcovid19 
WHERE COVID19_WeeklyCount =(
SELECT min(COVID19_WeeklyCount)
From deaths_under_partial_inbtwmeasuresandcovid19
);

	-- cumulative count
SELECT  *
FROM deaths_under_partial_inbtwmeasuresandcovid19 
WHERE cumulative_count =(
SELECT min(cumulative_count)
From deaths_under_partial_inbtwmeasuresandcovid19
);

SELECT  DISTINCT country, cumulative_count
FROM deaths_under_partial_inbtwmeasuresandcovid19 
WHERE cumulative_count =(
SELECT min(cumulative_count)
From deaths_under_partial_inbtwmeasuresandcovid19
);

-- Average
	-- Average weekly count
select round(avg(COVID19_WeeklyCount),2)
From deaths_under_partial_inbtwmeasuresandcovid19;

	-- Avergage cumulative count
select round(avg(cumulative_count),2)
From deaths_under_partial_inbtwmeasuresandcovid19;

-- median of weekly count of deaths 
SET @rowindex := -1;
SELECT
   AVG(c.COVID19_WeeklyCount) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           deaths_under_partial_inbtwmeasuresandcovid19.COVID19_WeeklyCount AS COVID19_WeeklyCount
    FROM deaths_under_partial_inbtwmeasuresandcovid19 
    ORDER BY deaths_under_partial_inbtwmeasuresandcovid19.COVID19_WeeklyCount) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

-- median of cumualtive deaths 

SET @rowindex := -1;
SELECT
   AVG(c.cumulative_count) as Median 
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           deaths_under_partial_inbtwmeasuresandcovid19.cumulative_count AS cumulative_count
    FROM deaths_under_partial_inbtwmeasuresandcovid19 
    ORDER BY deaths_under_partial_inbtwmeasuresandcovid19.cumulative_count) AS c
WHERE
c.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

-- lets check countries in each of the three categories: strict, partial, and relaex response measures
-- all countries in our table
Select distinct country
From MeasuresAndCOVID19CasesEurope;

    -- StrictMeasuresAndCOVID19
Select distinct country
From StrictMeasuresAndCOVID19;
    -- RelaxedMeasuresAndCOVID19
Select distinct country 
From RelaxedMeasuresAndCOVID19;
    -- Partial_InBtwMeasuresAndCOVID19
Select distinct country 
From Partial_InBtwMeasuresAndCOVID19;

-- Lets check distinct COVID19_YearWeek for each category:strict, partial, and relaex response measures

Select distinct COVID19_YearWeek
From MeasuresAndCOVID19CasesEurope;

Select distinct COVID19_YearWeek
From StrictMeasuresAndCOVID19;
    -- RelaxedMeasuresAndCOVID19
Select distinct COVID19_YearWeek 
From RelaxedMeasuresAndCOVID19;
    -- Partial_InBtwMeasuresAndCOVID19
Select distinct COVID19_YearWeek 
From Partial_InBtwMeasuresAndCOVID19;
