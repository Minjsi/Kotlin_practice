DROP TABLE IF EXISTS `_extra_data`;
DROP TABLE IF EXISTS `_cto_condition`;
DROP TABLE IF EXISTS `_cto_message`;
DROP TABLE IF EXISTS `_button`;
DROP TABLE IF EXISTS `_button_group_display_url`;
DROP TABLE IF EXISTS `_button_group`;
DROP TABLE IF EXISTS `_square_card_relation`;
DROP TABLE IF EXISTS `_square`;
DROP TABLE IF EXISTS `_card`;
DROP TABLE IF EXISTS `_content`;
DROP TABLE IF EXISTS `_file`;
DROP TABLE IF EXISTS `_integration_feature`;
DROP TABLE IF EXISTS `_integration_auth`;
DROP TABLE IF EXISTS `_client_log_error`;
DROP TABLE IF EXISTS `_scheduler_log`;
DROP TABLE IF EXISTS `_scheduler`;


-- 로컬 site 테이블
CREATE TABLE `site` (
    `id` bigint unsigned NOT NULL,
    `name` varchar(100) NOT NULL DEFAULT '' COMMENT '고객사 명',
    `partner_id` int DEFAULT '1',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='고객사 정보 정의';


-- 파일 테이블
CREATE TABLE `_file`
(
    `id`           int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `site_id`      bigint       NOT NULL COMMENT 'FK site.id',
    `status`       varchar(10)  NOT NULL DEFAULT 'TEMP' COMMENT '파일 상태 (TEMP: 업로드 확정 전(설정 저장 전) 임시로 업로드한 파일, PERSISTENT: 저장 확정된 파일)',
    `storage_type` varchar(15)  NOT NULL COMMENT '스토리지 타입 (S3: S3/NCP Object Storage, HOST: Host file)',
    `content_type` varchar(50)  NOT NULL COMMENT '콘텐츠 타입',
    `file_name`    varchar(255) NOT NULL COMMENT '파일 명',
    `file_size`    int(11)      NOT NULL COMMENT '파일 크기',
    `path`         varchar(255) NOT NULL COMMENT 'S3/NCP Object Storage Key, Host file path',
    `created`      datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    PRIMARY KEY (`id`),
    KEY `FK_FILE_SITE_ID` (`site_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;
-- 데이터 무결성 (id 참조키) 보장 위한 시스템 내부 파일
INSERT INTO `_file` (`site_id`, `status`, `storage_type`, `content_type`, `file_name`, `file_size`, `path`)
VALUES (0, 'HOST', 'UNDEFINED', 'SYSTEM', 'UNDEFINED', 0, 'UNDEFINED');
UPDATE `_file`
SET `id` = 0
WHERE `id` = 1;
ALTER TABLE `_file`
    AUTO_INCREMENT = 1;

-- 콘텐츠 테이블
CREATE TABLE `_content`
(
    `id`       int(11)     NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `site_id`  bigint      NOT NULL COMMENT 'FK site.id',
    `integration_auth_id`  int(11)  COMMENT 'FK integration_auth.id 외부 서비스 인증 필요한 컨텐츠 (만료될 시 마지막 auth_id, 카드,cto 삭제시 null 처리)',
    `type`     varchar(50) NOT NULL COMMENT '콘텐츠 타입 (BASIC_INFO: 기본 정보, POST_CARD: EVENT_PROMOTION: 이벤트 홍보, CS_SUPPORT: CS 지원/채팅, RSS: RSS 피드, MARKETING_SYNC: 마케팅싱크, INSTAGRAM: 인스타그램 피드, YOUTUBE: 유튜브, FAQ: 카페24 게시글',
    `contents` mediumtext  NOT NULL COMMENT 'type 별 컨텐츠 (JSON)',
    PRIMARY KEY (`id`),
    KEY `FK_CONTENT_SITE_ID` (`site_id`),
    KEY `IDX_CONTENT_TYPE` (`type`),
    KEY `IDX_CONTENT_INTEGRATION_AUTH_ID` (`integration_auth_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- 카드 테이블
CREATE TABLE `_card`
(
    `id`         int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `site_id`    bigint       NOT NULL COMMENT 'FK site.id',
    `content_id` int(11)      NOT NULL COMMENT 'FK content.id',
    `name`       varchar(255) NOT NULL COMMENT '카드 명 (UI에 표시되는 카드 명)',
    `visible`    tinyint(1)   NOT NULL DEFAULT 1 COMMENT '카드 노출여부 (0: 비노출, 1: 노출)',
    `deleted`    tinyint(1)   NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0:삭제 안함, 1:삭제)',
    `created`    datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    `updated`    datetime(6)           DEFAULT NULL COMMENT '수정일시',
    PRIMARY KEY (`id`),
    KEY `FK_CARD_SITE_ID` (`site_id`),
    KEY `FK_CARD_CONTENT_ID` (`content_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- 스퀘어 테이블
CREATE TABLE `_square`
(
    `id`       int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `site_id`  bigint       NOT NULL COMMENT 'FK site.id',
    `name`     varchar(255) NOT NULL COMMENT '스퀘어 명 (UI에 표시되는 스퀘어 명)',
    `contents` mediumtext   NOT NULL COMMENT '스퀘어 컨텐츠(JSON)',
    `visible`  tinyint(1)   NOT NULL DEFAULT 1 COMMENT '스퀘어 노출여부 (0: 비노출, 1: 노출)',
    `deleted`  tinyint(1)   NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0:삭제 안함, 1:삭제)',
    `created`  datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    `updated`  datetime(6)           DEFAULT NULL COMMENT '수정일시',
    PRIMARY KEY (`id`),
    KEY `FK_SQUARE_SITE_ID` (`site_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- 스퀘어에 포함된 카드, 정렬 순서 릴레이션 정보 테이블
CREATE TABLE `_square_card_relation`
(
    `id`        int(11)    NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `square_id` int(11)    NOT NULL COMMENT 'FK square.id',
    `card_id`   int(11)    NOT NULL COMMENT 'FK card.id',
    `order`     tinyint(2) NOT NULL DEFAULT 0 COMMENT '스퀘어 내 카드 순서',
    PRIMARY KEY (`id`),
    KEY `FK_CARD_REL_SQUARE_ID` (`square_id`),
    KEY `FK_CARD_REL_CARD_ID` (`card_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- 버튼 그룹 테이블
CREATE TABLE `_button_group`
(
    `id`              int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `site_id`         bigint       NOT NULL COMMENT 'FK site.id',
    `name`            varchar(255) NOT NULL COMMENT '버튼 그룹 명 (UI에 표시되는 스퀘어 명)',
    `device_contents` text         NOT NULL COMMENT '디바이스 타입별로 다르게 사용되는 추가 속성값들 (JSON)',
    `visible`         tinyint(1)   NOT NULL DEFAULT 1 COMMENT '버튼 노출여부 (0: 비노출, 1: 노출)',
    `deleted`         tinyint(1)   NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0:삭제 안함, 1:삭제)',
    `created`         datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    `updated`         datetime(6)           DEFAULT NULL COMMENT '수정일시',
    PRIMARY KEY (`id`),
    KEY `FK_BTN_GRP_SITE_ID` (`site_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- 버튼 그룹 표시 URL 정보
CREATE TABLE `_button_group_display_url`
(
    `id`              int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `button_group_id` int(11)      NOT NULL COMMENT 'FK button_group.id',
    `condition`       varchar(50)  NOT NULL COMMENT '조건 (INCLUDE: 포함, EXCLUDE: 제외)',
    `url_pattern`     varchar(255) NOT NULL COMMENT 'URL 패턴',
    `created`         datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    PRIMARY KEY (`id`),
    KEY `FK_BDU_BTN_GRP_ID` (`button_group_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- 버튼 테이블
CREATE TABLE `_button`
(
    `id`              int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `button_group_id` int(11)      NOT NULL COMMENT 'FK button_group.id',
    `square_id`       int(11)               DEFAULT NULL COMMENT 'FK square.id (link_type 이 SQUARE 일때만 사용)',
    `card_id`         int(11)               DEFAULT NULL COMMENT 'FK card.id (link_type 이 CARD 일때만 사용)',
    `url`             varchar(1024)         DEFAULT NULL COMMENT '외부 URL (link_type 이 URL 일때만 사용)',
    `name`            varchar(255) NOT NULL COMMENT '버튼 명 (UI에 표시되는 버튼 명)',
    `type`            varchar(10)  NOT NULL COMMENT '버튼 타입 (LABEL: 로고, 제목 내용이 포함된 라벨, BUTTON: 로고 버튼)',
    `contents`        text                  DEFAULT NULL COMMENT '버튼 타입별로 다르게 사용되는 추가 속성값들 (JSON)',
    `device_contents` text                  DEFAULT NULL COMMENT '디바이스 타입별로 다르게 사용되는 추가 속성값들 (JSON)',
    `link_type`       varchar(10)  NOT NULL COMMENT '버튼 링크 타입 (CARD: 카드, SQUARE: 스퀘어, URL: 외부 URL)',
    `order`           tinyint(2)   NOT NULL DEFAULT 0 COMMENT '버튼 그룹 내 버튼 순서',
    `deleted`         tinyint(1)   NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0:삭제 안함, 1:삭제)',
    `created`         datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    `updated`         datetime(6)           DEFAULT NULL COMMENT '수정일시',
    PRIMARY KEY (`id`),
    KEY `FK_BUTTON_BTN_GRP_ID` (`button_group_id`),
    KEY `FK_BUTTON_SQUARE_ID` (`square_id`),
    KEY `FK_BUTTON_CARD_ID` (`card_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- CTO 메시지 테이블
CREATE TABLE `_cto_message`
(
    `id`                 int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `site_id`            bigint       NOT NULL COMMENT 'FK site.id',
    `content_id`         int(11)      NOT NULL COMMENT 'FK content.id',
    `name`               varchar(255) NOT NULL COMMENT 'CTO 메시지명 (UI에 표시되는 CTO 메시지명)',
    `priority`           tinyint(2)   NOT NULL DEFAULT 1 COMMENT 'CTO 메시지 우선순위 (값이 낮을수록 높음)',
    `position_ref`       varchar(20)  NOT NULL DEFAULT '' COMMENT '메시지 위치 기준 (CENTER: 화면 가운데, BUTTON: 설치된 버튼 기준)',
    `display_interval`   varchar(20)  NOT NULL DEFAULT 'ALWAYS' COMMENT '조건 만족 시 메시지 전송 횟수 (ONLY_ONCE: 처음 1회, ONCE_PER_DAY: 매일 1회, ALWAYS: 접속 할 때마다)',
    `condition_set_type` varchar(20)  NOT NULL DEFAULT 'ALWAYS' COMMENT '메시지 전송 조건 묶음 타입 (FIRST_VISIT: 처음 방문, REVISIT: 재방문, ALWAYS: 모든 상황에서)',
    `target`             varchar(15)  NOT NULL DEFAULT 'EVERYONE' COMMENT '메시지 보여줄 대상 (EVERYONE: 모두에게, LOGGED_IN: [카페24] 로그인한 사용자, NOT_LOGGED_IN: [카페24] 로그인하지 않은 사용자, REGISTERED: [카페24] 회원가입한 사용자, NOT_REGISTERED: [카페24] 회원가입한 사용자)',
    `visible`            tinyint(1)   NOT NULL DEFAULT 1 COMMENT '메시지 노출여부 (0: 비노출, 1: 노출)',
    `deleted`            tinyint(1)   NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0:삭제 안함, 1:삭제)',
    `start_time`         datetime(6)  NOT NULL COMMENT '메시지 유효기간 시작 일시',
    `end_time`           datetime(6)  NOT NULL COMMENT '메시지 유효기간 종료 일시',
    `created`            datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    `updated`            datetime(6)           DEFAULT NULL COMMENT '수정일시',
    PRIMARY KEY (`id`),
    KEY `FK_CTO_MSG_SITE_ID` (`site_id`),
    KEY `FK_CTO_MSG_CONTENT_ID` (`content_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- CTO 메시지 조건 테이블
CREATE TABLE `_cto_condition`
(
    `id`             int(11)     NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `cto_message_id` int(11)     NOT NULL COMMENT 'FK cto_message.id',
    `type`           varchar(50) NOT NULL COMMENT '조건 타입 (CtoConditionType 확인)',
    `type_value`     text DEFAULT NULL COMMENT '조건 타입에 따른 값 (JSON)',
    PRIMARY KEY (`id`),
    KEY `FK_CTO_CDT_CTO_MSG_ID` (`cto_message_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- 사용자 종속 기타 정보
CREATE TABLE `_extra_data`
(
    `id`             bigint(20)   NOT NULL AUTO_INCREMENT COMMENT 'PK. DB 레코드 식별 용이하게 하기 위한 필드. UK_EX_DATA_CATEGORY_KEY_SITE_ID 참고',
    `site_id`        bigint       NOT NULL COMMENT 'FK site.id',
    `extra_category` varchar(20)  NOT NULL COMMENT '데이터 카테고리. ExtraCategory enum 에 정의해서 사용',
    `extra_key`      varchar(200) NOT NULL COMMENT '데이터 키. ExtraKey enum 에 정의해서 사용',
    `extra_value`    text         NOT NULL COMMENT '데이터 Value',
    `persistent`     tinyint(1)   NOT NULL DEFAULT 1 COMMENT '데이터 지속 여부. (0: 임시 저장, 1: 영구 저장) 임시저장일 경우 스케줄러로 일정 시간 지나면 삭제됨',
    `created`        datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    `updated`        datetime(6)           DEFAULT NULL COMMENT '수정일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `UK_ED_CATEGORY_KEY_SITE_ID` (`extra_category`, `extra_key`, `site_id`),
    KEY `IDX_ED_PERSISTENT_UPDATED` (`persistent`, `updated`),
    KEY `FK_ED_SITE_ID` (`site_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

-- 통합 인증 정보
CREATE TABLE `_integration_auth`
(
    `id`                      int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `site_id`                 bigint                DEFAULT NULL COMMENT 'FK site.id',
    `provider`                varchar(20)  NOT NULL COMMENT '제공자',
    `operation`               varchar(20)  NOT NULL COMMENT '발급 목적',
    `status`                  varchar(20)  NOT NULL COMMENT '인증 상태 (TEMP: 코드 요청 단계, VERIFIED: 토큰 발급/확인 완료, EXPIRED: 토큰 만료)',
    `uuid`                    varchar(255) NOT NULL COMMENT '코드 응답시 유효성 확인 위한 고유 값',
    `access_token`            varchar(1000)         DEFAULT NULL COMMENT '엑세스 토큰',
    `refresh_token`           varchar(1000)         DEFAULT NULL COMMENT '리프레시 토큰',
    `access_token_expire_at`  datetime(6)           DEFAULT NULL COMMENT '엑세스 토큰 만료일시',
    `refresh_token_expire_at` datetime(6)           DEFAULT NULL COMMENT '리프레시 토큰 만료 일시',
    `extra_info`              text                  DEFAULT NULL COMMENT '제공자 별 추가 정보',
    `temp_info`               text                  DEFAULT NULL COMMENT 'OAuth 처리과정에서 사용되는 임시 정보',
    `last_verified_at`        datetime(6)           DEFAULT NULL COMMENT '마지막 유효성 확인 일시',
    `created`                 datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `UK_AUTH_UUID` (`uuid`),
    KEY `FK_IA_SITE_ID` (`site_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin COMMENT ='통합 인증 정보';

-- 기능 통합 정보
CREATE TABLE `_integration_feature`
(
    `id`                  int(11)     NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `site_id`             bigint      NOT NULL COMMENT 'FK site.id',
    `integration_auth_id` int(11)              DEFAULT NULL COMMENT 'FK integration_auth.id',
    `type`                varchar(30) NOT NULL COMMENT '연동 앱 타입',
    `extra_info`          text                 DEFAULT NULL COMMENT '앱 타입 별 추가 정보',
    `created`             datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    `updated`             datetime(6)          DEFAULT NULL COMMENT '컨텐츠 갱신 일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `_feature_uk` (`site_id`, `type`),
    KEY `FK_INTEGRATION_SITE_ID` (`site_id`),
    KEY `FK_INTEGRATION_AUTH_ID` (`integration_auth_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin COMMENT ='기능 통합 정보';

CREATE TABLE `_client_log_error`
(
    `id`               int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `trace_id`         varchar(100) NOT NULL COMMENT '로그 message ID',
    `site_id`          bigint       NOT NULL COMMENT 'site.id',
    `client_id`        varchar(100)          DEFAULT NULL COMMENT '클라이언트 ID, 프론트에서 cookie 로 관리',
    `is_new_client`    tinyint(1)   NOT NULL DEFAULT 0 COMMENT '클라이언트 ID (쿠키) 가 새로만들어진 경우',
    `action_type`      varchar(10)           DEFAULT NULL COMMENT '액션 타입 (VIEW: 뷰잉, CLICK: 클릭)',
    `action_target`    varchar(12)  NOT NULL COMMENT '액션 대상 (CARD, BUTTON_GROUP, SQUARE, CTO_MESSAGE)',
    `action_target_id` int(11)      NOT NULL COMMENT '액션 대상 ID',
    `ip`               varchar(15)           DEFAULT NULL COMMENT 'IP ADDRESS',
    `href`             text                  DEFAULT NULL COMMENT 'Request URL',
    `referer`          text COMMENT 'Request Referer origin data',
    `device_type`      varchar(10)           DEFAULT NULL COMMENT 'userAgent 기준 추출한 디바이스 타입',
    `user_agent`       text COMMENT 'Request userAgent origin data',
    `created`          datetime(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성일시',
    PRIMARY KEY (`id`),
    KEY `IDX_CLOG_USERID_IP_CREATED` (`site_id`, `ip`, `created`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin COMMENT ='통계 정보 생성 중 오류 발생한 로그';

-- 스케줄러 정보
CREATE TABLE `_scheduler`
(
    `id`               int(11)      NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `name`             varchar(100) NOT NULL COMMENT '이름',
    `job_uuid`         varchar(100) COMMENT 'task UUID',
    `disabled`         tinyint(1)   NOT NULL DEFAULT '0' COMMENT '사용 불가 여부(0: 사용 가능, 1: 사용 불가) ',
    `last_active_time` datetime(6)           DEFAULT NULL COMMENT '마지막 활성화 시간',
    PRIMARY KEY (`id`),
    UNIQUE KEY `_scheduler_pk` (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin COMMENT ='스케줄러 정보';

-- 스케줄러로그
CREATE TABLE `_scheduler_log`
(
    `id`           int(11)     NOT NULL AUTO_INCREMENT COMMENT 'PK',
    `scheduler_id` int(11)     NOT NULL COMMENT 'scheduler.Id ',
    `job_uuid`     varchar(100) COMMENT 'task UUID',
    `success`      tinyint(1)  NOT NULL DEFAULT '0' COMMENT '성공 여부(0: 실패, 1: 성공)',
    `error_msg`    text COMMENT '에러 메시지',
    `finished`     datetime(6) COMMENT '성공, 실패 일시',
    `created`      datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '생성 일자',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin COMMENT ='스케줄러 로그';

-- =================================================================================================================
-- TODO - TEMP#02 추후 삭제
