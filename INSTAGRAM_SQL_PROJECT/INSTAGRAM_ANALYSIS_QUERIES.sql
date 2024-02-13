
--1) CREATING A TABLE "comments_insta"
CREATE TABLE comments_insta(
    id SERIAL PRIMARY KEY, 
	comment_text VARCHAR(255) NOT NULL,
    user_id	INT NOT NULL,
	photo_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
) 

--2) ALTERING THE TABLE:
ALTER TABLE comments_insta DROP COLUMN id;
ALTER TABLE comments_insta ADD COLUMN id INTEGER;

--3) CREATING A TABLE "follows": 

CREATE TABLE follows(

    follower_id INT NOT NULL,
	Followee_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

--4) CREATING A TABLE "LIKES"

CREATE TABLE likes(
    user_id INT NOT NULL,
	photo_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);


--5) CREATING A TABLE "photos"

CREATE TABLE photos(
    id INT NOT NULL,
	image_url VARCHAR(355) NOT NULL,
	user_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

--6) CREATING A TABLE "tags"

CREATE TABLE tags(
    id INT NOT NULL,
	tag_name VARCHAR(255) UNIQUE NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

7) CREATING A TABLE "users"

CREATE TABLE users(
    id INT NOT NULL,
	username VARCHAR(255) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

8) CREATING A JUNCTION TABLE TABLE "photo_tags"

CREATE TABLE photo_tags(
	photo_id INT NOT NULL,
	tag_id INT NOT NULL
);

--ANALYSIS PART:
-- 1) 5 OLdest users

select * from users;
select * from photos;

SELECT username, created_at
from users
order by created_at DESC
limit 5;

--2) what day of the week most user register on: 

SELECT EXTRACT(DOW FROM created_at) AS day_of_week,
COUNT(*) AS user_count
FROM users
GROUP BY day_of_week
ORDER BY user_count DESC
;

--3) We want to target our inactive users with an email campaign.
-- Find the users who have never posted a photo

SELECT username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;

select * from likes;
select * from photos;


--4) We're running a new contest to see who can get the most likes on a single photo.

SELECT users.username,photos.id,photos.image_url,COUNT(*) AS Total_Likes
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = likes.user_id
GROUP BY users.username,photos.id,photos.image_url
ORDER BY Total_Likes DESC
LIMIT 1;

-- 5) How many times does the average user post?
-- total number of photos/total number of users

SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2);

--6) total numbers of users who have posted at least one time.

SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
JOIN photos ON users.id = photos.user_id;

--7) A brand wants to know which hashtags to use in a post
--What are the top 5 most commonly used hashtags?

SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id,tag_name
ORDER BY total DESC;

--8) Find users who have never commented on a photo*/

SELECT username,comment_text
FROM users
LEFT JOIN comments_insta ON users.id = comments_insta.user_id
GROUP BY users.id,username,comment_text
HAVING comment_text IS NULL;

--9) Find users who have liked every single photo on the site*/

SELECT users.id,username, COUNT(users.id) As total_likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos);

--10) What are the top 5 most commonly used hashtags?*/

SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id,tag_name
ORDER BY total DESC;


