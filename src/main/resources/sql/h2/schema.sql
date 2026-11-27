-- ********************************************************************************
-- Created new script by SIWON on 26. 11. 28.
-- This script file is for defining `local_db` DDL statements in RDBMS
-- ********************************************************************************

-- DDL section...



-- '사용자'
drop table if exists users cascade;
create table if not exists users (
	id					int					not null auto_increment comment '사용자번호',
	email				varchar(55)			not null comment '이메일',
	nickname			varchar(25)			not null comment '닉네임',
	name				varchar(20)			not null comment '이름',
	login_type			varchar(5)			not null comment '로그인 유형',
	is_enabled			char(1)				not null default 'Y' comment '계정 활성화 여부',
	deleted_yn			char(1)				not null default 'N' comment '계정 삭제 여부',
	created_at			datetime			not null default current_timestamp comment '계정 생성 일시',
	updated_at			datetime			not null comment '계정 변경 일시',
	deleted_at			datetime			null comment '계정 삭제 일시',
	primary key (id),
	unique key (email),
	unique key (nickname)
);



-- '로컬 사용자 비밀번호'
drop table if exists user_passwords cascade;
create table if not exists user_passwords (
	user_id				int					not null comment '사용자 번호',
	password			varchar(255)		not null comment '비밀번호',
	updated_at			datetime			not null comment '비밀번호 변경 일시',
	primary key (user_id),
	foreign key (user_id) references users (id)
);



-- '소셜 인증 정보'
drop table if exists user_oauths cascade;
create table if not exists user_oauths (
	id					int					not null auto_increment comment '소셜 인증 번호',
	user_id				int					not null comment '사용자 번호',
	provider			varchar(20)			not null comment '소셜 인증 플랫폼 명',
	provider_id			varchar(255)		not null comment '소셜 인증 플랫폼별 제공 고유 식별자',
	created_at			datetime			not null default current_timestamp comment '생성 일시',
	primary key (id),
	unique key (provider, provider_id),
	foreign key (user_id) references users (id)
);



-- '사용자별 권한 매핑'
drop table if exists user_roles cascade;
create table if not exists user_roles (
	user_id				int					not null comment '사용자 번호',
	role				varchar(25)			not null comment '권한명',
	primary key (user_id, role),
	foreign key (user_id) references users (id)
);



-- '프로필'
drop table if exists profiles cascade;
create table if not exists profiles (
	id					int					not null auto_increment comment '프로필 번호',
	user_id				int					not null comment '사용자 번호',
	profile_img_url		varchar(255)		null comment '프로필 이미지 저장 경로',
	bio					varchar(150)		null comment '한 줄 소개',
	univ				varchar(50)			null comment '대학명',
	site_url			varchar(255)		null comment '개인 사이트 주소',
	github_url			varchar(255)		null comment '개인 깃허브 주소',
	updated_at			datetime			not null comment '프로필 변경 일시',
	primary key (id),
	foreign key (user_id) references users (id),
	unique key (user_id)
);



-- '로그인 이력'
drop table if exists login_histories cascade;
create table if not exists login_histories (
	id					int					not null auto_increment comment '이력 번호',
	user_id				int					not null comment '사용자 번호',
	ip_address			varchar(45)			not null comment '아이피 주소',
	device				varchar(20)			not null comment '로그인 기기 유형',
	os					varchar(50)			not null comment '로그인 운영체제',
	browser				varchar(50)			not null comment '로그인 브라우저',
	login_at			datetime			not null comment '로그인 일시',
	primary key (id),
	foreign key (user_id) references users (id)
);



-- '팀 정보'
drop table if exists teams cascade;
create table if not exists teams (
	id					int					not null auto_increment comment '팀 번호',
	name				varchar(100)		not null comment '팀명',
	introduction		varchar(150)		null comment '팀 소개',
	deleted_yn			char(1)				not null default 'N' comment '팀 삭제 여부',
	created_by			int					not null comment '팀 생성자 번호',
	created_at			datetime			not null default current_timestamp comment '팀 생성 일시',
	updated_at			datetime			not null comment '팀 정보 변경 일시',
	deleted_at			datetime			null comment '팀 삭제 일시',
	primary key (id),
	foreign key (created_by) references users (id)
);



-- '팀원'
drop table if exists team_users cascade;
create table if not exists team_users (
	team_id				int					not null comment '팀 번호',
	user_id				int					not null comment '사용자 번호',
	is_captain			char(1)				not null default 'N' comment '팀장 여부',
	created_at			datetime			not null default current_timestamp comment '팀원 생성 일시',
	updated_at			datetime			not null comment '팀원 변경 일시',
	primary key (team_id, user_id),
	foreign key (team_id) references teams (id),
	foreign key (user_id) references users (id)
);



-- '상위 업무 그룹'
drop table if exists task_groups cascade;
create table if not exists task_groups (
	id					int					not null auto_increment comment '그룹 번호',
	name				varchar(50)			not null comment '그룹명',
	used_yn				char(1)				not null default 'Y' comment '사용 여부',
	sort				int					not null default 0 comment '화면 정렬 번호',
	created_at			datetime			not null default current_timestamp comment '그룹 생성 일시',
	updated_at			datetime			not null comment '그룹 변경 일시',
	primary key (id)
);



