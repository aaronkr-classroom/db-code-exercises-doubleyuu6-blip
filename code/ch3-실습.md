-- =============================================
-- 실습: 게임 유저 관리 DB 설계 + 구현
-- 파일명: chp3-실습.sql
-- =============================================

-- =============================================
-- [요구사항 정의]
-- 1. 유저는 아이디, 닉네임, 이메일, 레벨, 가입일을 가진다.
-- 2. 유저는 여러 캐릭터를 보유할 수 있다.
-- 3. 캐릭터는 이름, 직업(클래스), 레벨, 경험치를 가진다.
-- 4. 아이템은 이름, 종류, 공격력/방어력 스탯을 가진다.
-- 5. 캐릭터는 여러 아이템을 인벤토리에 보유할 수 있다.
-- 6. 인벤토리에는 아이템 보유 수량과 획득일이 기록된다.
-- 7. 유저의 레벨은 1 이상이어야 한다.
-- =============================================


-- =============================================
-- [STEP 3] 데이터 설계 - 테이블 생성 (CREATE TABLE)
-- 엔티티: users, characters, items, inventory
-- =============================================

-- 1. 유저 테이블
CREATE TABLE users (
    user_id     INT             PRIMARY KEY AUTO_INCREMENT,
    username    VARCHAR(50)     NOT NULL UNIQUE,       -- 로그인 아이디
    nickname    VARCHAR(50)     NOT NULL,              -- 게임 닉네임
    email       VARCHAR(100)    NOT NULL UNIQUE,
    level       INT             NOT NULL DEFAULT 1,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_level CHECK (level >= 1)
);

-- 2. 캐릭터 테이블
CREATE TABLE characters (
    char_id     INT             PRIMARY KEY AUTO_INCREMENT,
    user_id     INT             NOT NULL,
    char_name   VARCHAR(50)     NOT NULL,
    class       VARCHAR(30)     NOT NULL,              -- 직업 (전사, 마법사, 궁수 등)
    char_level  INT             NOT NULL DEFAULT 1,
    exp         BIGINT          NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. 아이템 테이블
CREATE TABLE items (
    item_id     INT             PRIMARY KEY AUTO_INCREMENT,
    item_name   VARCHAR(100)    NOT NULL,
    item_type   VARCHAR(30)     NOT NULL,              -- 무기, 방어구, 소비아이템
    attack      INT             NOT NULL DEFAULT 0,
    defense     INT             NOT NULL DEFAULT 0,
    rarity      VARCHAR(20)     NOT NULL DEFAULT '일반' -- 일반, 희귀, 영웅, 전설
);

-- 4. 인벤토리 테이블 (캐릭터 - 아이템 연결)
CREATE TABLE inventory (
    inv_id      INT             PRIMARY KEY AUTO_INCREMENT,
    char_id     INT             NOT NULL,
    item_id     INT             NOT NULL,
    quantity    INT             NOT NULL DEFAULT 1,
    acquired_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (char_id) REFERENCES characters(char_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);


-- =============================================
-- [STEP 4] 샘플 데이터 삽입 (INSERT INTO)
-- =============================================

-- 유저 데이터 삽입 (사용자 2명 이상)
INSERT INTO users (username, nickname, email, level) VALUES
    ('hong_gd',  '홍길동용사',   'hong@game.com',   15),
    ('kim_ss',   '김사랑마법사', 'kim@game.com',    23),
    ('lee_jj',   '이지지궁수',   'lee@game.com',     8),
    ('park_bb',  '박보배전사',   'park@game.com',   42);

-- 캐릭터 데이터 삽입
INSERT INTO characters (user_id, char_name, class, char_level, exp) VALUES
    (1, '불꽃용사',   '전사',   30, 450000),
    (1, '얼음마법사', '마법사', 18, 120000),
    (2, '별빛궁수',   '궁수',   45, 980000),
    (3, '바람검객',   '검객',   12,  55000),
    (4, '강철방패',   '전사',   60, 2500000);

-- 아이템 데이터 삽입
INSERT INTO items (item_name, item_type, attack, defense, rarity) VALUES
    ('전설의 검',     '무기',       250,   0, '전설'),
    ('드래곤 갑옷',   '방어구',       0, 300, '영웅'),
    ('마법사의 지팡이','무기',       180,  20, '희귀'),
    ('힐링 포션',     '소비아이템',   0,   0, '일반'),
    ('불꽃 활',       '무기',       200,  10, '영웅'),
    ('수호의 방패',   '방어구',      10, 250, '희귀');

-- 인벤토리 데이터 삽입
INSERT INTO inventory (char_id, item_id, quantity) VALUES
    (1, 1, 1),   -- 불꽃용사 -> 전설의 검
    (1, 2, 1),   -- 불꽃용사 -> 드래곤 갑옷
    (1, 4, 5),   -- 불꽃용사 -> 힐링 포션 5개
    (2, 3, 1),   -- 얼음마법사 -> 마법사의 지팡이
    (3, 5, 1),   -- 별빛궁수 -> 불꽃 활
    (5, 1, 1),   -- 강철방패 -> 전설의 검
    (5, 6, 1);   -- 강철방패 -> 수호의 방패


-- =============================================
-- [STEP 4] 조회 쿼리 (SELECT / WHERE / ORDER BY)
-- =============================================

-- 쿼리 1: 전체 유저 목록 (레벨 높은 순)
SELECT 
    user_id,
    nickname,
    level,
    created_at
FROM users
ORDER BY level DESC;

-- 쿼리 2: 레벨 20 이상인 유저만 조회
SELECT 
    username,
    nickname,
    email,
    level
FROM users
WHERE level >= 20
ORDER BY level DESC;

-- 쿼리 3: 특정 유저(hong_gd)의 캐릭터 목록 조회
SELECT 
    c.char_name,
    c.class,
    c.char_level,
    c.exp
FROM characters c
JOIN users u ON c.user_id = u.user_id
WHERE u.username = 'hong_gd'
ORDER BY c.char_level DESC;

-- 쿼리 4: 전설 등급 아이템 조회
SELECT 
    item_name,
    item_type,
    attack,
    defense,
    rarity
FROM items
WHERE rarity = '전설'
ORDER BY attack DESC;

-- 쿼리 5: 캐릭터별 보유 아이템 목록 (인벤토리 조회)
SELECT 
    c.char_name,
    c.class,
    i.item_name,
    i.rarity,
    inv.quantity,
    inv.acquired_at
FROM inventory inv
JOIN characters c ON inv.char_id = c.char_id
JOIN items i      ON inv.item_id = i.item_id
ORDER BY c.char_name, i.rarity DESC;

-- 쿼리 6: 캐릭터 레벨 30 이상이고 '전사' 직업인 캐릭터
SELECT
    u.nickname        AS 유저닉네임,
    c.char_name       AS 캐릭터명,
    c.char_level      AS 레벨,
    c.exp             AS 경험치
FROM characters c
JOIN users u ON c.user_id = u.user_id
WHERE c.class = '전사'
  AND c.char_level >= 30
ORDER BY c.char_level DESC;
