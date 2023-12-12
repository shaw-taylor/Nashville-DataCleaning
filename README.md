# Data Cleaning Project

## Project Description

This SQL-based data cleaning project focuses on standardizing date formats, populating missing property addresses, breaking down addresses into individual components, and transforming "Sold as Vacant" values. The project also includes removing duplicate records and deleting unused columns.

## Steps

1. **Standardize Date Format:**
   - Convert and update SaleDate to a standardized format.

2. **Populate Property Address Data:**
   - Fill missing property addresses based on non-null counterparts.

3. **Break Out Address Components:**
   - Create separate columns for Address and City in the PropertyAddress field.

4. **Parse Owner Address:**
   - Split OwnerAddress into Address, City, and State components.

5. **Change 'Y' and 'N' to 'Yes' and 'No':**
   - Update the "Sold as Vacant" field values.

6. **Remove Duplicates:**
   - Identify and remove duplicate records based on specific columns.

7. **Delete Unused Columns:**
   - Eliminate unnecessary columns from the dataset.

**Note:**
Ensure to back up the dataset before executing any updates or deletions.
