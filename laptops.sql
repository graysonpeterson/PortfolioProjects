SELECT *
FROM laptops

------ CLEAN THE DATA ------

--"column 1" is unnecessary
ALTER TABLE laptops
DROP COLUMN column1

--"discount" doesn't mean anything - we dont't know where the discount is available, and if it's available in the US.
ALTER TABLE laptops
DROP COLUMN discount

--need to convert "price" from rupees to USD since I'm in America
--Step 1: remove the rupee character in the "price" column for each value
SELECT *, SUBSTRING(price, 2, len(price)) as priceRupees
FROM laptops

ALTER TABLE laptops
ADD priceRupees NVARCHAR(255)

SELECT priceRupees
FROM laptops

UPDATE laptops
SET priceRupees = SUBSTRING(price, 2, len(price))

ALTER TABLE laptops
DROP COLUMN price

--Now, remove the comma character so we can convert to int
UPDATE laptops
SET priceRupees = REPLACE(priceRupees, ',', '')

-- Step 2, convert rupee to USD. Use priceRupeesAs of 03/07/2023, 1 Rupee = 0.012214 USD
SELECT priceRupees, CONVERT(int, priceRupees) * 0.012214 as PriceUSD
FROM laptops

ALTER TABLE laptops
ADD priceUSD int

UPDATE laptops
SET priceUSD = CONVERT(int, priceRupees) * 0.012214


-- Clean processor column
SELECT Processor, CHARINDEX(':', Processor,1), TRIM(STUFF(Processor, 1, CHARINDEX(':', Processor,1), ''))
FROM laptops
WHERE  CHARINDEX(':', Processor,1) = 10

UPDATE laptops
SET Processor = TRIM(STUFF(Processor, 1, CHARINDEX(':', Processor,1), ''))
WHERE  CHARINDEX(':', Processor,1) = 10

SELECT CHARINDEX('Intel',Processor,1)
FROM laptops

-- Shows the rows where Processor column includes relevant information
SELECT *
FROM laptops
WHERE CHARINDEX('Intel',Processor,1) > 0
    OR CHARINDEX('AMD',Processor,1) > 0
    OR CHARINDEX('Qualcomm',Processor,1) > 0
    OR CHARINDEX('Apple',Processor,1) > 0
    OR CHARINDEX('i3',Processor,1) > 0
    OR CHARINDEX('i5',Processor,1) > 0
    OR CHARINDEX('r3',Processor,1) > 0
    OR CHARINDEX('Ryzen',Processor,1) > 0

--Shows the rows that need to be cleaned
SELECT title, Processor
FROM laptops
WHERE CHARINDEX('Intel',Processor,1) = 0
    AND CHARINDEX('AMD',Processor,1) = 0
    AND CHARINDEX('Qualcomm',Processor,1) = 0
    AND CHARINDEX('Apple',Processor,1) = 0
    AND CHARINDEX('i3',Processor,1) = 0
    AND CHARINDEX('i5',Processor,1) = 0
    AND CHARINDEX('r3',Processor,1) = 0
    AND CHARINDEX('Ryzen',Processor,1) = 0

-- SELECT title, Processor, SUBSTRING(title, CHARINDEX('Core', title, 1), (CHARINDEX(' - ', title))-(CHARINDEX('Core', title)))
-- FROM laptops
-- WHERE CHARINDEX('Intel',Processor,1) = 0
--     AND CHARINDEX('AMD',Processor,1) = 0
--     AND CHARINDEX('Qualcomm',Processor,1) = 0
--     AND CHARINDEX('Apple',Processor,1) = 0
--     AND CHARINDEX('i3',Processor,1) = 0
--     AND CHARINDEX('i5',Processor,1) = 0
--     AND CHARINDEX('r3',Processor,1) = 0
--     AND CHARINDEX('Ryzen',Processor,1) = 0 

SELECT title, Processor
, (CASE 
    WHEN CHARINDEX('Ryzen', title, 1) > 0
        THEN SUBSTRING(title, CHARINDEX('Ryzen', title, 1), (CHARINDEX(' - ', title))-(CHARINDEX('Ryzen', title)))
    ELSE SUBSTRING(title, CHARINDEX('Core', title, 1), (CHARINDEX(' - ', title))-(CHARINDEX('Core', title)))
    END) as ProcessorFixed
