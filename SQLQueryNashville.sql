/* Cleaning The Data in SQL Queries */


SELECT *
FROM NashvillePortfolio.dbo.NashvilleHousing
 

-- Standardize Date Format in the Query Result ---
SELECT saleDate, CONVERT(Date, SaleDate) AS SaleDateConverted
FROM NashvillePortfolio.dbo.NashvilleHousing

-- Alter Table to Change Column Data Type ---
ALTER TABLE NashvillePortfolio.dbo.NashvilleHousing
ALTER COLUMN SaleDate Date

--- Update the table ----
UPDATE NashvillePortfolio.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate, 101)

 --------------------------------------------------------------------------------------------------------------------------
 --- Populate Property Address Data
 SELECT *
FROM NashvillePortfolio.dbo.NashvilleHousing
ORDER BY ParcelID

-- Select and Display Rows where PropertyAddress is NULL, along with a corresponding non-null PropertyAddress from another row
SELECT 
	a.ParcelID, a.PropertyAddress, 
	b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvillePortfolio.dbo.NashvilleHousing AS a
JOIN NashvillePortfolio.dbo.NashvilleHousing AS b
ON 
	a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--- Update PropertyAddress where it is NULL ---
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvillePortfolio.dbo.NashvilleHousing AS a
JOIN NashvillePortfolio.dbo.NashvilleHousing AS b
ON 
	a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--------------------------------------------------------------------------------------------------------------------------

--- Breaking out Address into Individual Columns (Address, City, State) ---
SELECT PropertyAddress
FROM NashvillePortfolio.dbo.NashvilleHousing

-- Selecting individual components of the PropertyAddress and creating new columns
SELECT
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS CityState
FROM NashvillePortfolio.dbo.NashvilleHousing


ALTER TABLE NashvillePortfolio.dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvillePortfolio.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvillePortfolio.dbo.NashvilleHousing
Add PropertyCity NVARCHAR(255);

UPDATE NashvillePortfolio.dbo.NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT * FROM NashvillePortfolio.dbo.NashvilleHousing

SELECT OwnerAddress
FROM NashvillePortfolio.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM NashvillePortfolio.dbo.NashvilleHousing

ALTER TABLE NashvillePortfolio.dbo.NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvillePortfolio.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvillePortfolio.dbo.NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvillePortfolio.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvillePortfolio.dbo.NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvillePortfolio.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM NashvillePortfolio.dbo.NashvilleHousing

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvillePortfolio.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

-- Select Query
SELECT 
  SoldAsVacant,
  CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
  END AS UpdatedSoldAsVacant
FROM NashvillePortfolio.dbo.NashvilleHousing;

-- Update Query
UPDATE NashvillePortfolio.dbo.NashvilleHousing
SET SoldAsVacant = 
  CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
  END;

  -----------------------------------------------------------------------------------------------------------------------------------------------------------

--- Remove Duplicates ---

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
        PARTITION BY	ParcelID,
                        PropertyAddress,
                        SalePrice,
                        SaleDate,
                        LegalReference
        ORDER BY UniqueID
    ) AS row_num
FROM NashvillePortfolio.dbo.NashvilleHousing
)

-- Select non-duplicate records
SELECT *
FROM RowNumCTE
WHERE row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From NashvillePortfolio.dbo.NashvilleHousing


ALTER TABLE NashvillePortfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
