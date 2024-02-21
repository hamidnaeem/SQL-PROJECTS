


-- First i created a data base
CREATE DATABASE club_memeber ;

USE club_memeber;

SELECT * FROM club_member_info;

-- 1) TASKS to do:
	-- We have seven columns and we will clean all columns one by one. As every column has some problem.
    -- i am starting with Creating a primary key as we do not have any primary key here in this table.

-- 2) Creating a Primary key:  
   
ALTER TABLE club_member_info
ADD COLUMN member_id INT 

ALTER TABLE club_member_info
MODIFY COLUMN member_id INT AUTO_INCREMENT PRIMARY KEY;

-- 3) full_name: this column has problems like special characters like ?, and irregular spaces so we have to clean it

SELECT full_name FROM club_member_info;

SELECT
  CASE
    WHEN TRIM(full_name) = '' THEN NULL
    ELSE
      TRIM(REGEXP_REPLACE(TRIM(LOWER(full_name)), '[^a-zA-Z ]', ''))
  END AS cleaned_full_name, full_name
FROM club_member_info
LIMIT 0, 50000;


-- 4) AGE COLUMN: our next column is "Age". In age we have 3 digit figers for example 311 instead of 31 that need correction, we have to remove the last digit. Some where the field is empty we have to replace it with "Null". 

SELECT age FROM club_member_info;

SELECT
  CASE
    WHEN LENGTH(CAST(age AS CHAR)) = 0 THEN NULL
    WHEN LENGTH(CAST(age AS CHAR)) = 3 THEN CAST(SUBSTRING(CAST(age AS CHAR), 1, 2) AS SIGNED)
    ELSE age
  END AS age
FROM club_member_info;


-- 5) martial_status: We need to convert all fields into small letters plus we need to replace "Null" from Empty cells.

SELECT martial_status FROM club_member_info;

SELECT 
CASE
			WHEN trim(martial_status) = '' THEN NULL
			ELSE trim(martial_status)
		END AS martial_status
        
        From club_member_info;
        
-- 6) Email: we need to convert all email address into lowercase.             

SELECT email FROM club_member_info;

SELECT trim(lower(email)) AS member_email from club_member_info;

-- 7) Phone: In this column we need to conver empty to "NULL, if phone number is lesser than 12 then also null, and we need to trim rest of the numbers to remove its spaces and all.

SELECT phone from club_member_info;

Select
		CASE
			WHEN trim(phone) = '' THEN NULL
			WHEN length(trim(phone)) < 12 THEN NULL
			ELSE trim(phone)
		END AS phone
       FROM club_member_info; 
       
       
-- 8) full_address: i have seperated street, city and state in three different columns so that we can use city and state for further analysis.

SELECT full_address from club_member_info;

SELECT 
  TRIM(LOWER(SUBSTRING_INDEX(full_address, ',', 1))) AS street_address,
  TRIM(LOWER(SUBSTRING_INDEX(SUBSTRING_INDEX(full_address, ',', 2), ',', -1))) AS city,
  TRIM(LOWER(SUBSTRING_INDEX(full_address, ',', -1))) AS state
FROM club_member_info
LIMIT 0, 50000;

-- 9) JOB _title: Some job titles define a level in roman numerals (I, II, III, IV). So there for it needs to be Converted to numbers and add descriptor (ex. Level 3). Trim whitespace from job title, rename to occupation and if empty convert to null type.

SELECT job_title FROM club_member_info;

SELECT
  CASE
    WHEN TRIM(LOWER(job_title)) = '' THEN NULL
    ELSE
      CASE
        WHEN CHAR_LENGTH(TRIM(job_title)) - CHAR_LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 AND 
             LOWER(SUBSTRING_INDEX(job_title, ' ', -1)) = 'i'
          THEN REPLACE(job_title, ' i', ', level 1')
        WHEN CHAR_LENGTH(TRIM(job_title)) - CHAR_LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 AND 
             LOWER(SUBSTRING_INDEX(job_title, ' ', -1)) = 'ii'
          THEN REPLACE(job_title, ' ii', ', level 2')
        WHEN CHAR_LENGTH(TRIM(job_title)) - CHAR_LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 AND 
             LOWER(SUBSTRING_INDEX(job_title, ' ', -1)) = 'iii'
          THEN REPLACE(job_title, ' iii', ', level 3')
        WHEN CHAR_LENGTH(TRIM(job_title)) - CHAR_LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 AND 
             LOWER(SUBSTRING_INDEX(job_title, ' ', -1)) = 'iv'
          THEN REPLACE(job_title, ' iv', ', level 4')
        ELSE TRIM(LOWER(job_title))
      END
  END AS occupation