FROM laptops
WHERE CHARINDEX('Intel',Processor,1) = 0
    AND CHARINDEX('AMD',Processor,1) = 0
    AND CHARINDEX('Qualcomm',Processor,1) = 0
    AND CHARINDEX('Apple',Processor,1) = 0
    AND CHARINDEX('i3',Processor,1) = 0
    AND CHARINDEX('i5',Processor,1) = 0
    AND CHARINDEX('r3',Processor,1) = 0
    AND CHARINDEX('Ryzen',Processor,1) = 0

UPDATE laptops
SET Processor = (CASE 
    WHEN CHARINDEX('Ryzen', title, 1) > 0
        THEN SUBSTRING(title, CHARINDEX('Ryzen', title, 1), (CHARINDEX(' - ', title))-(CHARINDEX('Ryzen', title)))
    ELSE SUBSTRING(title, CHARINDEX('Core', title, 1), (CHARINDEX(' - ', title))-(CHARINDEX('Core', title)))
    END)
WHERE CHARINDEX('Intel',Processor,1) = 0
    AND CHARINDEX('AMD',Processor,1) = 0
    AND CHARINDEX('Qualcomm',Processor,1) = 0
    AND CHARINDEX('Apple',Processor,1) = 0
    AND CHARINDEX('i3',Processor,1) = 0
    AND CHARINDEX('i5',Processor,1) = 0
    AND CHARINDEX('r3',Processor,1) = 0
    AND CHARINDEX('Ryzen',Processor,1) = 0

SELECT title, Processor, SUBSTRING(Processor, CHARINDEX('(', Processor), LEN(Processor)) as FixedProcessor
FROM laptops
WHERE CHARINDEX('Intel',Processor,1) > 0
    OR CHARINDEX('AMD',Processor,1) > 0
    OR CHARINDEX('Qualcomm',Processor,1) > 0
    OR CHARINDEX('Apple',Processor,1) > 0
    OR CHARINDEX('i3',Processor,1) > 0
    OR CHARINDEX('i5',Processor,1) > 0
    OR CHARINDEX('r3',Processor,1) > 0
    OR CHARINDEX('Ryzen',Processor,1) > 0

UPDATE laptops
SET Processor = SUBSTRING(Processor, CHARINDEX('Intel', Processor,1), LEN(Processor))
WHERE CHARINDEX('Intel', Processor, 1) > 1

SELECT *
FROM laptops
WHERE warranty = 'Intel Core i3 Processor (11th Gen)'
    OR RAM = 'Intel Core i7 Processor (12th Gen)'

UPDATE laptops
SET Processor = warranty
WHERE warranty = 'Intel Core i3 Processor (11th Gen)'

UPDATE laptops
SET Processor = RAM
WHERE RAM = 'Intel Core i7 Processor (12th Gen)'


-- CLEAN RAM --

UPDATE laptops
SET RAM = OS
WHERE  NOT SUBSTRING(RAM, 1, LEN(RAM)) LIKE '%RAM%'
    AND SUBSTRING(os,1,LEN(os)) LIKE '%RAM%'

UPDATE laptops
SET RAM = Display
WHERE NOT SUBSTRING(RAM, 1, LEN(RAM)) LIKE '%RAM%'
    AND SUBSTRING(Display,1,LEN(Display)) LIKE '%RAM%'

UPDATE laptops
SET RAM = warranty
WHERE NOT SUBSTRING(RAM, 1, LEN(RAM)) LIKE '%RAM%'
    AND SUBSTRING(warranty,1,LEN(warranty)) LIKE '%RAM%'

UPDATE laptops
SET Display = RAM
WHERE NOT SUBSTRING(RAM, 1, LEN(RAM)) LIKE '%RAM%'
    AND SUBSTRING(RAM,1,LEN(RAM)) LIKE '%inches%'

UPDATE laptops
SET RAM = SUBSTRING(title, CHARINDEX('GB', title, 1) -3, (CHARINDEX('/', title)+3)-CHARINDEX('GB/', title))
WHERE NOT SUBSTRING(RAM, 1, LEN(RAM)) LIKE '%RAM%'
    AND NOT SUBSTRING(RAM, 1, LEN(RAM)) LIKE '%GB%'

SELECT TRIM(STUFF(RAM, 1, CHARINDEX('(', RAM,1), ''))
FROM laptops

UPDATE laptops
SET RAM = TRIM(STUFF(RAM, 1, CHARINDEX('(', RAM,1), ''))

