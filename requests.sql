--1.Блок будущие релизы.

--Фильмы, которые не вышли в прокат. От ближайшего до неанонсированных. Для отсутствующих дат вывести 'TBA'.
WITH movie_released AS (
	SELECT * 
		FROM movie m 
		WHERE m."releaseDate" > NOW() OR m."releaseDate" IS NULL
		ORDER BY m."releaseDate" ASC
	)

SELECT mr.title AS name_film, COALESCE (CAST(mr."releaseDate" AS VARCHAR(10)), 'TBA') AS release_date		
	FROM movie_released AS mr
	

--Актеры, исполняющие роли в будущих картинах. Со статистикой по количеству ролей и суммарному гонорару.
SELECT a."fullName" AS name_actor , COUNT (r."name") AS count_role, SUM(COALESCE (r.fee, 0)) AS sum_fee 
	FROM actor a 
		JOIN "role" r ON r."actorId" = a.id   
		JOIN movie m ON m.id = r."movieId"
	WHERE m."releaseDate" > NOW()	
	GROUP BY a."fullName"
		
	
--Предусмотреть возможность детализации списка ролей и актеров для интересующего фильма.
SELECT m.title AS title_movie, r."name" AS name_role, a."fullName" AS name_actor 
	FROM movie m 
		JOIN "role" r ON r."movieId"  = m.id 
		JOIN actor a ON a.id = r."actorId"
	WHERE m."releaseDate" > NOW()


--2. Вышедшие в прокат

--Картины от свежего релиза к более ранним.
SELECT m.title, m."releaseDate"  
	FROM movie m 
		WHERE m."releaseDate" < NOW()
		ORDER BY m."releaseDate" DESC
 

--Рейтинг по кассовым сборам.
SELECT m.title, m.gross 
	FROM movie m 
	ORDER BY -m.gross
	
	
--Актеры и их роли в выбранном фильме.
SELECT m.title AS title_movie, r."name" AS name_role, a."fullName" AS name_actor 
	FROM movie m 
		JOIN "role" r ON r."movieId"  = m.id 
		JOIN actor a ON a.id = r."actorId"
	WHERE m."releaseDate" < NOW()


--3. Статистика по актерам с общей суммой гонораров за все время и количеством ролей.

SELECT DISTINCT a."fullName" AS name_actor, COUNT(r."name") AS count_role , SUM(COALESCE (r.fee, 0)) AS sum_fee 
	FROM actor a 
		JOIN "role" r ON r."actorId" = a.id 
	GROUP BY a."fullName" 