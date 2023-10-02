create database cars;
use cars;
select*from car_dekho;
drop schema cars;
use cars;
## READ DATA 
select*from car_dekho;

## Total cars : to get the count of total records

SELECT 
    COUNT(*) AS total_no_of_data
FROM
    car_dekho;

## The manager ask the employee how many cars will be available in 2023?

SELECT 
    COUNT(*) AS total_car_available
FROM
    car_dekho
WHERE
    year = 2023;

## The manager ask the employee how many cars are available in 2020,2021,2022 ?

SELECT 
    COUNT(*) AS total_car_available
FROM
    car_dekho
WHERE
    year = 2020; #74
SELECT 
    COUNT(*) AS total_car_available
FROM
    car_dekho
WHERE
    year = 2021; #7
SELECT 
    COUNT(*) AS total_car_available
FROM
    car_dekho
WHERE
    year = 2022; #7
-- GROUP BY --
SELECT 
    COUNT(*) AS total_car_available
FROM
    car_dekho
WHERE
    year IN (2020 , 2021, 2022)
GROUP BY year;

## Client asked me to print the total number of car by year . But I dont see all the details 

SELECT 
    year, COUNT(*) AS total_car
FROM
    car_dekho
GROUP BY year;

## Client asked to car dealer agent How many diesel cars will be there in 2020? 

SELECT 
    COUNT(*) AS diesel_cars
FROM
    car_dekho
WHERE
    year = 2020 AND fuel = 'Diesel'; 

## Client requested a car dealer agent how many petrol cars will there be in 2020?

SELECT 
    COUNT(*) AS petrol_cars
FROM
    car_dekho
WHERE
    year = 2020 AND fuel = 'Petrol';

## The manager told to the employee to give a print all the fuel cars(Petrol,Diesel,CNG) come by all year.

SELECT 
    year, COUNT(*) AS fuel_cars
FROM
    car_dekho
WHERE
    fuel IN ('Petrol' , 'Diesel', 'CNG')
GROUP BY year;

## Manager said that there are more than 100 cars in a given year, Which year had more than 100 cars?

SELECT 
    year, COUNT(*)
FROM
    car_dekho
GROUP BY year
HAVING COUNT(*) > 100;

## Manager said to the employee all cars count details between year 2015 and 2023. We need a complete list

SELECT 
    year, COUNT(*)
FROM
    car_dekho
WHERE
    year BETWEEN 2015 AND 2023
GROUP BY year; 

## The manager said to the employee all car details between 2015 and 2023 , we need complete list.

SELECT 
    *
FROM
    car_dekho
WHERE
    year BETWEEN 2015 AND 2023;

## END ##