UPDATE laptops
SET RAM = SUBSTRING(RAM, CHARINDEX(': ', RAM, 1) +2, LEN(RAM))
WHERE SUBSTRING(RAM,1,LEN(RAM)) LIKE '%Storage: %'

UPDATE laptops
SET RAM = SUBSTRING(RAM, 1, CHARINDEX('&',RAM)-2)
WHERE SUBSTRING(RAM,1,LEN(RAM)) LIKE '%4 &%'

UPDATE laptops
SET RAM = SUBSTRING(title, CHARINDEX('(',title,1) +1, CHARINDEX('/',title)-CHARINDEX('(',title,1)-1)
WHERE SUBSTRING(RAM, 1, LEN(RAM)) LIKE '%DIMM%'

UPDATE laptops
SET RAM = SUBSTRING(RAM, CHARINDEX(': ', RAM, 1) +2, LEN(RAM))
WHERE SUBSTRING(RAM,1,LEN(RAM)) LIKE '%Storage: %'

UPDATE laptops
SET RAM = SUBSTRING(RAM, CHARINDEX(':', RAM, 1) +1, CHARINDEX(',', RAM)-CHARINDEX(':', RAM) -1)
WHERE SUBSTRING(RAM,1,LEN(RAM)) LIKE '%Memory &%'


-- Clean OS --
SELECT OS
FROM laptops
WHERE SUBSTRING(OS, 1, LEN(OS)) LIKE '%Win%'
    OR SUBSTRING(OS, 1, LEN(OS)) LIKE '%Mac%'
    OR SUBSTRING(OS, 1, LEN(OS)) LIKE '%Chrome%'

SELECT title, OS, 'Windows' as NewOS
FROM laptops
WHERE NOT SUBSTRING(OS, 1, LEN(OS)) LIKE '%Windows%'
    AND NOT SUBSTRING(OS, 1, LEN(OS)) LIKE '%Mac%'
    AND NOT SUBSTRING(OS, 1, LEN(OS)) LIKE '%Chrome%'

--Create new column to simplify the OS information
ALTER TABLE laptops
ADD newOS NVARCHAR(255)

UPDATE laptops
SET newOS = 'Windows'
WHERE SUBSTRING(OS, 1, LEN(OS)) LIKE '%Windows%'

UPDATE laptops
SET newOS = 'Windows'
WHERE SUBSTRING(OS, 1, LEN(OS)) LIKE '%Win%'

UPDATE laptops
SET newOS = 'Mac'
WHERE SUBSTRING(OS, 1, LEN(OS)) LIKE '%Mac%'

SELECT OS
FROM laptops
WHERE SUBSTRING(OS, 1, LEN(OS)) LIKE '%Chrome%'

UPDATE laptops
SET newOS = 'Chrome'
WHERE SUBSTRING(OS, 1, LEN(OS)) LIKE '%Chrome%'

UPDATE laptops
SET newOS = 'DOS'
WHERE newOS IS NULL
    AND SUBSTRING(OS, 1, LEN(OS)) LIKE '%DOS%'

UPDATE laptops
SET newOS = 'Windows'
WHERE newOS IS NULL
    AND SUBSTRING(title, 1, LEN(title)) LIKE '%Windows%'

-- Clean SSD, add HDD column --
ALTER TABLE laptops
ADD HDD NVARCHAR(255)

ALTER TABLE laptops
ADD newSSD NVARCHAR(255)

UPDATE laptops
SET newSSD = SUBSTRING(title, (CHARINDEX('HDD/', title))+4, (CHARINDEX('SSD', title))-(CHARINDEX('/', title))-7)
WHERE NOT SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%SSD%'
    AND NOT SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%HDD%'
    AND SUBSTRING(title, 1, LEN(title)) LIKE '%SSD%'
    AND SUBSTRING(title, 1, LEN(title)) LIKE '%HDD%'

UPDATE laptops
SET newSSD = SUBSTRING(title, CHARINDEX('/', title)+1, CHARINDEX('SSD', title)-CHARINDEX('/', title)-1)
WHERE NOT SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%SSD%'
    AND NOT SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%HDD%'
    AND SUBSTRING(title, 1, LEN(title)) LIKE '%SSD%'
    AND newSSD is null

UPDATE laptops
SET newSSD = SSD
WHERE newSSD is null
    AND NOT SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%HDD%'
    AND SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%SSD%'

