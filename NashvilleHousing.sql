SELECT * FROM housing.`nashville housing`;

SELECT saledate
FROM housing.`nashville housing`;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM housing.`nashville housing` a
JOIN housing.`nashville housing` b
  on a.ParcelID = b.ParcelID;
  
SELECT substring(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1) as Address,
substring(PropertyAddress, LOCATE(',', PropertyAddress) +1 , length(PropertyAddress)) as City
FROM housing.`nashville housing`;

select OwnerAddress
FROM housing.`nashville housing`;

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 1), ',', -1) AS OwnerAddress,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS OwnerCity,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1) AS OwnerState
FROM housing.`nashville housing`;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE housing.`nashville housing`
ADD PropertySplitAddress nvarchar(255);

UPDATE housing.`nashville housing`
SET PropertySplitAddress = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 1), ',', -1) ;

ALTER TABLE housing.`nashville housing`
ADD PropertySplitCity nvarchar(255);

UPDATE housing.`nashville housing`
SET PropertySplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) ;

ALTER TABLE housing.`nashville housing`
ADD PropertySplitState nvarchar(255);

UPDATE housing.`nashville housing`
SET PropertySplitState = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1) ;

SET SQL_SAFE_UPDATES = 1;

SELECT distinct(SoldAsVacant), count(SoldAsVacant)
FROM housing.`nashville housing`
Group By SoldAsVacant
Order By 2;

SELECT SoldAsVacant,
  Case WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
    END
FROM housing.`nashville housing`;

SET SQL_SAFE_UPDATES = 0;

UPDATE housing.`nashville housing`
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

SET SQL_SAFE_UPDATES = 1;

With RowNumCTE AS (
SELECT *,
  row_number() Over(
  Partition BY ParcelID,
			   PropertyAddress,
               SalePrice,
               SaleDate,
               LegalReference
               Order BY 
               `ï»¿UniqueID`
               ) row_num
FROM housing.`nashville housing`
)
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
Order BY PropertyAddress;

-- No Duplicates Found
 
 -- Removing Unused Columns
 
SELECT *
FROM housing.`nashville housing`;


ALTER TABLE housing.`nashville housing`
DROP COLUMN OwnerAddress,
DROP column  TaxDistrict, 
DROP COLUMN PropertyAddress;