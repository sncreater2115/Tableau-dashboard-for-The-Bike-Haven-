--1
select * from customer;
alter table customer
drop column customeralternatekey, drop column title,
drop column namestyle, drop column birthdate,
drop column maritalstatus, drop column suffix,
drop column emailaddress, drop column yearlyincome,
drop column totalchildren, drop column numberchildrenathome,
drop column englisheducation, drop column spanisheducation,
drop column frencheducation, drop column englishoccupation,
drop column spanishoccupation, drop column frenchoccupation,
drop column houseownerflag, drop column numbercarsowned,
drop column addressline1, drop column addressline2,
drop column phone, drop column datefirstpurchase;
-- concatenating the names and creating a new customer table
create table customer_new as (select customerkey, geographykey, coalesce(firstname, '') || case 
        when middlename ='NULL' then ' '
        else ' ' || middlename || ' '
    end || coalesce(lastname, '') as customername, commutedistance from customer);
--2
select * from geography;
alter table geography
	drop stateprovincecode, drop countryregioncode,
	drop spanishcountryregionname, drop frenchcountryregionname,
	drop postalcode, drop salesterritorykey,drop ipaddresslocator;
--merging the customer and geography table
create table cust_geo as (select city, stateprovincename as state, englishcountryregionname as country,geography.geographykey, customerkey,
customername, commutedistance from geography join customer_new
	on geography.geographykey=customer_new.geographykey);
select * from cust_geo;
--3
select * from product;
alter table product
	drop productalternatekey, drop safetystocklevel,
	drop reorderpoint, drop size,
	drop daystomanufacture, drop englishdescription,
	drop startdate, drop enddate, drop status;
select * from productcategory;
select * from productsubcategory;
alter table productsubcategory
	drop productsubcategoryalternatekey;
-- merging the product with category and subcategory
create table product_details as (select p.productcategorykey, p.englishproductcategoryname as category, 
       p.productsubcategorykey, p.englishproductsubcategoryname as subcategory, 
       product.productkey, product.englishproductname as productname, 
       product.color, product.productline, product.modelname 
from (select productcategory.productcategorykey, 
             productcategory.englishproductcategoryname, 
             productsubcategory.productsubcategorykey, 
             productsubcategory.englishproductsubcategoryname 
      from productcategory 
      join productsubcategory on productcategory.productcategorykey = productsubcategory.productcategorykey
     ) as p 
join product on product.productsubcategorykey = p.productsubcategorykey);
select * from product_details;
--4
select * from date;
alter table date
drop daynumberofweek, drop calendarquarter,
drop calendaryear, drop calendarsemester,
drop fiscalquarter, drop fiscalyear,
drop fiscalsemester, drop daynumberofmonth,
drop daynumberofyear, drop weeknumberofyear,
drop monthnumberofyear, drop englishdaynameofweek,
drop spanishdaynameofweek, drop frenchdaynameofweek,
drop englishmonthname, drop spanishmonthname,
drop frenchmonthname;
-- 5
select * from internetsales;
alter table internetsales
	drop promotionkey, drop currencykey,
	drop salesordernumber, drop orderdate,
	drop duedate, drop shipdate;
alter table internetsales alter column totalproductcost
set data type totalproductcost::integer;