UPDATE laptops
SET newSSD = SUBSTRING(SSD, CHARINDEX('|', SSD)+1, CHARINDEX('SSD', SSD)-CHARINDEX('|', SSD)-1)
WHERE newSSD is null
    AND SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%HDD%'
    AND SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%SSD%'

UPDATE laptops
SET HDD = SUBSTRING(SSD, 1, CHARINDEX('|', SSD)-1)
WHERE HDD is null
    AND SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%HDD%'
    AND SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%SSD%'

UPDATE laptops
SET HDD = SSD
WHERE HDD is null
    AND SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%HDD%'
    AND NOT SUBSTRING(SSD, 1, LEN(SSD)) LIKE '%SSD%'

UPDATE laptops
SET HDD = SUBSTRING(title, CHARINDEX('/', title) +1, CHARINDEX('HDD', title)-CHARINDEX('/', title) -1)
WHERE HDD is null
    AND SUBSTRING(title, 1, LEN(title)) LIKE '%HDD%'

SELECT title, newSSD, HDD
FROM laptops
WHERE HDD is null
ORDER BY 2

-- Create eMMC column --
ALTER TABLE laptops
ADD EMMC nvarchar(50)

SELECT title, newSSD, HDD, EMMC, SUBSTRING(title, CHARINDEX('/', title)+1, CHARINDEX('EMMC', title)-CHARINDEX('/', title)-1)
FROM laptops
WHERE SUBSTRING(title, 1, LEN(title)) LIKE '%EMMC%'

UPDATE laptops
SET EMMC = SUBSTRING(title, CHARINDEX('/', title)+1, CHARINDEX('EMMC', title)-CHARINDEX('/', title)-1)
WHERE SUBSTRING(title, 1, LEN(title)) LIKE '%EMMC%'

-- Create brand column --
ALTER TABLE laptops
ADD brand NVARCHAR(50)

UPDATE laptops
SET brand = SUBSTRING(title, 1, CHARINDEX(' ', title, 1))

-- Clean display --
ALTER TABLE laptops
ADD newDisplay NVARCHAR(255)

UPDATE laptops
SET newDisplay = SUBSTRING(display, CHARINDEX('(', display)+1, CHARINDEX(')', display) - CHARINDEX('(', display)-1)
WHERE SUBSTRING(display, 1, len(display)) LIKE '%inch%'
    AND SUBSTRING(display, 1, len(display)) LIKE '%cm%'

UPDATE laptops
SET newDisplay = SUBSTRING(SSD, CHARINDEX('(', SSD)+1, CHARINDEX(')', SSD) - CHARINDEX('(', SSD)-1)
WHERE NOT SUBSTRING(display, 1, len(display)) LIKE '%inch%'
    AND SUBSTRING(SSD, 1, len(SSD)) LIKE '%inch%'

UPDATE laptops
SET newDisplay = SUBSTRING(SSD, CHARINDEX(' ', SSD), CHARINDEX('"', SSD) - CHARINDEX(': ', SSD))
WHERE newDisplay is null
    AND NOT SUBSTRING(display, 1, len(display)) LIKE '%inch%'
    AND SUBSTRING(SSD, 1, len(SSD)) LIKE '%"%'
    AND SUBSTRING(SSD, 1, len(SSD)) LIKE '%Display%'

UPDATE laptops
SET newDisplay = SUBSTRING(display, 1, CHARINDEX('es ', display)-1)
WHERE newDisplay is null
    AND SUBSTRING(display, 1, len(display)) LIKE '%inch%'

UPDATE laptops
SET newDisplay = SUBSTRING(warranty, CHARINDEX('(', warranty)+1, CHARINDEX(')', warranty) - CHARINDEX('(', warranty)-3)
WHERE newDisplay is null
    AND SUBSTRING(warranty, 1, len(warranty)) LIKE '%inches%'

UPDATE laptops
SET newDisplay = SUBSTRING(warranty, CHARINDEX('(', warranty)+1, CHARINDEX(')', warranty) - CHARINDEX('(', warranty)-1)
WHERE newDisplay is null
    AND SUBSTRING(warranty, 1, len(warranty)) LIKE '%inch%'

UPDATE laptops
SET newDisplay = TRIM(SUBSTRING(OS, CHARINDEX(':', OS)+1, CHARINDEX('"', OS) - CHARINDEX(':', OS)))
WHERE newDisplay is null
    AND SUBSTRING(OS, 1, len(OS)) LIKE '%display%'
    AND SUBSTRING(OS, 1, len(OS)) LIKE '%"%'

