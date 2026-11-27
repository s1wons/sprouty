-- ********************************************************************************
-- Created new script by SIWON on 26. 11. 28.
-- This script file is for defining `local_db` DDL statements in RDBMS
-- ********************************************************************************

-- DML section...



-- 상위 업무 그룹 테이블 데이터 추가
insert into task_groups (
    name,
    sort,
    updated_at
) values (
    '기획 및 요구사항 분석',
    1,
    NOW()
);

insert into task_groups (
    name,
    sort,
    updated_at
) values (
    '설계',
    2,
    NOW()
);

insert into task_groups (
    name,
    sort,
    updated_at
) values (
    '구현',
    3,
    NOW()
);

insert into task_groups (
    name,
    sort,
    updated_at
) values (
    '테스트',
    4,
    NOW()
);

insert into task_groups (
    name,
    sort,
    updated_at
) values (
    '유지보수',
    5,
    NOW()
);