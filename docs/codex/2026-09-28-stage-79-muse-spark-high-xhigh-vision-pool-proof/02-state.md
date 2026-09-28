# State

- Current status: `ready-for-review`
- Last updated: 2026-09-28T11:35 Asia/Tehran
- Owner: Codex

## Current State
Vision واقعي PDF با raster صفحه 10 از يک PDF 11 صفحه‌اي ثابت شد: High و Xhigh هر دو `response.completed` با متن `PDFVISION:` دادند. Policy آفلاين به همان مسير واحده محدود مانده و text layer يا OCR استفاده نشده است. کار باقي‌مانده فقط همگام‌سازي docs/matrix و ثبت نهايي است.

## Decisions
| Date | Decision | Reason | Source |
|---|---|---|---|
| 2026-09-28 | فقط `oc/muse-spark-1.3-contributor-free` با `high` پيشفرض و `xhigh` صريح براي همه capabilityها | header صرف نيست؛ هر دو effort روي صفحه PDF واقعي کامل دادند | live SSE probes + TDD |
| 2026-09-28 | endpoint آفلاين `/v1/responses` ماند | مسير تأييدشده همان استریم Responses است | live probes |
| 2026-09-28 | بدون round-robin در کد؛ چرخش پروکسي با خود 9Router | کد نبايد ادعاي چرخش سراسري کند | code review |
| 2026-09-28 | تلاش Xhigh ناقص با `max_output_tokens=1800` receipt شد و با `4096` تکرار شد | `incomplete_details.reason=max_output_tokens` بود؛ سقف policy را اعمال کرد | logs/real-pdf-vision-high-1800.json |
| 2026-09-28 | `text_layer_read=false` و `ocr_used=false` براي هر پروب | pipeline مصنوعي و PDF خام با Vision جداست؛ PDF خام هرگز به مدل داده نشد | assets/real-pdf-vision-proof.json |

## Blockers
- None

## Done
- source PDF واقعي رندوم: `Lesson_1_Genome_and_Gene_Expression_Regulation_quiz_dark.pdf`.
- source hash ثبت شد: `4acf83aef76ce05908d4006bb54bf480fd462f81fcfe5ac46dabcc9d4bf29113`.
- صفحه 10 از 11 با render profile `PyMuPDF Matrix(1.6,1.6), PNG, alpha=false`.
- pixel hash ثبت شد: `0ad9fdfceab37b8dc6cfa9583624864415fc07de0fb7938e41ffadc3761bbcde`.
- probe صفحه مصنوعي `VISION:42` روي High و Xhigh کامل شد.
- probe صفحه واقعي: High در `21.06s` و Xhigh در `26.62s` کامل شد.
- usage واقعي ثبت شد؛ suite کامل gateway سبز بود (`Ran 68 tests ... OK`).

## Remaining
- همگام‌سازي `02-state.md`، `04-progress.md`، `05-verification.md`، `06-handoff.md`، `acceptance-matrix.md` و commit.
