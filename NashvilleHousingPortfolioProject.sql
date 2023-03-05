--Cleaning Data in SQL Queries

----------

-- Standardize date format
SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

----------

-- Populate Property Address for null values
SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b 
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b 
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

----------

--Breaking Property Address up into individual columns (Address, City, State)
SELECT PropertyAddress
From NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +2, LEN(PropertyAddress)) as City
From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +2, LEN(PropertyAddress))

SELECT PropertySplitAddress, PropertySplitCity
FROM NashvilleHousing


Select OwnerAddress
From NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM NashvilleHousing

----------

--Change Y and N to Yes and No in "Sold as Vacant" field
Select SoldAsVacant
From NashvilleHousing

Select SoldAsVacant
From NashvilleHousing
WHERE LEN(SoldAsVacant) < 2
    AND SUBSTRING(SoldAsVacant, 1, Len(SoldAsVacant)) = 'N'

UPDATE NashvilleHousing
SET SoldAsVacant = 'No'
WHERE LEN(SoldAsVacant) < 2
    AND SUBSTRING(SoldAsVacant, 1, Len(SoldAsVacant)) = 'N'

Select SoldAsVacant
From NashvilleHousing
WHERE LEN(SoldAsVacant) < 2
    AND SUBSTRING(SoldAsVacant, 1, Len(SoldAsVacant)) = 'Y'

UPDATE NashvilleHousing
SET SoldAsVacant = 'Yes'
WHERE LEN(SoldAsVacant) < 2
    AND SUBSTRING(SoldAsVacant, 1, Len(SoldAsVacant)) = 'Y'

------------

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
    row_number() OVER (
        PARTITION BY ParcelID, PropertyAddress, SaleDate, LegalReference
        ORDER BY UniqueID
    ) as RowNum
FROM NashvilleHousing
--Order BY ParcelID
)
-- DELETE
-- FROM RowNumCTE
-- WHERE RowNum > 1

SELECT *
FROM RowNumCTE
WHERE RowNum > 1
ORDER BY PropertyAddress

------------

--Delete unused columns
SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate