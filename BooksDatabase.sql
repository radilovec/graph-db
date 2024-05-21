USE master;
GO

DROP DATABASE IF EXISTS BooksDatabase;
GO

CREATE DATABASE BooksDatabase;
GO

USE BooksDatabase;
GO

-- Òàáëèöû óçëîâ
CREATE TABLE Author
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Publisher
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Book
(
    id INT NOT NULL PRIMARY KEY,
    title NVARCHAR(100) NOT NULL,
    author_id INT NOT NULL,
    publisher_id INT NOT NULL
) AS NODE;

-- Òàáëèöû ð¸áåð
CREATE TABLE FamiliarWith AS EDGE;

CREATE TABLE WrittenBy AS EDGE;

CREATE TABLE PublishedBy AS EDGE;

-- Äîáàâèì îãðàíè÷åíèÿ
ALTER TABLE FamiliarWith
ADD CONSTRAINT EC_FamiliarWith CONNECTION (Author TO Author);

ALTER TABLE WrittenBy
ADD CONSTRAINT EC_WrittenBy CONNECTION (Author TO Book);

ALTER TABLE PublishedBy
ADD CONSTRAINT EC_PublishedBy CONNECTION (Book TO Publisher);
GO

-- Çàïîëíåíèå òàáëèö óçëîâ
INSERT INTO Author (id, name)
VALUES (1, N'Òîëñòîé'),
       (2, N'Äîñòîåâñêèé'),
       (3, N'Ïóøêèí'),
       (4, N'Ãîãîëü'),
       (5, N'×åõîâ'),
       (6, N'Òóðãåíåâ'),
       (7, N'Ãåòå'),
       (8, N'Øåêñïèð'),
       (9, N'Ìàÿêîâñêèé'),
       (10, N'Ãþãî');

INSERT INTO Publisher (id, name)
VALUES (1, N'Ýêñìî'),
       (2, N'ÀÑÒ'),
       (3, N'ACT'),
       (4, N'Ðèïîë'),
       (5, N'Ïðîñâåùåíèå'),
       (6, N'Ïèòåð'),
       (7, N'Âèëüÿìñ'),
       (8, N'Ïàëåÿ'),
       (9, N'Àìôîðà'),
       (10, N'Ìîëîäàÿ ãâàðäèÿ');

INSERT INTO Book (id, title, author_id, publisher_id)
VALUES (1, N'Âîéíà è ìèð', 1, 1),
       (2, N'Ïðåñòóïëåíèå è íàêàçàíèå', 2, 2),
       (3, N'Åâãåíèé Îíåãèí', 3, 3),
       (4, N'Ìåðòâûå äóøè', 4, 4),
       (5, N'Äàìà ñ ñîáà÷êîé', 5, 5),
       (6, N'Îòöû è äåòè', 6, 6),
       (7, N'Ôàóñò', 7, 7),
       (8, N'Ãàìëåò', 8, 8),
       (9, N'Îáëîìîâ', 6, 9),
       (10, N'Îòåëëî', 8, 10);

-- Çàïîëíåíèå òàáëèö ð¸áåð
INSERT INTO FamiliarWith ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Author WHERE id = 1),
        (SELECT $node_id FROM Author WHERE id = 2)),
       ((SELECT $node_id FROM Author WHERE id = 1),
        (SELECT $node_id FROM Author WHERE id = 3)),
       ((SELECT $node_id FROM Author WHERE id = 2),
        (SELECT $node_id FROM Author WHERE id = 3)),
       ((SELECT $node_id FROM Author WHERE id = 3),
        (SELECT $node_id FROM Author WHERE id = 4)),
       ((SELECT $node_id FROM Author WHERE id = 5),
        (SELECT $node_id FROM Author WHERE id = 6)),
       ((SELECT $node_id FROM Author WHERE id = 6),
        (SELECT $node_id FROM Author WHERE id = 9)),
       ((SELECT $node_id FROM Author WHERE id = 7),
        (SELECT $node_id FROM Author WHERE id = 8)),
       ((SELECT $node_id FROM Author WHERE id = 8),
        (SELECT $node_id FROM Author WHERE id = 10)),
       ((SELECT $node_id FROM Author WHERE id = 4),
        (SELECT $node_id FROM Author WHERE id = 5)),
       ((SELECT $node_id FROM Author WHERE id = 3),
        (SELECT $node_id FROM Author WHERE id = 5));

INSERT INTO WrittenBy ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Author WHERE id = 1), (SELECT $node_id FROM Book WHERE id = 1)),
       ((SELECT $node_id FROM Author WHERE id = 2), (SELECT $node_id FROM Book WHERE id = 2)),
       ((SELECT $node_id FROM Author WHERE id = 3), (SELECT $node_id FROM Book WHERE id = 3)),
       ((SELECT $node_id FROM Author WHERE id = 4), (SELECT $node_id FROM Book WHERE id = 4)),
       ((SELECT $node_id FROM Author WHERE id = 5), (SELECT $node_id FROM Book WHERE id = 5)),
       ((SELECT $node_id FROM Author WHERE id = 6), (SELECT $node_id FROM Book WHERE id = 6)),
       ((SELECT $node_id FROM Author WHERE id = 7), (SELECT $node_id FROM Book WHERE id = 7)),
       ((SELECT $node_id FROM Author WHERE id = 8), (SELECT $node_id FROM Book WHERE id = 8)),
       ((SELECT $node_id FROM Author WHERE id = 9), (SELECT $node_id FROM Book WHERE id = 9)),
       ((SELECT $node_id FROM Author WHERE id = 8), (SELECT $node_id FROM Book WHERE id = 10));

