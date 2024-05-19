USE master;
GO

DROP DATABASE IF EXISTS BooksDatabase;
GO

CREATE DATABASE BooksDatabase;
GO

USE BooksDatabase;
GO

-- ������� �����
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

-- ������� ����
CREATE TABLE FamiliarWith AS EDGE;

CREATE TABLE WrittenBy AS EDGE;

CREATE TABLE PublishedBy AS EDGE;

-- ������� �����������
ALTER TABLE FamiliarWith
ADD CONSTRAINT EC_FamiliarWith CONNECTION (Author TO Author);

ALTER TABLE WrittenBy
ADD CONSTRAINT EC_WrittenBy CONNECTION (Author TO Book);

ALTER TABLE PublishedBy
ADD CONSTRAINT EC_PublishedBy CONNECTION (Book TO Publisher);
GO

-- ���������� ������ �����
INSERT INTO Author (id, name)
VALUES (1, N'�������'),
       (2, N'�����������'),
       (3, N'������'),
       (4, N'������'),
       (5, N'�����'),
       (6, N'��������'),
       (7, N'����'),
       (8, N'�������'),
       (9, N'����������'),
       (10, N'����');

INSERT INTO Publisher (id, name)
VALUES (1, N'�����'),
       (2, N'���'),
       (3, N'ACT'),
       (4, N'�����'),
       (5, N'�����������'),
       (6, N'�����'),
       (7, N'�������'),
       (8, N'�����'),
       (9, N'������'),
       (10, N'������� �������');

INSERT INTO Book (id, title, author_id, publisher_id)
VALUES (1, N'����� � ���', 1, 1),
       (2, N'������������ � ���������', 2, 2),
       (3, N'������� ������', 3, 3),
       (4, N'������� ����', 4, 4),
       (5, N'���� � ��������', 5, 5),
       (6, N'���� � ����', 6, 6),
       (7, N'�����', 7, 7),
       (8, N'������', 8, 8),
       (9, N'�������', 6, 9),
       (10, N'������', 8, 10);

-- ���������� ������ ����
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


-- ������� � �������������� MATCH

-- 1. ����� ������������, ������� ������ ����� ������������ ������ (��������, "�������")
SELECT Publisher.name AS PublisherName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Author.name = N'�������';

-- 2. ����� �������, ������� ������� � ����������� ������� (��������, "�������")
SELECT Author2.name AS AuthorName
FROM Author AS Author1
, FamiliarWith
, Author AS Author2
WHERE MATCH(Author1-(FamiliarWith)->Author2)
AND Author1.name = N'�������';

-- 3. ����� �����, ������� ������� ����������� ����� (��������, "�����������")
SELECT Book.title AS BookTitle
FROM Author
, WrittenBy
, Book
WHERE MATCH(Author-(WrittenBy)->Book)
AND Author.name = N'�����������';

-- 4. ����� ������������, ������� ������ �����, ���������� ������� ������������ ����� (��������, ��������)
SELECT DISTINCT Publisher.name AS PublisherName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Book.title IN ('����� � ���', '������������ � ���������', '������� ������', '������� ����', '���� � ��������', '���� � ����', '�����', '������', '�������', '������')
AND Author.name IN ('�������', '�����������', '������', '������', '�����', '��������', '����', '�������', '����������', '����');

-- 5. ����� �������, ������� �������� ����� ��� ������������ ������������ (��������, �����)
SELECT DISTINCT Author.name AS AuthorName
FROM Author
, WrittenBy
, Book
, PublishedBy
, Publisher
WHERE MATCH(Author-(WrittenBy)->Book-(PublishedBy)->Publisher)
AND Publisher.name = N'�����';









