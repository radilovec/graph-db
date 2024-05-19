USE master;
GO

DROP DATABASE IF EXISTS BooksDatabase;
GO

CREATE DATABASE BooksDatabase;
GO

USE BooksDatabase;
GO

-- Таблицы узлов
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

-- Таблицы рёбер
CREATE TABLE FamiliarWith AS EDGE;

CREATE TABLE WrittenBy AS EDGE;

CREATE TABLE PublishedBy AS EDGE;

-- Добавим ограничения
ALTER TABLE FamiliarWith
ADD CONSTRAINT EC_FamiliarWith CONNECTION (Author TO Author);

ALTER TABLE WrittenBy
ADD CONSTRAINT EC_WrittenBy CONNECTION (Author TO Book);

ALTER TABLE PublishedBy
ADD CONSTRAINT EC_PublishedBy CONNECTION (Book TO Publisher);
GO

-- Заполнение таблиц узлов
INSERT INTO Author (id, name)
VALUES (1, N'Толстой'),
       (2, N'Достоевский'),
       (3, N'Пушкин'),
       (4, N'Гоголь'),
       (5, N'Чехов'),
       (6, N'Тургенев'),
       (7, N'Гете'),
       (8, N'Шекспир'),
       (9, N'Маяковский'),
       (10, N'Гюго');

INSERT INTO Publisher (id, name)
VALUES (1, N'Эксмо'),
       (2, N'АСТ'),
       (3, N'ACT'),
       (4, N'Рипол'),
       (5, N'Просвещение'),
       (6, N'Питер'),
       (7, N'Вильямс'),
       (8, N'Палея'),
       (9, N'Амфора'),
       (10, N'Молодая гвардия');

INSERT INTO Book (id, title, author_id, publisher_id)
VALUES (1, N'Война и мир', 1, 1),
       (2, N'Преступление и наказание', 2, 2),
       (3, N'Евгений Онегин', 3, 3),
       (4, N'Мертвые души', 4, 4),
       (5, N'Дама с собачкой', 5, 5),
       (6, N'Отцы и дети', 6, 6),
       (7, N'Фауст', 7, 7),
       (8, N'Гамлет', 8, 8),
       (9, N'Обломов', 6, 9),
       (10, N'Отелло', 8, 10);

-- Заполнение таблиц рёбер
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


-- Запросы с использованием MATCH

-- 1. Найти издательство, которое издало книгу определённого автора (например, "Толстой")
SELECT Publisher.name AS PublisherName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Author.name = N'Толстой';

-- 2. Найти авторов, которые знакомы с определённым автором (например, "Толстой")
SELECT Author2.name AS AuthorName
FROM Author AS Author1
, FamiliarWith
, Author AS Author2
WHERE MATCH(Author1-(FamiliarWith)->Author2)
AND Author1.name = N'Толстой';

-- 3. Найти книгу, которую написал определённый автор (например, "Достоевский")
SELECT Book.title AS BookTitle
FROM Author
, WrittenBy
, Book
WHERE MATCH(Author-(WrittenBy)->Book)
AND Author.name = N'Достоевский';

-- 4. Найти издательства, которые издали книги, написанные автором определённого жанра (например, классика)
SELECT DISTINCT Publisher.name AS PublisherName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Book.title IN ('Война и мир', 'Преступление и наказание', 'Евгений Онегин', 'Мертвые души', 'Дама с собачкой', 'Отцы и дети', 'Фауст', 'Гамлет', 'Обломов', 'Отелло')
AND Author.name IN ('Толстой', 'Достоевский', 'Пушкин', 'Гоголь', 'Чехов', 'Тургенев', 'Гете', 'Шекспир', 'Маяковский', 'Гюго');

-- 5. Найти авторов, которые написали книги для определённого издательства (например, Эксмо)
SELECT DISTINCT Author.name AS AuthorName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Publisher.name = N'Эксмо';