INSERT INTO PublishedBy ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Book WHERE id = 1), (SELECT $node_id FROM Publisher WHERE id = 1)),
       ((SELECT $node_id FROM Book WHERE id = 2), (SELECT $node_id FROM Publisher WHERE id = 2)),
       ((SELECT $node_id FROM Book WHERE id = 3), (SELECT $node_id FROM Publisher WHERE id = 3)),
       ((SELECT $node_id FROM Book WHERE id = 4), (SELECT $node_id FROM Publisher WHERE id = 4)),
       ((SELECT $node_id FROM Book WHERE id = 5), (SELECT $node_id FROM Publisher WHERE id = 5)),
       ((SELECT $node_id FROM Book WHERE id = 6), (SELECT $node_id FROM Publisher WHERE id = 6)),
       ((SELECT $node_id FROM Book WHERE id = 7), (SELECT $node_id FROM Publisher WHERE id = 7)),
       ((SELECT $node_id FROM Book WHERE id = 8), (SELECT $node_id FROM Publisher WHERE id = 8)),
       ((SELECT $node_id FROM Book WHERE id = 9), (SELECT $node_id FROM Publisher WHERE id = 9)),
	   ((SELECT $node_id FROM Book WHERE id = 10), (SELECT $node_id FROM Publisher WHERE id = 10));


-- Çàïðîñû ñ èñïîëüçîâàíèåì MATCH

-- 1. Íàéòè èçäàòåëüñòâî, êîòîðîå èçäàëî êíèãó îïðåäåë¸ííîãî àâòîðà (íàïðèìåð, "Òîëñòîé")
SELECT Publisher.name AS PublisherName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Author.name = N'Òîëñòîé';

-- 2. Íàéòè àâòîðîâ, êîòîðûå çíàêîìû ñ îïðåäåë¸ííûì àâòîðîì (íàïðèìåð, "Òîëñòîé")
SELECT Author2.name AS AuthorName
FROM Author AS Author1
, FamiliarWith
, Author AS Author2
WHERE MATCH(Author1-(FamiliarWith)->Author2)
AND Author1.name = N'Òîëñòîé';

-- 3. Íàéòè êíèãó, êîòîðóþ íàïèñàë îïðåäåë¸ííûé àâòîð (íàïðèìåð, "Äîñòîåâñêèé")
SELECT Book.title AS BookTitle
FROM Author
, WrittenBy
, Book
WHERE MATCH(Author-(WrittenBy)->Book)
AND Author.name = N'Äîñòîåâñêèé';

-- 4. Íàéòè èçäàòåëüñòâà, êîòîðûå èçäàëè êíèãè, íàïèñàííûå àâòîðîì îïðåäåë¸ííîãî æàíðà (íàïðèìåð, êëàññèêà)
SELECT DISTINCT Publisher.name AS PublisherName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Book.title IN ('Âîéíà è ìèð', 'Ïðåñòóïëåíèå è íàêàçàíèå', 'Åâãåíèé Îíåãèí', 'Ìåðòâûå äóøè', 'Äàìà ñ ñîáà÷êîé', 'Îòöû è äåòè', 'Ôàóñò', 'Ãàìëåò', 'Îáëîìîâ', 'Îòåëëî')
AND Author.name IN ('Òîëñòîé', 'Äîñòîåâñêèé', 'Ïóøêèí', 'Ãîãîëü', '×åõîâ', 'Òóðãåíåâ', 'Ãåòå', 'Øåêñïèð', 'Ìàÿêîâñêèé', 'Ãþãî');

-- 5. Íàéòè àâòîðîâ, êîòîðûå íàïèñàëè êíèãè äëÿ îïðåäåë¸ííîãî èçäàòåëüñòâà (íàïðèìåð, Ýêñìî)
SELECT DISTINCT Author.name AS AuthorName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Publisher.name = N'Ýêñìî';


--1. Найти всех авторов, с которыми может познакомиться автор с идентификатором 7 (например, "Гете").
SELECT Author1.name AS AuthorName,
       STRING_AGG(Author2.name, '->') WITHIN GROUP (GRAPH PATH) AS Friends
FROM Author AS Author1,
     FamiliarWith FOR PATH AS fw,
     Author for path AS Author2
WHERE MATCH(SHORTEST_PATH(Author1(-(fw)->Author2)+))
      AND Author1.id = 7;

--2. Найти всех авторов, с которыми может познакомиться автор с идентификатором 7 (например, "Гете") за 3 шага.
SELECT Author1.name AS AuthorName,
       STRING_AGG(Author2.name, '->') WITHIN GROUP (GRAPH PATH) AS Friends
FROM Author AS Author1,
     FamiliarWith FOR PATH AS fw,
     Author FOR PATH AS Author2
WHERE MATCH(SHORTEST_PATH(Author1(-(fw)->Author2){1,3}))
      AND Author1.id = 7;




