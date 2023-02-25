SELECT *
FROM NashvilleHousingDataforDataCleaning


SELECT PropertyAddress
FROM NashvilleHousingDataforDataCleaning
WHERE PropertyAddress IS NULL

--BREAKING OUT THE ADDRESS COLUMN

SELECT 
--to remove the comma and separate the address column
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, Len(PropertyAddress)) as Address
FROM NashvilleHousingDataforDataCleaning


---adding the newly created columns to the dataset
ALTER TABLE NashvilleHousingDataforDataCleaning
Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousingDataforDataCleaning
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousingDataforDataCleaning
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousingDataforDataCleaning
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, Len(PropertyAddress))


--USING PARSENAME TO SEPARATE THE OWNERADDRESS COLUMN, THE COMMA WERE REPLACED WITH THE PERIODS BECAUSE PARSENAME WORKS WITH PERIODS
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM NashvilleHousingDataforDataCleaning


---adding the newly created columns to the dataset
ALTER TABLE NashvilleHousingDataforDataCleaning
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousingDataforDataCleaning
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)


ALTER TABLE NashvilleHousingDataforDataCleaning
Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousingDataforDataCleaning
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)


ALTER TABLE NashvilleHousingDataforDataCleaning
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousingDataforDataCleaning
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',','.'),1)



--changing the y and n in the  sold as vacant column
SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousingDataforDataCleaning

UPDATE NashvilleHousingDataforDataCleaning
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant
	   END


-- REMOVING DUPLICATES BY USING A CTE and deleting them 

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM NashvilleHousingDataforDataCleaning
)
DELETE
FROM RowNumCTE
WHERE row_num > 1


-- DELETE UNUSED COLUMNS
SELECT *
FROM NashvilleHousingDataforDataCleaning

ALTER TABLE NashvilleHousingDataforDataCleaning
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate