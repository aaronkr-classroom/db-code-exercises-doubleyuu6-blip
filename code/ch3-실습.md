-- =============================================
-- 실습: 게임 유저 관리 DB 설계 + 구현
-- 시스템: 게임 유저 / 캐릭터 / 아이템 관리
-- =============================================

-- =============================================
-- [요구사항 정의] - 총 7가지
-- 1. 유저는 아이디, 닉네임, 이메일, 레벨, 가입일을 가진다.
-- 2. 유저는 여러 캐릭터를 보유할 수 있다. (1:N 관계)
-- 3. 캐릭터는 이름, 직업(클래스), 레벨, 경험치를 가진다.
-- 4. 아이템은 이름, 종류, 공격력/방어력, 등급을 가진다.
-- 5. 캐릭터는 여러 아이템을 인벤토리에 보유할 수 있다. (N:M 관계)
-- 6. 인벤토리에는 아이템 보유 수량과 획득일이 기록된다.
-- 7. 유저의 레벨은 반드시 1 이상이어야 한다. (제약 조건)
-- =============================================


-- =============================================
-- [CREATE TABLE] 테이블 생성
-- 엔티티 4개: users, characters, items, inventory
-- =============================================

-- [테이블 1] 유저 테이블
-- 게임에 가입한 유저 정보를 저장한다.
CREATE TABLE users (
    user_id     INT          PRIMARY KEY AUTO_INCREMENT, -- 유저 고유 번호 (자동 증가)
    username    VARCHAR(50)  NOT NULL UNIQUE,            -- 로그인 아이디 (중복 불가)
    nickname    VARCHAR(50)  NOT NULL,                   -- 게임 내 표시 이름
    email       VARCHAR(100) NOT NULL UNIQUE,            -- 이메일 (중복 불가)
    level       INT          NOT NULL DEFAULT 1,         -- 유저 레벨 (기본값 1)
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 가입일 (자동 기록)
    CONSTRAINT chk_level CHECK (level >= 1)             -- 레벨은 반드시 1 이상이어야 함
);

-- [테이블 2] 캐릭터 테이블
-- 유저가 보유한 게임 캐릭터 정보를 저장한다.
-- 한 유저가 여러 캐릭터를 가질 수 있으므로 user_id를 외래 키로 참조한다.
CREATE TABLE characters (
    char_id     INT         PRIMARY KEY AUTO_INCREMENT,  -- 캐릭터 고유 번호
    user_id     INT         NOT NULL,                    -- 소속 유저 (users 테이블 참조)
    char_name   VARCHAR(50) NOT NULL,                    -- 캐릭터 이름
    class       VARCHAR(30) NOT NULL,                    -- 직업 (전사, 마법사, 궁수 등)
    char_level  INT         NOT NULL DEFAULT 1,          -- 캐릭터 레벨 (기본값 1)
    exp         BIGINT      NOT NULL DEFAULT 0,          -- 경험치 (큰 수이므로 BIGINT 사용)
    created_at  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 캐릭터 생성일
    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE                                -- 유저 삭제 시 소속 캐릭터도 함께 삭제
);

-- [테이블 3] 아이템 테이블
-- 게임 내 존재하는 아이템 정보를 저장한다.
CREATE TABLE items (
    item_id     INT          PRIMARY KEY AUTO_INCREMENT, -- 아이템 고유 번호
    item_name   VARCHAR(100) NOT NULL,                   -- 아이템 이름
    item_type   VARCHAR(30)  NOT NULL,                   -- 종류 (무기, 방어구, 소비아이템)
    attack      INT          NOT NULL DEFAULT 0,         -- 공격력 수치 (없으면 0)
    defense     INT          NOT NULL DEFAULT 0,         -- 방어력 수치 (없으면 0)
    rarity      VARCHAR(20)  NOT NULL DEFAULT '일반'     -- 등급 (일반, 희귀, 영웅, 전설)
);

-- [테이블 4] 인벤토리 테이블
-- 캐릭터와 아이템을 연결하는 중간 테이블 (N:M 관계 해소)
-- 어떤 캐릭터가 어떤 아이템을 몇 개 보유하는지 기록한다.
CREATE TABLE inventory (
    inv_id      INT      PRIMARY KEY AUTO_INCREMENT,     -- 인벤토리 레코드 고유 번호
    char_id     INT      NOT NULL,                       -- 소유 캐릭터 (characters 참조)
    item_id     INT      NOT NULL,                       -- 보유 아이템 (items 참조)
    quantity    INT      NOT NULL DEFAULT 1,             -- 보유 수량 (기본값 1)
    acquired_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 아이템 획득일
    FOREIGN KEY (char_id) REFERENCES characters(char_id)
        ON DELETE CASCADE,                               -- 캐릭터 삭제 시 인벤토리도 함께 삭제
    FOREIGN KEY (item_id) REFERENCES items(item_id)     -- 아이템 정보 참조
);


-- =============================================
-- [INSERT INTO] 샘플 데이터 삽입
-- =============================================

-- 유저 4명 삽입 (요구사항: 2명 이상)
-- user_id는 AUTO_INCREMENT로 자동 부여됨 (1, 2, 3, 4)
INSERT INTO users (username, nickname, email, level) VALUES
    ('hong_gd', '홍길동용사',   'hong@game.com',  15),
    ('kim_ss',  '김사랑마법사', 'kim@game.com',   23),
    ('lee_jj',  '이지지궁수',   'lee@game.com',    8),
    ('park_bb', '박보배전사',   'park@game.com',  42);

