/*
Cleaning Data in SQL Queries
*/

select *
from NashvilleHousing
---------------------------------------------------------

-- Standarize Data format


ALter table NashvilleHousing
ADD SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

select SaleDate, SaleDateConverted
from NashvilleHousing

select SaleDateConverted,*
from NashvilleHousing
---------------------------------------------------------

--Pupolate property Address Data
select *
from NashvilleHousing
where propertyAddress is null
order by ParcelID

select a.ParcelID, a.propertyAddress, b.ParcelID, b.propertyAddress, ISNULL(a.propertyAddress, b.propertyAddress)
from NashvilleHousing a
join NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.propertyAddress is null

update a
set propertyAddress = ISNULL(a.propertyAddress, b.propertyAddress)
from NashvilleHousing a
join NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.propertyAddress is null
---------------------------------------------------------

--Breaking out address into individual columns(Address, City, State)

select propertyAddress
from NashvilleHousing 


select 
SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress)-1 ) as PropertySpilitAddress,
SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress)+1, len(propertyAddress) ) as PropertySpilitsCity
from NashvilleHousing 


Alter table NashvilleHousing
add PropertySpilitAddress nvarchar(255) 

update NashvilleHousing
set PropertySpilitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress)-1 )

Alter table NashvilleHousing
add PropertySpilitsCity nvarchar(255) 

update NashvilleHousing
set PropertySpilitsCity = SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress)+1, len(propertyAddress) )

select *
from NashvilleHousing 

--

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from NashvilleHousing 
--------------------------------
alter table  NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
--
alter table  NashvilleHousing
add OwnerSplitCity  Nvarchar(255)

update NashvilleHousing
set OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
--
alter table  NashvilleHousing
add OwnerSplitState   Nvarchar(255)

update NashvilleHousing
set OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
----------------------------------
select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState,*
from NashvilleHousing 

---------------------------------------------------------

--Change Y and N to Yes and No in the SoldAsVacant field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing 
group by SoldAsVacant

SELECT SoldAsVacant
, CASE when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   END 
from NashvilleHousing 

Update NashvilleHousing
set SoldAsVacant= CASE when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   END
---------------------------------------------------------

--Remove Duplicates

WITH  Row_numCTE AS(
select *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) row_num
from NashvilleHousing
--order by ParcelID
)
DELETE
from Row_numCTE
where row_num>1
---------------------------------------------------------

--DELETE unused columns

select * from NashvilleHousing
--

alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

