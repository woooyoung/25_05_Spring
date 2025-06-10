DROP DATABASE IF EXISTS `25_05_Spring`;
CREATE DATABASE `25_05_Spring`;
USE `25_05_Spring`;

# 게시글 테이블 생성
CREATE TABLE article (
	id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	regDate DATETIME NOT NULL,
	updateDate DATETIME NOT NULL,
	title CHAR(100) NOT NULL,
	`body` TEXT NOT NULL
);

# 회원 테이블 생성
CREATE TABLE `member` (
	id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	regDate DATETIME NOT NULL,
	updateDate DATETIME NOT NULL,
	loginId CHAR(30) NOT NULL,
	loginPw char(100) NOT NULL,
	`authLevel` smallint(2) unsigned default 3 comment '권한 레벨 (3=일반,7=관리자)', 
	`name` char(20) NOT NULL,
	nickname char(20) NOT NULL,
	cellphoneNum char(20) NOT NULL,
	email char(20) NOT NULL,
	delStatus tinyint(1) unsigned not null default 0 comment '탈퇴 여부 (0=탈퇴 전, 1=탈퇴 후)',
	delDate datetime comment '탈퇴 날짜'
);


# 게시판(board) 테이블 생성
CREATE TABLE board (
	id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	regDate DATETIME NOT NULL,
	updateDate DATETIME NOT NULL,
	`code` CHAR(50) NOT NULL unique comment 'notice(공지사항) free(자유) QnA(질의응답)...',
	`name` CHAR(20) NOT NULL UNIQUE COMMENT '게시판 이름',
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0=삭제 전, 1=삭제 후)',
	delDate DATETIME COMMENT '삭제 날짜'
);

# 게시판(board) 테스트 데이터 생성
INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'NOTICE',
`name` = '공지사항';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'FREE',
`name` = '자유';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'QnA',
`name` = '질의응답';


# 게시글 테스트 데이터 생성
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목4',
`body` = '내용4';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목5',
`body` = '내용5';

# 회원 테스트 데이터 생성
# 관리자
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = SHA2('admin',256),
`authLevel` = 7,
`name` = '관리자',
nickname = '관리자_닉네임',
cellphoneNum = '01012341234',
email = 'abc@gmail.com';

# 회원
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = SHA2('test1',256),
`name` = '회원1_이름',
nickname = '회원1_닉네임',
cellphoneNum = '01043214321',
email = 'abcd@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = SHA2('test2',256),
`name` = '회원2_이름',
nickname = '회원2_닉네임',
cellphoneNum = '01056785678',
email = 'abcde@gmail.com';

# memberId 추가
alter table article add column memberId int(10) unsigned not null after updateDate;

update article 
set memberId = 2
where id in (1,2);

UPDATE article 
SET memberId = 3
WHERE id in (3,4,5);

# boardId 추가
alter table article add column boardId int(10) not null after `memberId`;

UPDATE article 
SET boardId = 1
WHERE id in (1,2);

UPDATE article 
SET boardId = 2
WHERE id in (3,4);

UPDATE article 
SET boardId = 3
WHERE id = 5;

alter table article add column hitCount int(10) unsigned not null default 0 after `body`;

# reactionPoint 테이블 생성

CREATE TABLE reactionPoint (
	id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	regDate DATETIME NOT NULL,
	updateDate DATETIME NOT NULL,
	memberId int(10) unsigned not null,
	relTypeCode char(50) not null comment '관련 데이터 타입 코드',
	relId int(10) not null comment '관련 데이터 번호',
	`point` int(10) not null
);

