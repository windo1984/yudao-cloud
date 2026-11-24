/*
 会员模块（member schema）主键序列补齐脚本
 PostgreSQL

 背景：
   member 模块的 DO 上都标注了 @KeySequence("member_<表>_seq")，
   MyBatis-Plus 在 PostgreSQL 下执行 insert 时会先 nextval('member_<表>_seq')。
   如果建表时用的是 identity / serial（库里只有 member_xxx_id_seq），
   这些 xxx_seq 就不存在，表现为：查询正常、任何新增/保存都报
   「系统异常」（后端日志为 relation "member_xxx_seq" does not exist）。

 使用前提：
   1. 已建好 member schema 及 member 模块各表；
   2. 执行连接使用 currentSchema=member（或 search_path 包含 member），
      否则 nextval('member_config_seq') 这种不限定 schema 的调用找不到序列。

 说明：
   脚本可重复执行：IF NOT EXISTS 保证序列不会重建，
   setval 会把序列对齐到该表当前 max(id)，避免与已有数据撞主键；
   表为空时序列从 1 开始（is_called = false，第一次 nextval 返回 1）。
*/

-- ----------------------------
-- member_address / MemberAddressDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_address_seq START 1;
SELECT setval('member.member_address_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_address), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_address), 0) > 0);

-- ----------------------------
-- member_brokerage_record / MemberBrokerageRecordDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_brokerage_record_seq START 1;
SELECT setval('member.member_brokerage_record_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_brokerage_record), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_brokerage_record), 0) > 0);

-- ----------------------------
-- member_config / MemberConfigDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_config_seq START 1;
SELECT setval('member.member_config_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_config), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_config), 0) > 0);

-- ----------------------------
-- member_experience_record / MemberExperienceRecordDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_experience_record_seq START 1;
SELECT setval('member.member_experience_record_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_experience_record), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_experience_record), 0) > 0);

-- ----------------------------
-- member_group / MemberGroupDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_group_seq START 1;
SELECT setval('member.member_group_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_group), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_group), 0) > 0);

-- ----------------------------
-- member_level / MemberLevelDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_level_seq START 1;
SELECT setval('member.member_level_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_level), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_level), 0) > 0);

-- ----------------------------
-- member_level_record / MemberLevelRecordDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_level_record_seq START 1;
SELECT setval('member.member_level_record_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_level_record), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_level_record), 0) > 0);

-- ----------------------------
-- member_point_record / MemberPointRecordDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_point_record_seq START 1;
SELECT setval('member.member_point_record_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_point_record), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_point_record), 0) > 0);

-- ----------------------------
-- member_sign_in_config / MemberSignInConfigDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_sign_in_config_seq START 1;
SELECT setval('member.member_sign_in_config_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_sign_in_config), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_sign_in_config), 0) > 0);

-- ----------------------------
-- member_sign_in_record / MemberSignInRecordDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_sign_in_record_seq START 1;
SELECT setval('member.member_sign_in_record_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_sign_in_record), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_sign_in_record), 0) > 0);

-- ----------------------------
-- member_tag / MemberTagDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_tag_seq START 1;
SELECT setval('member.member_tag_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_tag), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_tag), 0) > 0);

-- ----------------------------
-- member_user / MemberUserDO
-- ----------------------------
CREATE SEQUENCE IF NOT EXISTS member.member_user_seq START 1;
SELECT setval('member.member_user_seq',
              GREATEST(COALESCE((SELECT MAX(id) FROM member.member_user), 0), 1),
              COALESCE((SELECT MAX(id) FROM member.member_user), 0) > 0);