UPDATE laptops
SET newDisplay = SUBSTRING(in_build_sw, CHARINDEX('(', in_build_sw)+1, CHARINDEX(')', in_build_sw) - CHARINDEX('(', in_build_sw)-1)
WHERE newDisplay is null
    AND SUBSTRING(in_build_sw, 1, len(in_build_sw)) LIKE '%inch%'

UPDATE laptops
SET newDisplay = SUBSTRING(display, CHARINDEX('(', display)+1, CHARINDEX(')', display) - CHARINDEX('(', display)-1)
WHERE newDisplay is null
    AND SUBSTRING(display, 1, len(display)) LIKE '%display%'

UPDATE laptops
SET newDisplay = SUBSTRING(OS, CHARINDEX(':', OS)+1, CHARINDEX('inch', OS) - CHARINDEX(':', OS)+3)
WHERE newDisplay is null
    AND SUBSTRING(OS, 1, len(OS)) LIKE '%display%'

UPDATE laptops
SET newDisplay = SUBSTRING(SSD, 1, 5)
WHERE newDisplay is null
    AND SUBSTRING(SSD, 1, len(SSD)) LIKE '%"%'

-- Tie up loose ends --
UPDATE laptops
SET newSSD = newSSD + 'SSD'
WHERE NOT SUBSTRING(newSSD, 1, len(newSSD)) LIKE '%SSD%'

UPDATE laptops
SET newSSD = SUBSTRING(newSSD, CHARINDEX('512', newSSD), CHARINDEX('GB', newSSD) - CHARINDEX('512', newSSD)+2)
WHERE SUBSTRING(newSSD, 1, len(newSSD)) LIKE '%upto%'

UPDATE laptops
SET newSSD = SUBSTRING(newSSD, 1, CHARINDEX('SSD', newSSD)+2)
WHERE SUBSTRING(newSSD, 1, len(newSSD)) LIKE '%reduce%'

UPDATE laptops
SET newSSD = newSSD + ' SSD'
WHERE NOT SUBSTRING(newSSD, 1, len(newSSD)) LIKE '%SSD%'

UPDATE laptops
SET newDisplay = LTRIM(newDisplay)

UPDATE laptops
SET newDisplay = REPLACE(newDisplay, '"', ' inch')
WHERE NOT SUBSTRING(newDisplay, 1, len(newDisplay)) LIKE '%in%'

UPDATE laptops
SET newDisplay = REPLACE(newDisplay, 'mm', ' inch')
WHERE NOT SUBSTRING(newDisplay, 1, len(newDisplay)) LIKE '%in%'

UPDATE laptops
SET newDisplay = REPLACE(newDisplay, 'cm', ' inch')
WHERE NOT SUBSTRING(newDisplay, 1, len(newDisplay)) LIKE '%in%'

UPDATE laptops
SET HDD = HDD + 'HDD'
WHERE NOT SUBSTRING(HDD, 1, len(HDD)) LIKE '%HDD%'

--Create processorBrand--
ALTER TABLE laptops
ADD processorBrand nvarchar(50)

UPDATE laptops
SET processorBrand = 'Intel'
WHERE SUBSTRING(processor, 1, len(processor)) LIKE '%Intel%'
    OR SUBSTRING(processor, 1, len(processor)) LIKE '%i3%'
    OR SUBSTRING(processor, 1, len(processor)) LIKE '%i5%'
    OR SUBSTRING(processor, 1, len(processor)) LIKE '%i7%'
    OR SUBSTRING(processor, 1, len(processor)) LIKE '%i9%'

UPDATE laptops
SET processorBrand = 'AMD'
WHERE SUBSTRING(processor, 1, len(processor)) LIKE '%Ryzen%'
    OR SUBSTRING(processor, 1, len(processor)) LIKE '%AMD%'
    OR SUBSTRING(processor, 1, len(processor)) LIKE '%r3%'
    OR SUBSTRING(processor, 1, len(processor)) LIKE '%r5%'
    OR SUBSTRING(processor, 1, len(processor)) LIKE '%r7%'

UPDATE laptops
SET processorBrand = 'Apple'
WHERE SUBSTRING(processor, 1, len(processor)) LIKE '%apple%'

UPDATE laptops
SET processorBrand = 'Qualcomm'
WHERE SUBSTRING(processor, 1, len(processor)) LIKE '%qual%'