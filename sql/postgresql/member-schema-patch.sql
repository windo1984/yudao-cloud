/*
 会员模块（member schema）表结构修正脚本
 PostgreSQL

 背景：
   member 模块的 VO 把「等级图标 icon」「等级背景图 backgroundUrl」「分组备注 remark」
   定义为可选字段（只有 @URL 格式校验，没有 @NotNull），但部分环境建表时这三列被设成了
   NOT NULL，导致新增/保存时报：
     null value in column "icon" of relation "member_level" violates not-null constraint
   （前端表现为「系统异常」）。

 说明：
   ALTER COLUMN ... DROP NOT NULL 可重复执行，不会影响已有数据。
   如果你们的建表脚本已经允许为空，本脚本执行后不会有任何变化。
*/

ALTER TABLE member.member_level ALTER COLUMN icon DROP NOT NULL;
ALTER TABLE member.member_level ALTER COLUMN background_url DROP NOT NULL;
ALTER TABLE member.member_group ALTER COLUMN remark DROP NOT NULL;
