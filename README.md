# WELCOME TO DANNY'S DINER

This is the first case Study to Danny's [8 week SQL Challenge](https://8weeksqlchallenge.com) where you must answer his case studies questions by using the data given. 

## Introduction 
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

You can access his case study questions [here](https://8weeksqlchallenge.com/case-study-1/) where he also provides you bonus questions for extra practice. 

## Functions used
* DENSE_RANK() allows you to rank rows without leaving gaps if more than one row have the same rank. 
* OVER() function is an important part of all ranking functions where it tells the function about the window and the order in which the wors will be placed. 
* PARTITION BY is when rankings are computed separately by the column topic you chose. In this case, the rankings are separted by s.customer_id. 
### How it's used
````sql
SELECT DENSE_RANK() OVER(PARTITION BY column) AS column_name
````

***these functions are primarily used throughout the case study questions. They follow the same format so it is very easy once you get the hang of it!***

* CASE WHEN condition