FROM club_member_info;



-- 10) membership_date: some dates are from last century it needs to be fixed to present century.

SELECT membership_date FROM club_member_info;

SELECT 
  CASE 
    WHEN YEAR(membership_date) < 2000 
      THEN STR_TO_DATE(
        CONCAT(
          REPLACE(YEAR(membership_date), '19', '20'),
          '-',
          LPAD(EXTRACT(MONTH FROM membership_date), 2, '0'),
          '-',
          LPAD(EXTRACT(DAY FROM membership_date), 2, '0')
        ),
        '%Y-%m-%d'
      )
    ELSE membership_date
  END AS membership_date
FROM club_member_info;



-- FINALLY we are combining all our columns under select statement and creating a new table that holds clean values.


CREATE TABLE cleaned_data_set1 AS 
         SELECT
                -- First Column which is member_id
                member_id,
                
                -- 2nd column which is full_name and now we have named it as cleaned_full_name
                CASE
                      WHEN TRIM(full_name) = '' THEN NULL
                      ELSE
                      TRIM(REGEXP_REPLACE(TRIM(LOWER(full_name)), '[^a-zA-Z ]', ''))
					  END AS cleaned_full_name,
               
                -- 3rd column which is age
                CASE
                      WHEN LENGTH(CAST(age AS CHAR)) = 0 THEN NULL
                      WHEN LENGTH(CAST(age AS CHAR)) = 3 THEN CAST(SUBSTRING(CAST(age AS CHAR), 1, 2) AS SIGNED)
                      ELSE age
                      END AS age,
                      
               -- 4th Column which is martial_status       
	           CASE
			         WHEN trim(martial_status) = '' THEN NULL
			         ELSE trim(martial_status)
		             END AS martial_status,
               
               -- 5th Column which is email and now we have named at member_email
			   trim(lower(email)) AS member_email,
               
               -- 6th column is phone
               CASE
			         WHEN trim(phone) = '' THEN NULL
			         WHEN length(trim(phone)) < 12 THEN NULL
					 ELSE trim(phone)
		             END AS phone,
                     
               -- 7th column is full_adress, that we have divided further into street_adress, city and state.       
               TRIM(LOWER(SUBSTRING_INDEX(full_address, ',', 1))) AS street_address,
               TRIM(LOWER(SUBSTRING_INDEX(SUBSTRING_INDEX(full_address, ',', 2), ',', -1))) AS city,
			   TRIM(LOWER(SUBSTRING_INDEX(full_address, ',', -1))) AS state,
               
               -- 8th column is job 
		      CASE
                    WHEN TRIM(LOWER(job_title)) = '' THEN NULL
                    ELSE
                    CASE
                    WHEN CHAR_LENGTH(TRIM(job_title)) - CHAR_LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 AND 
                    LOWER(SUBSTRING_INDEX(job_title, ' ', -1)) = 'i'
                    THEN REPLACE(job_title, ' i', ', level 1')
                    WHEN CHAR_LENGTH(TRIM(job_title)) - CHAR_LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 AND 
                    LOWER(SUBSTRING_INDEX(job_title, ' ', -1)) = 'ii'
                    THEN REPLACE(job_title, ' ii', ', level 2')
                    WHEN CHAR_LENGTH(TRIM(job_title)) - CHAR_LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 AND 
                    LOWER(SUBSTRING_INDEX(job_title, ' ', -1)) = 'iii'
					THEN REPLACE(job_title, ' iii', ', level 3')
                    WHEN CHAR_LENGTH(TRIM(job_title)) - CHAR_LENGTH(REPLACE(TRIM(job_title), ' ', '')) > 0 AND 
                    LOWER(SUBSTRING_INDEX(job_title, ' ', -1)) = 'iv'
                    THEN REPLACE(job_title, ' iv', ', level 4')
                    ELSE TRIM(LOWER(job_title))
                    END
                    END AS occupation,
					
                    -- 9th column is membership_date 
                    
                    STR_TO_DATE(
                    membership_date,
                    '%m/%d/%Y'
                   ) AS updated_membership_date
		            
FROM club_member_info;
                

SELECT * FROM cleaned_data_set1;
	
    
    
  