# reactionPoint 테스트 데이터 생성
# 1번 회원이 1번 글에 싫어요
insert into reactionPoint
set regDate = now(),
updateDate = now(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 1번 회원이 2번 글에 좋아요
insert into reactionPoint
set regDate = now(),
updateDate = now(),
memberId = 1,
relTypeCode = 'article',
relId = 2,
`point` = 1;

# 2번 회원이 1번 글에 싫어요
insert into reactionPoint
set regDate = now(),
updateDate = now(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 2번 회원이 2번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`point` = -1;

# 3번 회원이 1번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`point` = 1;

# article 테이블에 reactionPoint(좋아요) 컬럼 추가
alter table article add column goodReactionPoint int(10) unsigned not null default 0;
alter table article add column badReactionPoint int(10) unsigned not null default 0;

# update join -> 기존에 게시글의 good bad RP 값을 RP 테이블에서 추출해서 article 테이블에 채우기
update article as A
inner join (
	select RP.relTypeCode, RP.relId,
	SUM(if(RP.point > 0, RP.point, 0)) AS goodReactionPoint,
	SUM(if(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
	from reactionPoint as RP
	group by RP.relTypeCode, RP.relId
) as RP_SUM
on A.id = RP_SUM.relId
set A.goodReactionPoint = RP_SUM.goodReactionPoint,
A.badReactionPoint = RP_SUM.badReactionPoint;


# reply 테이블 생성
CREATE TABLE reply (
	id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	regDate DATETIME NOT NULL,
	updateDate DATETIME NOT NULL,
	memberId INT(10) UNSIGNED NOT NULL,
	relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
	relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
	`body` text not null
);

# 2번 회원이 1번 글에 댓글 작성
insert into reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 1';

# 2번 회원이 1번 글에 댓글 작성
insert into reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 2';

# 3번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 3';

# 3번 회원이 2번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 2,
`body` = '댓글 4';

# reply 테이블에 좋아요 관련 컬럼 추가
alter table reply add column goodReactionPoint int(10) unsigned not null default 0;
alter table reply add column badReactionPoint int(10) unsigned not null default 0;

# reply - reactionPoint 테스트 데이터
# 1번 회원이 1번 댓글에 싫어요
insert into reactionPoint
set regDate = now(),
updateDate = now(),
memberId = 1,
relTypeCode = 'reply',
relId = 1,
`point` = -1;

# 1번 회원이 2번 댓글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'reply',
relId = 2,
`point` = 1;

# 2번 회원이 1번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'reply',
relId = 1,
`point` = -1;

# 2번 회원이 2번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'reply',
relId = 2,
`point` = -1;

# 3번 회원이 1번 댓글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'reply',
relId = 1,
`point` = 1;

# update join -> 기존에 댓글의 good bad RP 값을 RP 테이블에서 추출해서 reply 테이블에 채우기
update reply as R
inner join (
	select RP.relTypeCode, RP.relId,
	SUM(if(RP.point > 0, RP.point, 0)) AS goodReactionPoint,
	SUM(if(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
	from reactionPoint as RP
	group by RP.relTypeCode, RP.relId
) as RP_SUM
on R.id = RP_SUM.relId
set R.goodReactionPoint = RP_SUM.goodReactionPoint,
R.badReactionPoint = RP_SUM.badReactionPoint;

######################################################################

SELECT SHA2('test1',256);

SELECT *
FROM article
ORDER BY id DESC;

SELECT count(*)
FROM article
ORDER BY id DESC;

SELECT *
FROM `member`;

SELECT *
FROM board;

SELECT *
FROM reactionPoint;


SELECT *
FROM reply;

######################################################################

select ifnull(SUM(RP.point),0)
from reactionPoint as RP
WHERE RP.relTypeCode = 'article'
and RP.relId = 1
and RP.memberId = 1;

SELECT A.*, M.nickname AS extra__writer
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
WHERE A.id = 1;

SELECT *
FROM reactionPoint;

# LEFT JOIN
SELECT A.*, M.nickname AS extra__writer, RP.point
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
left join reactionPoint as RP
on A.id = RP.relId and RP.relTypeCode = 'article'
group by A.id
order by A.id desc;

# 서브쿼리
SELECT A.*, 
ifnull(sum(RP.point),0) as extra__sumReactionPoint,
IFNULL(SUM(if(RP.point > 0, RP.point, 0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(if(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
FROM (
	select A.*, M.nickname as extra__writer 
	from article AS A
	inner join `member` as M
	on A.memberId = M.id) as A
left join reactionPoint as RP
on A.id = RP.relId and RP.relTypeCode = 'article'
group by A.id
order by A.id desc;

# JOIN
SELECT A.*, M.nickname AS extra__writer,
ifnull(sum(RP.point),0) as extra__sumReactionPoint,
IFNULL(SUM(if(RP.point > 0, RP.point, 0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(if(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
from article AS A
inner join `member` as M
on A.memberId = M.id
left join reactionPoint as RP
on A.id = RP.relId and RP.relTypeCode = 'article'
group by A.id
order by A.id desc;


SELECT A.*, M.nickname AS extra__writer,
		IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
		IFNULL(SUM(IF(RP.point > 0, RP.point, 0)),0) AS
		extra__goodReactionPoint,
		IFNULL(SUM(IF(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
		FROM article AS A
		INNER JOIN `member` AS M
		ON A.memberId = M.id
		LEFT JOIN reactionPoint AS RP
		ON A.id = RP.relId AND RP.relTypeCode = 'article'
		WHERE A.id = 1


SELECT A.*, M.nickname AS extra__writer, RP.point
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
left join reactionPoint as RP
on A.id = RP.relId and RP.relTypeCode = 'article'
WHERE A.id = 1;

SELECT A.*, M.nickname AS extra__writer, RP.point
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
INNER JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
WHERE A.id = 2;

SELECT A.*, M.nickname AS extra__writer, RP.point
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
INNER JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
WHERE A.id = 3;


select hitCount
from article
where id = 1;


update article 
set hitCount = 1
where id = 1000;

'111'

SELECT COUNT(*) as cnt
FROM article
where boardId = 1 and title like '%11%';

SELECT *
FROM article
where boardId = 3 and title like '%12%';

SELECT *
FROM article
WHERE boardId = 1 AND `body` LIKE '%13%';

SELECT *
FROM article
WHERE boardId = 1 AND title like '%111%' or `body` LIKE '%111%';


SELECT *
FROM article
where boardId = 1 AND title LIKE '%11%'
ORDER BY id DESC;

# 게시글 데이터 대량 생성
INSERT INTO article
	( 
		regDate, updateDate, memberId, boardId, title, `body`
	)
select now(), now(), floor(RAND() * 2) + 2, floor(RAND() * 3) + 1, concat('제목__',rand()), concat('내용__',rand())
from article;

select floor(RAND() * 2) + 2;

select floor(RAND() * 3) + 1;

SELECT *
		FROM board
		WHERE id = 4 AND delStatus = 0

SELECT A.*, M.nickname AS extra__writer
		FROM article AS A
		INNER JOIN `member` AS M
		ON A.memberId = M.id
		WHERE boardId = 3
		ORDER BY A.id
		DESC

SELECT *
		FROM board
		WHERE id =2

SELECT LAST_INSERT_ID();

delete from article where id = 4;

select * from `member`
where loginId = 'test4'

select ceiling(RAND() * 3);

# 게시글 데이터 대량 생성
INSERT INTO article
SET regDate = NOW(),
memberId = ceiling(RAND() * 3),
title = CONCAT('제목__', rand()),
`body` = CONCAT('내용__',rand());

# 회원 데이터 대량 생성
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = CONCAT('loginId ',SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),
loginPw = CONCAT('loginPw ',SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),
`name` = CONCAT('name ',SUBSTRING(RAND() * 1000 FROM 1 FOR 2));



SELECT COUNT(*) > 0
FROM `member`
WHERE loginId = 'test2';

SELECT 1 + 1;
SELECT 1 >= 1;

SELECT COUNT(*) > 0 FROM `member` WHERE loginId = 'test3';

SELECT NOW();

SELECT '제목1';

SELECT CONCAT('제목',' 1');

SELECT SUBSTRING(RAND() * 1000 FROM 1 FOR 2);

INSERT INTO articleset regDate = NOW(),updateDate = NOW(),title = CONCAT('제목',SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),`body` = CONCAT('내용',SUBSTRING(RAND() * 1000 FROM 1 FOR 2));



UPDATE article
SET updateDate = NOW(),
    title = 'title1',
    `body` = 'body1'
WHERE id = 3;

UPDATE article
SET updateDate = NOW(),
    `body` = 'body1'
WHERE id = 1;

SELECT * FROM article;

SELECT COUNT(*)
FROM article
WHERE id = 5;

UPDATE article
SET updateDate = NOW(),
    title = 'title1',
    `body` = 'body1'
WHERE id = 5;