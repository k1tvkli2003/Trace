# Trace implementation

- Task ID: `2026-09-22-trace-implementation`
- Status: `active`
- Created: 2026-09-22
- Language: fa

## Request
اجرای مرحله به مرحله پلن ۳۰ مرحله ای Trace: یادگیری منبع محور کتاب در Flutter برای Android/Windows/Web؛ شروع از baseline واقعی.

## Success Criteria
- Gate هر مرحله فقط با artifact و تست واقعی بسته شود.
- در پایان flow منبع واقعی، Vision بدون OCR، باکس فارسی، مرور cache، annotation و sync دو دستگاه اثبات شود.
- هیچ build یا قابلیت انجام نشده، انجام شده گزارش نشود.

## Context
پلن اصلی در `.hermes/plans/2026-09-22_223024-trace-learning-agent.md` است. ریپو در آغاز جز پلن خالی بود. `StudyHub-Web` فقط مرجع read-only است.

## In Scope
Stageهای ۱ تا ۳۰، به ترتیب وابستگی ها؛ همین checkpoint: baseline و scaffold.

## Out of Scope
انتشار، نصب production، دریافت credentials، تغییر StudyHub-Web، انتخاب مدل جایگزین. جهت غیرآیکونی UI بدون درخواست تأیید مجدد انتخاب می‌شود.

## Assumptions
`Trace` نام نهایی محصول و ریپو است. generated `com.example` صرفا شناسه توسعه است، نه release identity.
