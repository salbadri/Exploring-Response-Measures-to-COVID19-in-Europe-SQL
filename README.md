# Exploring-Correlation-between-response-measures-to-COVID19-and-Cases/deaths-due-to-COVID19-in-EU-and-EEA-Using-SQL
#### -- Project Status: [Completed]


### Summary of the analysis can be found [here](https://github.com/salbadri/Exploring-Response-Measures-to-COVID19-in-Europe-SQL/blob/main/Sarah_Results%20of%20Analysis.pdf)
### Dictionary to response measures terms can be found [here]( https://github.com/salbadri/Exploring-Response-Measures-to-COVID19-in-Europe-SQL/blob/main/Dictionary%20to%20Response%20Measures.docx)
### SQL script (MYSQL) can be found [here](https://github.com/salbadri/Exploring-Response-Measures-to-COVID19-in-Europe-SQL/blob/main/COVID19CasesAndResponse_EDA.sql)

## Project Intro/Objective
The purpose of this project is to examine the correlation between response measures to COVID19 and Cases/deaths due to COVID19 in EU (European Union) and EEA (The European Economic Area). I hypothesized that there is a correlation between Response measures and COVID19 cases and COVID19deaths. The stricter the measures, the lower COVID19 Cases and COVID19 deaths in EU and EEA.

### Technologies
* MYSQL (Version 8.0.25)
* SQLite (Version 3.34.1)

## Project Description
I created a database (schema) and imported datasets of interest to the database: COVID19Cases which can be found [here](https://www.ecdc.europa.eu/en/publications-data/download-historical-data-20-june-2022-weekly-number-new-reported-covid-19-cases), and responseToCOVID19 which can be found [here](https://www.ecdc.europa.eu/en/publications-data/download-data-response-measures-covid-19). 

[COVID19Cases table]( https://www.ecdc.europa.eu/en/publications-data/download-historical-data-20-june-2022-weekly-number-new-reported-covid-19-cases)
Both Datasets were retrieved from the [European Center for Disease Prevention and Control]( https://www.ecdc.europa.eu/en).

* The responseToCOVID19 table has information about response measures for 30 European countries. This dataset has  4 features and 2060 entries. Features: country, Response_Measure, date_start, date_end. Dictionary to Response measures

* COVID19Cases table COVID19Cases dataset has information about COVID19 cases and deaths for 228 countries. This dataset consists of 11 features and 53074 entries. Variables: country, country_code, continent, population, indicator (cases or deaths), weekly_count, year_week, rate_14_day, cumulative_count, source, and note. We only used country, indicator, weekly_count, year_week, and cumulative_count. 

## Creating a new table by Joining responseToCOVID19 table and COVID19Cases table:

* I created a new table, MeasuresAndCOVID19CasesEurope, by joining the responseToCOVID19 table and COVID19Cases table (inner join). I joined on the country from the two tables and on yearWeek_end from responseToCovid19 and year_week from COVID19Cases. I am interested in exploring the number of cases/deaths by the end of applying each response measure. 

## Observations:

We explored our newly created table MeasuresAndCOVID19CasesEurope. 
* I checked what are the most common response measures? And what response measures to COVID19 were adapted for more than 90 days? 
* What measures are used each year? What is the frequency of each response measure for each year? 
* How many countries adapted stay at home order (lockdown)? which countries did not adapt lockdown? 

* Then I explored COVID19 Cases and COVID19 Deaths regardless of what response measures were adapted (see the table below)

![github-small](https://github.com/salbadri/Exploring-Response-Measures-to-COVID19-in-Europe-SQL/blob/main/images/Table1.png). 


* Then I divided up the table of COVID19 and Response measures into three categories based on response measures: StrictMeasuresAndCOVID19 (Strict response Measures), RelaxedMeasuresAndCOVID19 (Relaxed response measures), and Partial_InBtwMeasuresAndCOVID19 (response measures that lie in btw strict and relaxed response measure).  We expected to have a lower count of cases and deaths under Strict response measures in comparison to Partial_InBtwMeasuresAndCOVID19 and Relaxed response measures. We expected to have a lower count of cases and deaths under  Partial_InBtwMeasuresAndCOVID19 comparing to Relaxed response measures. 
See table below
![github-small]( https://github.com/salbadri/Exploring-Response-Measures-to-COVID19-in-Europe-SQL/blob/main/images/Table2.png)

## Conclusion: 

Although Deaths and cases are lower under Strict response measures compared to Deaths and cases under Partial_In_between response measures and Relaxed response measures. But, We cannot conclude that the stricter the response measures, the lower the COVID19 deaths and cases. Other factors that must be considered such as the population count of each country, testing procedures each country adapted, Age, and Mortality (are deaths linked directly to COVID19?). 


Limitations: We must consider other factors such as the population count of each country, testing procedures each country adapted, Age, and Mortality (are deaths linked directly to COVID19?). 


## Needs of this project

- data exploration/descriptive statistics
- data processing/cleaning

## Issues:

I had problem importing my datasets to the Database - whenever I try, not all dataset gets imported. I tried [different methods](https://bugs.mysql.com/bug.php?id=97813) suggested by MySQL to fix the problem, but non worked

Solution: I ended up importing the datasets as follow:
1)	I created a database on DB browser for SQLite and uploaded my datasets to the database.
2)	I exported the Database as SQL query.
3)	Using Visual Studio Code, I edited the code; made the necessary changes since there are differences in the syntaxes btw SQLite and MySQL.
4)	On my MYSQL workbench I went to Administration -> Data Import/Restore -> Import from self-contained file. 