-- 캐릭터 5개 삽입
-- user_id 숫자는 위에서 삽입된 유저의 순서(1~4)와 일치
INSERT INTO characters (user_id, char_name, class, char_level, exp) VALUES
    (1, '불꽃용사',   '전사',   30,  450000), -- hong_gd 소속
    (1, '얼음마법사', '마법사', 18,  120000), -- hong_gd 소속 (한 유저가 2개 보유 가능)
    (2, '별빛궁수',   '궁수',   45,  980000), -- kim_ss 소속
    (3, '바람검객',   '검객',   12,   55000), -- lee_jj 소속
    (4, '강철방패',   '전사',   60, 2500000); -- park_bb 소속

-- 아이템 6개 삽입
INSERT INTO items (item_name, item_type, attack, defense, rarity) VALUES
    ('전설의 검',      '무기',       250,   0, '전설'), -- 공격형 최고급 무기
    ('드래곤 갑옷',    '방어구',       0, 300, '영웅'), -- 방어형 고급 방어구
    ('마법사의 지팡이','무기',       180,  20, '희귀'), -- 마법사 전용 무기
    ('힐링 포션',      '소비아이템',   0,   0, '일반'), -- 소모성 아이템 (스탯 없음)
    ('불꽃 활',        '무기',       200,  10, '영웅'), -- 궁수 전용 무기
    ('수호의 방패',    '방어구',      10, 250, '희귀'); -- 방어 특화 방어구

-- 인벤토리 삽입: 어떤 캐릭터가 어떤 아이템을 몇 개 보유하는지 기록
INSERT INTO inventory (char_id, item_id, quantity) VALUES
    (1, 1, 1),  -- 불꽃용사(char_id=1) → 전설의 검(item_id=1) 1개
    (1, 2, 1),  -- 불꽃용사(char_id=1) → 드래곤 갑옷(item_id=2) 1개
    (1, 4, 5),  -- 불꽃용사(char_id=1) → 힐링 포션(item_id=4) 5개
    (2, 3, 1),  -- 얼음마법사(char_id=2) → 마법사의 지팡이(item_id=3) 1개
    (3, 5, 1),  -- 별빛궁수(char_id=3) → 불꽃 활(item_id=5) 1개
    (5, 1, 1),  -- 강철방패(char_id=5) → 전설의 검(item_id=1) 1개
    (5, 6, 1);  -- 강철방패(char_id=5) → 수호의 방패(item_id=6) 1개


-- =============================================
-- [SELECT] 데이터 조회
-- WHERE: 조건 필터링 / ORDER BY: 정렬
-- =============================================

-- [쿼리 1] 전체 유저 목록을 레벨 높은 순으로 조회
SELECT
    user_id,
    nickname,
    level,
    created_at
FROM users
ORDER BY level DESC;  -- DESC: 내림차순 (높은 값부터 낮은 값 순)

-- [쿼리 2] 레벨 20 이상인 유저만 필터링해서 조회
SELECT
    username,
    nickname,
    email,
    level
FROM users
WHERE level >= 20     -- WHERE: 조건에 맞는 행만 선택
ORDER BY level DESC;

-- [쿼리 3] 특정 유저(hong_gd)의 캐릭터 목록 조회
-- JOIN으로 users와 characters를 user_id 기준으로 연결
SELECT
    c.char_name,
    c.class,
    c.char_level,
    c.exp
FROM characters c                          -- c는 characters의 별칭(alias)
JOIN users u ON c.user_id = u.user_id      -- u는 users의 별칭, user_id가 같은 행끼리 연결
WHERE u.username = 'hong_gd'               -- 해당 유저의 캐릭터만 필터링
ORDER BY c.char_level DESC;

-- [쿼리 4] 전설 등급 아이템만 조회
SELECT
    item_name,
    item_type,
    attack,
    defense,
    rarity
FROM items
WHERE rarity = '전설'    -- 문자열 조건은 따옴표로 감쌈
ORDER BY attack DESC;    -- 공격력 높은 순 정렬

-- [쿼리 5] 캐릭터별 보유 아이템 목록 (3개 테이블 JOIN)
-- inventory를 중심으로 characters와 items를 한 번에 연결해 조회
SELECT
    c.char_name,
    c.class,
    i.item_name,
    i.rarity,
    inv.quantity,
    inv.acquired_at
FROM inventory inv                          -- 중간 테이블을 기준으로 시작
JOIN characters c ON inv.char_id = c.char_id -- 캐릭터 정보 연결
JOIN items i      ON inv.item_id = i.item_id -- 아이템 정보 연결
ORDER BY c.char_name, i.rarity DESC;        -- 캐릭터명 오름차순, 등급 내림차순

-- [쿼리 6] 레벨 30 이상인 '전사' 직업 캐릭터 조회
-- WHERE에 AND를 사용해 두 조건을 동시에 적용
SELECT
    u.nickname   AS 유저닉네임,  -- AS: 결과 컬럼명을 별칭으로 표시
    c.char_name  AS 캐릭터명,
    c.char_level AS 레벨,
    c.exp        AS 경험치
FROM characters c
JOIN users u ON c.user_id = u.user_id
WHERE c.class = '전사'       -- 조건 1: 직업이 전사
  AND c.char_level >= 30     -- 조건 2: 레벨 30 이상 (두 조건 모두 만족해야 조회됨)
ORDER BY c.char_level DESC;
