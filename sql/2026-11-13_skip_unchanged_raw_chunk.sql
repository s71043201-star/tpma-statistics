-- 2026-11-13 已在 Supabase SQL Editor 執行。
-- 背景:n8n 每次同步都把全部 raw_rows 分片(main:rows:NNN,每片約 150KB)整片覆寫,
-- 加上儀表板每次版本簽章一變就整包重抓,把免費方案的 Disk IO 預算耗盡,
-- 2026-11-13 早上 09:30 同步後整台 504 / statement timeout(57014),最後 521/522。
-- 這個 trigger 讓內容沒變的分片直接跳過更新:不產生新版本、不寫 WAL,
-- uploaded_at 也維持原值,前端(fetchCloudHeavy)就只會重抓有變的分片。
create or replace function public.skip_unchanged_raw_chunk() returns trigger
language plpgsql as $fn$
begin
  if new.id like 'main:rows:%' and new.raw_rows is not distinct from old.raw_rows then
    return null;
  end if;
  return new;
end
$fn$;

drop trigger if exists skip_unchanged_raw_chunk on public.prescription_data;
create trigger skip_unchanged_raw_chunk
  before update on public.prescription_data
  for each row execute function public.skip_unchanged_raw_chunk();

-- 同時清理:卡在 running/pending 超過一天的 sync_requests 標成 error(共 32 筆,未刪除)
-- update public.sync_requests set status='error', finished_at=now(),
--        error_message='stale: 2026-11-13 清理卡住的舊請求'
--  where status in ('running','pending') and requested_at < now() - interval '1 day';