-- '프로젝트 정보'
drop table if exists projects cascade;
create table if not exists projects (
	id					int					not null auto_increment comment '프로젝트 번호',
	name				varchar(100)		not null comment '프로젝트명',
	summary				varchar(200)		not null comment '프로젝트 소개글',
	team_id				int					not null comment '팀 번호',
	user_id				int					not null comment '프로젝트 관리자 번호',
	start_date			date				not null comment '시작일',
	end_date			date				not null comment '종료일',
	status				char(1)				not null comment '진행 상태',
	deleted_yn			char(1)				not null default 'N' comment '프로젝트 정보 삭제 여부',
	created_at			datetime			not null default current_timestamp comment '프로젝트 생성 일시',
	updated_at			datetime			not null comment '프로젝트 변경 일시',
	deleted_at			datetime			null comment '프로젝트 삭제 일시',
	primary key (id),
	foreign key (team_id) references teams (id),
	foreign key (user_id) references users (id)
);



-- '프로젝트 업무'
drop table if exists tasks cascade;
create table if not exists tasks (
	id					int					not null auto_increment comment '업무 번호',
	project_id			int					not null comment '프로젝트 번호',
	parent_task_id		int					null comment '상위 업무 번호',
	name				varchar(250)		not null comment '업무명',
	start_date			date				not null comment '시작일',
	end_date			date				not null comment '종료일',
	actual_end_date		date				null comment '실제 종료일',
	status				char(1)				not null comment '진행 상태',
	rate				int					not null default 0 comment '진행률',
	sort				int					not null default 0 comment '화면 정렬 번호',
	created_at			datetime			not null default current_timestamp comment '업무 생성 일시',
	updated_at			datetime			not null comment '업무 변경 일시',
	primary key (id),
	foreign key (project_id) references projects (id)
);



-- '프로젝트 업무 할당'
drop table if exists task_assignments cascade;
create table if not exists task_assignments (
	task_id				int					not null comment '업무 번호',
	user_id				int					not null comment '담당자 번호',
	primary key (task_id, user_id),
	foreign key (task_id) references tasks (id),
	foreign key (user_id) references users (id)
);



-- '프로젝트 체크 리스트'
drop table if exists task_entries cascade;
create table if not exists task_entries (
	id					int					not null auto_increment comment '리스트 번호',
	task_id				int					not null comment '프로젝트 업무 번호',
	user_id				int					not null comment '담당자 번호',
	content				varchar(300)		not null comment '체크 리스트 항목 내용',
	is_completed		char(1)				not null default 'N' comment '완료 여부',
	created_at			datetime			not null default current_timestamp comment '체크 리스트 항목 생성 일시',
	updated_at			datetime			not null comment '체크 리스트 항목 변경 일시',
	primary key (id),
	foreign key (task_id) references tasks (id),
	foreign key (user_id) references users (id)
);



-- '프로젝트 업무 산출물'
drop table if exists task_attachments cascade;
create table if not exists task_attachments (
	id					int					not null auto_increment comment '산출물 번호',
	task_id				int					not null comment '프로젝트 업무 번호',
	user_id				int					not null comment '작성자 번호',
	attachment_type     varchar(15)         not null comment '산출물 유형',
    original_name       varchar(250)        not null comment '파일 원본명',
    saved_path          varchar(255)        not null comment '저장 경로',
    saved_name          varchar(255)        not null comment '저장명',
    extension           varchar(10)         not null comment '확장자명',
    file_size           int                 not null comment '파일 크기',
	deleted_yn			char(1)				not null default 'N' comment '산출물 삭제 여부',
	created_at			datetime			not null default current_timestamp comment '산출물 생성 일시',
	updated_at			datetime			not null comment '산출물 변경 일시',
	deleted_at			datetime			null comment '산출물 삭제 일시',
	primary key (id),
	foreign key (task_id) references tasks (id),
	foreign key (user_id) references users (id)
);



-- '이슈'
drop table if exists issues cascade;
create table if not exists issues (
	id					int					not null auto_increment comment '이슈 번호',
	task_id				int					not null comment '프로젝트 업무 번호',
	reporter_id			int					not null comment '이슈 등록자 번호',
	assignee_id			int					not null comment '이슈 담당자 번호',
	title				varchar(200)		not null comment '이슈 제목',
	content				text				not null comment '이슈 내용',
	status				varchar(8)			not null comment '처리 상태',
	resolved_at			datetime			null comment '처리 일시',
	created_at			datetime			not null default current_timestamp comment '이슈 생성 일시',
	updated_at			datetime			not null comment '이슈 변경 일시',
	primary key (id),
	foreign key (task_id) references tasks (id),
	foreign key (reporter_id) references users (id),
	foreign key (assignee_id) references users (id)
);



-- '알림'
drop table if exists notifications cascade;
create table if not exists notifications (
	id					int					not null auto_increment comment '알림 번호',
	task_id				int					not null comment '프로젝트 업무 번호',
	receiver_id			int					not null comment '알림 수신자',
	content				varchar(200)		not null comment '알림 내용',
	target_url			varchar(255)		null comment '알림 대상 접속 경로',
	is_read				char(1)				not null default 'N',
	created_at			datetime			not null default current_timestamp comment '알림 생성 일시',
	updated_at			datetime			not null comment '알림 변경 일시',
	primary key (id),
	foreign key (task_id) references tasks (id),
	foreign key (receiver_id) references users (id)
);