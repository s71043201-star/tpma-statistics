-- 2026-11-13 在 Supabase SQL Editor 執行。
-- 儀表板「各診所待發禮券」的民眾名單下載(↓ 名單 / ↓ 全部名單 ZIP)依使用者決定不設權限:
-- 未登入(anon)也能送出、輪詢、取回、刪除「voucher:」開頭的佇列請求。
-- 其他請求(診所處方紀錄下載)維持原本的權限,不受影響(policy 是 OR 疊加,只放寬 voucher:)。
-- 後端 clinic_export_poll.py 對 voucher: 請求不檢查下載密碼。

drop policy if exists cer_voucher_anon_insert on public.clinic_export_requests;
drop policy if exists cer_voucher_anon_select on public.clinic_export_requests;
drop policy if exists cer_voucher_anon_delete on public.clinic_export_requests;

create policy cer_voucher_anon_insert on public.clinic_export_requests
  for insert to anon
  with check (clinic_name like 'voucher:%' and status = 'pending' and result_b64 is null);

create policy cer_voucher_anon_select on public.clinic_export_requests
  for select to anon
  using (clinic_name like 'voucher:%');

create policy cer_voucher_anon_delete on public.clinic_export_requests
  for delete to anon
  using (clinic_name like 'voucher:%');
