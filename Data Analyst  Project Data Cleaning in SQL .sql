--cleaning  data 

select *
from [portofolio project]..nashvillehousing


--standerdize data format
select saledate ,CONVERT(date,saledate)
from [portofolio project]..nashvillehousing

update nashvillehousing
set saledateconveted=CONVERT(date,saledate)


alter table nashvillehousing
add saledateconveted date;

--populate property address data
select *
from [portofolio project]..nashvillehousing
order by parcelid

select ke.parcelid,te.parcelid,ke.propertyaddress,te.propertyaddress,isnull(ke.propertyaddress,te.propertyaddress)
from [portofolio project]..nashvillehousing ke
join [portofolio project]..nashvillehousing te
on ke.parcelid=te.parcelid
and ke.uniqueid <> te.uniqueid
where ke.propertyaddress is null

update ke
set propertyaddress=isnull(ke.propertyaddress,te.propertyaddress)
from [portofolio project]..nashvillehousing ke
join [portofolio project]..nashvillehousing te
on ke.parcelid=te.parcelid
and ke.uniqueid <> te.uniqueid
where ke.propertyaddress is null



--breaking out address into individual columns (address,city,state)

select propertyaddress
from [portofolio project]..nashvillehousing
order by parcelid

select propertyaddress,
substring(propertyaddress,1,CHARINDEX(',',propertyaddress) -1) as address,
substring(propertyaddress,CHARINDEX(',',propertyaddress) +1,len(propertyaddress)) as address
from [portofolio project]..nashvillehousing



alter table [portofolio project]..nashvillehousing
add propertySplitaddress varchar(255)

update  [portofolio project]..nashvillehousing
set propertySplitaddress=substring(propertyaddress,1,CHARINDEX(',',propertyaddress) -1)



alter table [portofolio project]..nashvillehousing
add propertySplicity varchar(255)


update  [portofolio project]..nashvillehousing
set propertySplicity=substring(propertyaddress,CHARINDEX(',',propertyaddress) +1,len(propertyaddress))


select *
from [portofolio project]..nashvillehousing



--change Y and N to yes and no in "sold as vacant" field
select distinct soldasvacant,count(soldasvacant)
from[portofolio project]..nashvillehousing
group by soldasvacant
order by 2


select soldasvacant
,case when soldasvacant ='Y' then 'yes'
 when soldasvacant='N' then 'no'
 else soldasvacant
 end
from [portofolio project]..nashvillehousing


update [portofolio project]..nashvillehousing
set soldasvacant=case when soldasvacant ='Y' then 'yes'
 when soldasvacant='N' then 'no'
 else soldasvacant
 end


-- remove duplicates
with rownumcte as
(
select *,
ROW_NUMBER() over (
partition by parcelid,
             propertyaddress,
			 saleprice,
			 saledate,
			 legalreference
			 order by uniqueid
			 )
			 row_num

from [portofolio project]..nashvillehousing
)
select*
from rownumcte
where row_num>1 


