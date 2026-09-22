# Trace Learning Agent Implementation Plan

> **For Hermes:** Use subagent-driven-development skill to implement this plan task-by-task.

**Goal:** ساخت یک محیط شخصی، آفلاین‌محور و چندسکویی شبیه Codex برای تبدیل کتاب‌های طولانی به مسیر یادگیری تعاملی، کم‌هزینه، منبع‌محور و قابل مرور.

**Architecture:** یک monorepo با Flutter برای Android، Windows و Web/PWA؛ معماری MVVM با View/ViewModel/Repository/Service؛ دیتابیس local-first با Drift؛ همگام‌سازی خصوصی با Supabase/Postgres/Storage؛ و AI Gateway سروریِ provider-neutral برای Vision، ساختاردهی، تولید درس و ابزارهای agent. محتوای خام، صفحات پردازش‌شده، تصاویر، نقشه درختی، lesson boxها، هایلایت‌ها، نوت‌ها و schedule مرور همگی ID، hash، version و provenance مستقل دارند.

**Tech Stack:** Flutter/Dart، Riverpod یا معادل repository-native، Drift/SQLite روی Android و Windows، Drift Web با WASM/OPFS و fallback IndexedDB، **Supabase Auth/Postgres/Storage با RLS در کنار local-first**، Edge Function/API Gateway، worker جدا برای ingestion طولانی، JSON Schema، Playwright/Flutter integration tests، golden tests، و provider adapter سازگار با OpenAI API. نسخه دقیق Flutter و packageها باید در Stage 1 از محیط واقعی pin شود؛ ادعای build قبل از آن ممنوع.

**Product/repository name:** `Trace`؛ نام قطعی انتخاب شده توسط کاربر. آیکون نهایی از فایل انتخابی کاربر در `assets/brand/trace-icon-selected.webp` تثبیت شده است (SHA-256: `08e7164d43c3b37f4622f8c001f24eb555c20334ea252153be93fb775232c942`).

---

## 0. وضعیت و مرز این سند

این سند قرارداد اجرایی زنده است؛ اجرای Stageها مستقل از اصلاح اصطلاحات/تأکیدهای قرارداد ادامه می‌یابد. `StudyHub-Web` فقط reference و بدون mutation است. پیشرفت تنها با artifact و آزمون واقعی سنجیده می‌شود.

### قوانین غیرقابل‌مذاکره

- **Product UI is English-only:** app chrome, navigation, buttons, settings, status labels, errors, notifications, app metadata and accessibility labels use English. **Model chat and lessons are Persian:** default user/model conversation and Lesson AST content are Persian; source quotations retain original script. English UI stays LTR; Persian chat/lesson containers are RTL; mixed English terms, numbers, citations and formulas have explicit bidi isolation. Do not translate user/source text as UI chrome.
- کاربر فعلاً تنها مصرف‌کننده است؛ multi-user، social، marketplace و public sharing در MVP نیست.
- پلتفرم‌های اصلی: Android، Windows، Web/PWA. iOS/macOS در scope نیست.
- UI مشترک Flutter؛ native فقط برای capabilityهایی که واقعاً platform-specific هستند: file picker، notifications، background lifecycle، secure storage، window integration و browser APIs.
- **OCR مطلقاً در pipeline اجرا نمی‌شود.** متن هر PDF، چه اسکن‌شده چه دارای text layer، با Vision از تصویر صفحه استخراج و با صفحهٔ مرجع بازبینی می‌شود؛ text layer/bookmark فقط سرنخ ساختار و جست‌وجوی candidate است، نه متن پذیرفته‌شدهٔ درس. Markdown و فایل‌های متنیِ ساختاریافته با parser مستقیم خوانده می‌شوند، نه Vision.
- API key هیچ‌وقت وارد Flutter bundle، APK، Windows package، Web build، log یا DB client-visible نمی‌شود.
- HTML خام تولیدشده توسط LLM مستقیماً render نمی‌شود؛ AI یک Lesson AST تایپ‌شده می‌دهد و Flutter renderer آن را به boxهای امن تبدیل می‌کند.
- AI مجاز به SQL یا mutation مستقیم نیست؛ فقط typed tool call با allowlist، validation، authorization و idempotency.
- صفحه‌ای که قبلاً vision شده دوباره vision نمی‌شود مگر hash، render profile، prompt version یا مدل تغییر کرده باشد.
- Spaced repetition با scheduler قطعی شروع می‌شود؛ AI در schedule پایه دخالت ندارد.
- هیچ ادعای accuracy علمی بدون citation و source span پذیرفته نیست.
- AvalAI و OpenHUB در این پروژه استفاده نمی‌شوند. اجرای تمام capabilityها در این پروژه با **همان مدل شخصی مجاز کاربر** از gateway مورد تأیید او انجام می‌شود؛ `structure_scan`، `page_vision_extract` و `teacher_fa` نام pipeline هستند، نه مجوز انتخاب مدل ارزان یا provider دیگر. هرگونه تغییر مدل فقط با دستور جدید کاربر. سازگاری Vision و هزینه همان route باید در یک pilot واقعی اثبات شود.
- نام repo، app، packageها، شناسه‌های درون‌برنامه‌ای و سندها `Trace` است؛ نام‌های تاریخی در محصول جدید نباید باقی بمانند.
- Gamification باید ارزش آموزشی قابل مشاهده داشته باشد: پیشرفت map، بازخورد فهم، milestoneهای واقعی و مرور؛ private و بدون فشار streak، قفل انرژی، پاداش برای tap/زمان منفعل، league/social یا اقتصاد شانس‌محور در MVP. قواعد از `ReviewEvent`/`LearnerState` و idempotent event ledger مشتق شوند؛ sync دوباره پاداش ندهد.

---

## 1. شواهد فعلی و تصمیم‌های پایه

### شواهد repository

`C:/Users/K1/Desktop/Projects/StudyHub-Web` فقط reference است؛ وضعیت Git آن با `git status --porcelain=v1` بررسی شد و تغییرات modified/untracked/deleted در محتوای کاربر همراه با هشدار `Filename too long` دیده شد. هیچ‌کدام نباید reset، پاک یا overwrite شوند. این پلن در یک مسیر مستقل ذخیره می‌شود.

الگوهای قابل استفاده:

- `types.ts`: مدل‌های `ContentType` شامل `IMPORTANT`، `CLINICAL_PEARL`، `MECHANISM`، `IMAGE`، `IMAGE_EXPLANATION`، `COMPARISON_TABLE`، `SUMMARY_BOX`، `TAKEAWAY` و `MNEMONIC`.
- `CourseNode` و `courseTree.ts`: درخت سلسله‌مراتبی، first chapter و next chapter.
- `ContentBlockRenderer.tsx`: boxهای رنگی، RTL، image explanation، table و mechanism.
- `src/features/tools/highlights/types.ts`: highlight با متن واقعی برای verification.
- `src/services/userDataSync.ts`: local persistence، Supabase sync، notes، highlights، lesson states، pending sync و offline/error states.
- `lastReading.ts`: resume position و reading history.
- `package.json`: React/Vite/Tailwind/Framer Motion/KaTeX/Supabase/Playwright؛ vocabulary و visual patterns، نه codebase قابل کپی مستقیم.

### شواهد رسمی جاری

- Flutter architecture guide، MVVM و جداسازی View، ViewModel، Repository و Service را توصیه می‌کند: <https://docs.flutter.dev/app-architecture/guide>
- Flutter پشتیبانی native برای Windows و plugin/native integration دارد: <https://docs.flutter.dev/platform-integration/desktop>
- Drift برای Flutter Web مسیر WASM و storage بر پایه File System Access/IndexedDB دارد، با caveat چندتب و browser compatibility: <https://drift.simonbinder.eu/platforms/web>
- Supabase برای هر table در exposed schema، RLS و policy مالکیت لازم می‌داند: <https://supabase.com/docs/guides/database/postgres/row-level-security>

این منابع فقط معماری را راهنمایی می‌کنند؛ نسخه و قابلیت هر dependency در زمان اجرا باید دوباره از docs و محیط واقعی verify شود.

---

## 2. تعریف تجربه محصول

### نام تجربه اصلی: `Learning Workbench`

سه سطح ثابت:

1. **Library Rail:** کتاب‌ها، وضعیت ingestion، آخرین مطالعه، review due و cost snapshot.
2. **Knowledge Worktree:** درخت Parts → Chapters → Sections → Concepts → Learning Slices؛ شبیه work tree، اما با progress، lock، source coverage و due state.
3. **Teaching Stage:** chat + lesson box؛ هر پیام آموزشی یک artifact قابل مشاهده، citationدار، قابل mark، highlight، note، review و ادامه است.

روی Windows سه ستون؛ روی Web با responsive collapse؛ روی Android drawer برای Worktree و bottom action dock برای actionهای اصلی.

**شروع و ادامه:** هر کتاب/گره دو affordance روشن دارد: `شروع آموزش`، که بدون پیام تایپی نخستین slice همان گره را می‌سازد یا از cache باز می‌کند؛ و composer چت برای سؤال یا دستور آزاد. default روی اولین فصل واقعی است، نه پیش‌گفتار/فهرست مگر کاربر انتخاب کند؛ انتخاب هر گره در Worktree همین قرارداد را از anchor آن گره اجرا می‌کند. `باکس بعدی` باید از cursor پایدار ادامه دهد و برای یک slice تولیدشده دوباره پول نگیرد. انتخاب «نحوه آموزش» (عمق، محاوره، ایموجی، مثال، مقدار سؤال) تنظیم کاربر است، نه دستور بی‌ردپا به مدل.

### مسیر اصلی کاربر

```text
Import book/folder
  -> immutable manifest/hash
  -> cheap structure scan
  -> source tree proposal
  -> user approve/edit
  -> page/block cache
  -> slice plan
  -> teacher box
  -> study status
  -> review queue
  -> highlight/note/chat actions
  -> sync across devices
```

### حالت‌های lesson

- `NOT_STARTED`: هنوز شروع نشده.
- `IN_PROGRESS`: بخشی دیده شده.
- `STUDIED`: باکس خوانده شده.
- `NOT_LEARNED`: کاربر فهم را رد کرده یا کمک خواسته.
- `REVIEW_DUE`: **projection نمایشی** از ReviewItem با dueAt <= اکنون؛ هرگز status جایگزین `STUDIED` نمی‌شود.
- `MASTERED`: طبق rule کاربر/مرور تثبیت شده.
- `SKIPPED`: عمداً رد شده، نه حذف.

---

## 3. Opinion Ledger طراحی

| سطح | تصمیم | دلیل |
|---|---|---|
| KEEP | چت agentمحور شبیه Codex | interaction اصلی باید گفتگو + اقدام باشد، نه فقط reader |
| KEEP | درخت سلسله‌مراتبی | کتاب طولانی بدون wayfinding فرسایشی است |
| KEEP | vocabulary باکس‌های StudyHub | کاربر قبلاً با `IMPORTANT`، `MECHANISM` و `IMAGE_EXPLANATION` نتیجه گرفته |
| REFINE | Course tree به Knowledge Worktree | node باید source، slice، progress و review state هم داشته باشد |
| REFINE | localStorage/Supabase pattern | برای Flutter باید local DB، oplog و conflict contract بیاید |
| REFINE | offset highlight | offset تنها شکننده است؛ quote، source block، hash و bbox اضافه می‌شود |
| REDESIGN | ingestion | از import مستقیم به manifest → scan → vision cache → planner تبدیل شود |
| REDESIGN | lesson output | از raw HTML/string به Lesson AST تایپ‌شده و renderer مشترک تبدیل شود |
| REDESIGN | AI context | به‌جای فرستادن کتاب، فقط slice و lookahead contract ارسال شود |
| REDESIGN | AI database access | مدل فقط typed tools را پیشنهاد دهد؛ domain service تصمیم بگیرد |
| ADD | provenance panel | هر ادعا باید به page/block/figure وصل باشد |
| ADD | page vision cache | جلوگیری از vision تکراری و کنترل هزینه |
| ADD | slice cursor | باکس بعدی از نقطه درست ادامه یابد |
| ADD | review inbox | مرورهای due بدون generation دوباره |
| ADD | cost ledger | هزینه هر import، vision، lesson و retry قابل مشاهده باشد |
| ADD | offline-first sync | مطالعه و annotation بدون شبکه متوقف نشود |
| REMOVE | client-side secret | ریسک امنیتی غیرقابل قبول |
| REMOVE | arbitrary LLM HTML/CSS | XSS، drift بین platformها و layout شکننده |
| REMOVE | vision دوباره برای هر box | هزینه و latency بی‌دلیل |
| ADD | پیشرفت یادگیری و milestoneهای private و قابل اثبات | حس کشف و تسلط بدون تحریف حلقه آموزشی |
| BACKLOG | social، league، shop، energy/hearts و اقتصاد شانس‌محور | محصول فعلاً شخصی است؛ فشار یا انگیزه کاذب ممنوع |

---

## 4. مدل داده canonical

این مدل باید در `packages/trace_domain/lib/src/` تعریف شود و API، DB و Flutter از آن codegen/schema بگیرند.

### موجودیت‌های منبع

- `LibraryItem`: کتاب/پروژه؛ title، language، ownerId، defaultNodeId، createdAt.
- `SourceDocument`: فایل یا folder logical؛ `sourceHash`، MIME، relativePath، byteSize، importVersion.
- `SourcePage`: pageId، documentId، pageNumber، pixelHash، renderProfile، thumbnailPath، visionStatus.
- `SourceBlock`: blockId، pageId، order، kind، rawText، normalizedText، bbox، sourceHash.
- `FigureAsset`: figureId، pageId، bbox، assetHash، caption، altText، reviewStatus.
- `SourceCitation`: sourceBlock/page/figure references، quote، locator، confidence، extractionVersion.

### موجودیت‌های ساختار و یادگیری

- `KnowledgeNode`: id، parentId، order، kind، title، sourceRange، confidence، userOverride.
- `LearningSlice`: id، nodeId، order، sourceBlockIds، pageIds، conceptIds، estimatedEffort، boundaryReason.
- `SliceCursor`: libraryId، nodeId، currentSliceId، nextBlockIndex، nextPageNumber، lookaheadState، plannerVersion.
- `LessonArtifact`: sliceId، version، contentHash، lessonAstJson، citationIds، modelProfile، promptVersion، createdAt.
- `LessonBlock`: id، type، semanticText، children، sourceCitationIds، figureId، reviewEligible.
- `LearnerState`: lesson/slice status، confidence، lastReadAt، lastActionAt، userFlags.

### annotation و مرور

- `HighlightAnchor`: quote، prefix، suffix، sourceBlockId، pageId، start/end، bbox، `contentHashAtCreation`، lessonBlockId، color.
- `StudyNote`: noteId، anchorId/lessonBlockId، body، pinned، createdAt، updatedAt.
- `ReviewItem`: targetType، targetId، dueAt، intervalDays، ease، lapses، state، schedulerVersion.
- `ReviewEvent`: append-only؛ rating، occurredAt، previousSchedule، nextSchedule، deviceId.
- `ChatThread` و `ChatMessage`: user/agent/tool messages، target context، source references.
- `ToolInvocation`: toolName، argsJson، validationResult، idempotencyKey، mutationId، result.
- `SyncOperation`: operationId، entityType، entityId، mutationType، payload، localVersion، syncState، retryCount.
- `AiRunLedger`: runId، capability، inputHashes، modelProfile، promptVersion، token/cost metadata، latency، outcome.

### invariantهای مهم

- `sourceHash` immutable؛ تغییر فایل یعنی SourceDocument جدید.
- `LessonArtifact` immutable؛ regenerate یعنی version جدید، نه overwrite بی‌ردپا.
- `ReviewEvent` append-only؛ schedule از eventها قابل بازسازی باشد.
- حذف annotation tombstone دارد؛ delete روی یک device نباید در sync برگردد.
- همه timeها UTC ذخیره و در UI به timezone کاربر نمایش داده می‌شوند.
- source quote هرگز بدون locator و hash ذخیره نمی‌شود.

---

## 5. قرارداد AI و صرفه‌جویی هزینه

### capability profileها

capabilityها قراردادهای منطقی متفاوت‌اند، نه مدل‌های متفاوت؛ همه با route شخصی مجاز کاربر کار می‌کنند. prompt، schema، بودجهٔ ورودی و cache هر capability مستقل است:

- `structure_scan`: کم‌هزینه، خروجی JSON؛ ورودی contact sheet و metadata.
- `page_vision_extract`: Vision؛ خروجی SourceBlock/Figure/Citation؛ فقط pageهای لازم.
- `slice_planner`: متن/cache موجود؛ تعیین مفهوم، مرز، ترتیب و lookahead.
- `teacher_fa`: تولید Lesson AST فارسی؛ ورودی slice محدود + figures + compact learner context.
- `coach`: پاسخ به سؤال کاربر با source citations؛ بدون تولید مجدد کل درس.
- `review_generator_optional`: فقط اگر card جدید خواسته شد؛ MVP می‌تواند deterministic باشد.

### prompt envelope

هر call این بخش‌ها را جدا دارد:

```json
{
  "instructionVersion": "teacher-fa-v1",
  "trustedPolicy": "...",
  "userPreference": {"tone":"warm-conversational", "emoji":"moderate"},
  "sourceContext": [{"sourceBlockId":"...", "text":"...", "page":12}],
  "figures": [{"figureId":"...", "assetUrl":"...", "caption":"..."}],
  "learnerContext": {"status":"IN_PROGRESS", "knownTerms":[]},
  "task": {"sliceId":"...", "mode":"teach"},
  "outputSchema": "lesson-ast-v1"
}
```

منبع، user text و tool result با delimiter و provenance جدا می‌شوند. محتوای کتاب instruction نیست؛ data است. Prompt injection داخل کتاب نباید policy را تغییر دهد.

### pipeline دقیق PDF

1. hash فایل و ساخت manifest؛ original immutable و قابل بازیابی بماند.
2. شمارش page و استخراج bookmark/text-layer بدون OCR؛ فقط metadata کمکی، نه transcription نهایی PDF.
3. render thumbnail کم‌حجم برای pageها به‌صورت batch/checkpoint؛ کتاب بزرگ به‌خاطر ساخت همه تصویرها upfront قفل نشود.
4. ساخت contact sheetهای grid با page label در batchهای محدود؛ قبل از Vision الگویی، outline، نام فایل و فهرست را برای candidate کم‌هزینه بررسی کن.
5. `structure_scan` فقط grid + metadata می‌گیرد و candidate boundary می‌دهد؛ مناطق مبهم با صفحهٔ high-res محدود تأیید یا رد می‌شوند، نه یک دور Vision روی کل کتاب.
6. pageهای boundary و چند page همسایه high-res render می‌شوند.
7. `page_vision_extract` **هر صفحهٔ واقعاً دیده‌شده را کامل** به ترتیب خواندن، پاراگراف، heading، جدول، فرمول، caption، footnote و تمام شکل‌های مرتبط استخراج می‌کند؛ خروجی page-complete با coverage ledger و uncertainty flag ثبت می‌شود. هرگز فقط دو پاراگراف آن صفحه را cache نکن.
8. `FigureAsset` از crop دقیق ناحیهٔ صفحه یا asset اصلی PDF در صورت حفظ fidelity ساخته می‌شود؛ برای دیاگرام vector-assembled از crop صفحه استفاده کن. bbox normalized، caption، figureHash، pageHash، اندازهٔ خروجی و رابطهٔ آن با SourceBlock ثبت شود؛ thumbnail به‌جای شکل کامل در درس استفاده نشود.
9. اگر boundary تأیید شد، SourceBlockهای cacheشده ذخیره می‌شوند؛ اگر رد شد، scan بعدی با evidence محدود انجام می‌شود.
10. planner، sliceهای آینده و `nextVisionRequiredAt` را ثبت می‌کند؛ ورودی teacher در شروع معمولاً **۲ تا ۳ پاراگراف منسجم** از صفحهٔ اول/دوم انتخاب‌شده + فقط شکل‌های همان مفهوم است؛ تعداد صفحه یا پاراگراف سقف ثابت نیست و برای حفظ یک ایدهٔ کامل یا پاراگراف عبوری از مرز صفحه تنظیم می‌شود. بقیهٔ متن دیده‌شده برای باکس بعدی در cache می‌ماند.
11. teacher فقط SourceBlockهای حاضر در slice را می‌گیرد؛ pageهای قبلی دوباره Vision نمی‌شوند. برای Markdown/فایل متنی، parse مستقیم heading/paragraph/image link و hash-bound SourceBlock؛ برای folder، ترتیب deterministic از manifest و override دستی؛ هیچ conversion یا format ناشناخته بی‌بررسی وارد منبع درس نمی‌شود.

### cache key

```text
PageVisionCacheKey =
  sourceHash + pageNumber + renderProfile + visionModelProfile + promptVersion

LessonCacheKey =
  sliceId + sourceBlockHashes + figureHashes + teacherProfile + promptVersion + learnerPreferenceVersion
```

### قانون ادامه context

باکس دوم از `SliceCursor` و `LearningSlice` می‌آید، نه از حافظه ضمنی مدل. context حداقلی:

- آخرین `sliceId` و وضعیت آن.
- plan فشرده node و conceptهای پوشش‌داده‌شده.
- source blockهای مجاز slice بعدی.
- یک lookahead summary کوتاه.
- learner feedback و highlightهای همان موضوع.

اگر cache کافی باشد، باکس بعدی بدون Vision ساخته می‌شود. اگر `nextVisionRequiredAt` برسد، UI به‌جای spinner بی‌نهایت یک ingestion job قابل مشاهده می‌سازد.

---

## 6. Lesson AST و box system

خروجی AI فقط JSON مطابق schema است:

```text
LessonDocument
  - header
  - source_strip
  - intro
  - sections[]
      - paragraph
      - definition_box
      - mechanism_box
      - tip_box
      - warning_box
      - comparison_table
      - formula_box
      - example_box
      - figure
      - figure_explanation
      - key_takeaway
      - recall_prompt
      - citation
  - study_actions
```

هر block باید داشته باشد:

- `id` پایدار.
- `type` از enum allowlist.
- متن فارسی، tone و emoji policy.
- `sourceCitationIds` یا `derivedFrom`.
- `reviewEligible` و optional `reviewPrompt`.
- metadata برای highlight و note anchoring.

Flutter renderer همان semantic vocabulary را روی Android، Windows و Web render می‌کند. Web export می‌تواند HTML sanitizeشده تولید کند، اما HTML canonical نیست.

### policy محتوایی

پرامپت کاربر درباره عمق، مکانیسم، اعداد، استثنا، جدول، مثال، فارسی، محاوره و emoji به چند policy مستقل شکسته می‌شود؛ یک prompt غول‌پیکر immutable نمی‌ماند. هر policy version و test fixture دارد.

- deep explanation، نه superficial summary.
- محتوای منبع‌محور، بدون ادعای بیرونی خاموش.
- تعریف first-use برای اصطلاحات.
- distinction بین «طبق منبع» و «توضیح تکمیلی».
- tone گرم و conversational، اما نه سطحی یا بی‌دقت.
- emoji محدود و قابل خاموش‌کردن.
- figure همیشه با explanation و citation.

---

## 7. Agent tools

### ابزارهای read-only

`get_current_slice`، `get_source_citations`، `search_cached_source`، `get_due_reviews`، `get_highlights`، `get_notes`، `get_learning_state`.

### ابزارهای mutation با validation

`mark_lesson_state`، `schedule_review`، `create_note`، `update_note`، `create_highlight`، `delete_highlight`، `jump_to_node`، `request_next_slice`، `set_preference`، `retry_failed_job`.

هر mutation:

1. schema validation.
2. auth/ownership check.
3. allowlist check.
4. idempotency key.
5. transaction یا local atomic write.
6. audit record.
7. UI confirmation/state update.

دستورهایی مثل «این بخش را خواندم» باید مستقیماً `LearnerState` و در صورت policy، `ReviewItem` را تغییر دهند؛ خروجی چت بدون mutation معتبر نیست.

---

## 8. Spaced Repetition

### MVP schedule

بعد از اولین `STUDIED`، روزهای مرور **نسبت به زمان مطالعهٔ آغازین** این‌ها هستند؛ intervalهای بین آن‌ها مستقل محاسبه می‌شوند، نه اینکه ۱+۳+۷+۱۵+۳۰ روز پشت‌سرهم جمع شوند:

```text
anchor = firstStudiedAt (UTC)
review offsets = +1, +3, +7, +15, +30 days
```

اگر مرور دیر انجام شد، همان مرور due از دست نمی‌رود؛ پس از ثبت پاسخ، scheduler با `actualReviewedAt` و تاریخچهٔ event برای مرور بعدی زمان تازه می‌دهد؛ هیچ موعد گذشتهٔ چندگانه یک‌جا spam نمی‌شود. درجهٔ «یاد نگرفتم» مرحله را به +1 روز از همان پاسخ برمی‌گرداند، درجهٔ «مسلطم» مرحلهٔ بعدی را جلو می‌برد. بعد از 30 روز، interval طبق policy versioned و deterministic افزایش می‌یابد یا reset می‌شود؛ timezone کاربر فقط زمان نمایش/تحویل notification را تغییر می‌دهد. AI لازم نیست.

### interaction

پایین هر Lesson Box:

- «خواندم» → `STUDIED` و schedule.
- «یاد نگرفتم» → `NOT_LEARNED`، review زودتر و پیشنهاد explain ساده‌تر.
- «بعداً» → بدون ادعای مطالعه، reminder قابل تنظیم.
- «مسلطم» → interval بالاتر، فقط با rule روشن.
- «رد کردن» → `SKIPPED`، بدون حذف source.

Review Inbox از `LessonArtifact` cacheشده استفاده می‌کند؛ مرور عادی دوباره AI نمی‌خواهد. فقط کاربر اگر «توضیح دوباره»، «ساده‌تر» یا «سؤال جدید» بخواهد call جدید انجام می‌شود.

### هدف مرور

Review target می‌تواند lesson box، یک `recall_prompt`، highlight یا note باشد. هر target به artifact اصلی link دارد تا کاربر از مرور کوچک به context کامل برگردد.

---

## 9. Highlight و Note

offset خام کافی نیست. anchor ترکیبی:

```json
{
  "sourceBlockId":"block_123",
  "lessonBlockId":"lesson_456",
  "quote":"متن دقیق انتخاب‌شده",
  "prefix":"چند کلمه قبل",
  "suffix":"چند کلمه بعد",
  "startOffset":42,
  "endOffset":87,
  "pageId":"page_12",
  "bbox":{"x":0.1,"y":0.2,"w":0.4,"h":0.03},
  "contentHashAtCreation":"..."
}
```

rehydration order:

1. exact sourceBlock + content hash.
2. quote داخل block.
3. prefix/suffix search.
4. page+bbox fallback.
5. `DETACHED` state با UI repair؛ silent move ممنوع.

Note می‌تواند به highlight، block، figure یا lesson block وصل شود. متن note و drawing جدا ذخیره می‌شوند؛ UI positioning فقط presentation است، نه identity.

---

## 10. Sync و offline

### local-first

هر mutation اول local transaction و oplog می‌سازد، UI بلافاصله update می‌شود، سپس sync worker آن را push می‌کند. network failure نباید مطالعه را قفل کند.

### conflict rules

| داده | conflict policy |
|---|---|
| source files/pages | immutable by hash؛ نسخه جدید ایجاد می‌شود |
| lesson artifacts | immutable versions؛ pointer کاربر قابل تغییر است |
| highlights | entity merge by ID؛ delete tombstone |
| notes | concurrent edits هر دو حفظ؛ conflict marker + resolution؛ نسخهٔ سرور برای ترتیب |
| review events | append-only union؛ schedule دوباره محاسبه می‌شود |
| learner state | monotonic event + latest projection |
| preferences | LWW با server-assigned version/sequence؛ clock دستگاه فقط UI |
| cursor | latest valid cursor؛ history نگه داشته می‌شود |

### sync واقعی بین دستگاه‌ها

- sync صرفاً وضعیت مطالعه نیست: در نسخهٔ قابل‌استفاده، original PDF/MD و figure/page evidence لازم برای خواندن و citation روی دستگاه دوم نیز به Storage خصوصی منتقل می‌شوند؛ یا import دوباره با همان sourceHash انجام می‌شود و کاربر صریح می‌داند offline coverage آن دستگاه ناقص است. انتخاب policy پیش‌فرض و سهمیهٔ storage در pilot تعیین شود، نه اینکه sync «کامل» نام بگیرد ولی کتاب آن‌جا نباشد.
- Blobها content-addressed و resumable هستند؛ upload/download و index هرکدام checkpoint، size/hash verification، retry bounded و cancellation دارند. Web quota/eviction، دستگاه کم‌فضا و هزینهٔ ترافیک/ذخیره‌سازی سنجیده شود. گزینهٔ حذف محلی و حذف ابری با تأیید و cascade/tombstone مجزا.
- sync تغییرات از server cursor monotonic و sequence/operationId idempotent پیروی می‌کند؛ ساعت دستگاه authority ترتیب mutation نیست. `updatedAt` فقط پس از پذیرش server برای LWW قابل اتکاست؛ در notes برخوردِ دو edit همزمان با conflict marker و هر دو نسخه حفظ شود. Event-based schedule rebuild در چند دستگاه دقیقاً یکسان باشد.

### sync امنیتی

- Authenticated user فقط resourceهای خودش را می‌بیند.
- RLS و grant audit برای همه tableهای exposed؛ bucket private و storage policy scoped.
- Storage path بر اساس `userId/libraryId/sourceHash`؛ فایل کتاب public URL دائمی ندارد.
- AI service key و service-role فقط server-side.
- logها payload خام کتاب و token را چاپ نمی‌کنند. قبل از upload/call AI، privacy notice دربارهٔ ارسال محتوای کتاب، retention/deletion و حق استفادهٔ شخصی از اثر نمایش داده شود؛ بدون مجوز/دسترسی قانونی کتاب شخص ثالث منتقل نشود.

---

## 11. مراحل اجرایی — ۳۰ مرحله

هر مرحله یک work package مستقل است. اجرای واقعی باید هر مرحله را با test و commit کوچک ببندد؛ اما در این turn هیچ مرحله‌ای اجرا نمی‌شود.

### Stage 1 — قرارداد پروژه و baseline محیط

**Objective:** انتخاب نام، repo root، Flutter channel/version، Dart constraints، target matrix و policyهای ثابت.

**Files:** `C:/Users/K1/Desktop/Projects/Trace/README.md`، `docs/architecture/decision-log.md`، `tool/target-matrix.md`.

**کار:** `flutter doctor`، `flutter --version`، host capability، Android SDK، Visual Studio Windows workload، browserها و available CI runnerها ثبت شوند. `StudyHub-Web` فقط reference بماند.

**Acceptance:** target matrix برای Android/Windows/Web با status `VERIFIED`، `CONFIGURED—HOST UNVERIFIABLE` یا `BLOCKED`؛ هیچ platform دیگر claim نشود.

**Verify:** `flutter doctor -v`، `flutter --version`، `git status` در repo جدید.

### Stage 2 — اسکلت monorepo

**Objective:** ساخت skeleton بدون feature logic.

**Files:** `apps/trace_flutter/`، `packages/trace_domain/`، `packages/trace_data/`، `packages/trace_design/`، `services/ai_gateway/`، `services/ingestion_worker/`، `supabase/`، `test/fixtures/`.

**Acceptance:** `flutter analyze`، package resolution و empty app روی حداقل یک target pass؛ package boundaries روشن.

### Stage 3 — architecture contract

**Objective:** تثبیت MVVM، repository interfaces، service boundaries و dependency direction.

**Files:** `docs/architecture/layers.md`، `packages/trace_domain/lib/src/contracts/`، `apps/trace_flutter/lib/app/`.

**Acceptance:** UI مستقیماً به Supabase/AI/file system وصل نیست؛ dependency graph یک‌طرفه و قابل تست.

**Tests:** architecture lint/manual review، fake repository smoke test.

### Stage 4 — dependency و license spike

**Objective:** انتخاب نهایی Drift، PDF renderer، image cache، secure storage، file picker، notifications و state management.

**Files:** `docs/architecture/dependency-decisions.md`، `pubspec.yaml`ها.

**Acceptance:** برای هر dependency، Android/Windows/Web support، license، maintenance و fallback ثبت شده؛ package فقط به‌خاطر محبوبیت اضافه نمی‌شود.

**Verify:** minimal sample build روی targetهای ممکن؛ web Drift storage caveat ثبت شود.

### Stage 5 — design direction و preview gate

**Objective:** طراحی identity و shell قبل از implementation گسترده.

**فرضیهٔ اولیه، نه طرح تصویری تأییدشده:** `Knowledge Workbench` — matte graphite، luminous ink برای progress، source pages به‌عنوان evidence tiles، worktree به‌عنوان spine، lesson box به‌عنوان framed teaching artifact؛ نه کپی بصری Codex. سه seed دیگر برای ideation داخلی: `Atlas Console` (ناوبری فضایی)، `Cognitive Lab` (شواهد و inspector)، `Study Signal` (مرور و بازگشت). این نام‌ها **گزینهٔ قابل انتخاب فعلی نیستند**؛ تصویر preview یا concept board هنوز ساخته نشده است.

**روش:** حداقل ۲۴ recipe خام از product truth و UX topology بساز؛ ۲ تا ۴ جهت نهایی را بعد از نقد usability/RTL/200% text با preview تصویری imagegen مقایسه کن. کاربر طراحی shell، tokenها و interaction را به اجرای خودکار واگذار کرده است؛ قوی‌ترین جهت با evidence انتخاب و اجرا شود. آیکون نهایی انتخاب و نصب شده است؛ منبع آن immutable و نسخه‌های platform از `tool/generate_icons.py` مشتق شوند. انتخاب آیکون نباید Stageهای اجرای UI و backend را متوقف کند. آیکون abstract/conceptual و فلسفی است، بدون تصویر مستقیم کتاب یا درس؛ فرم در حریم دایره‌ای فرضی بدون حلقهٔ واقعی قرار دارد. تقارن الزام نیست.

**Files:** `docs/design/opinion-ledger.md`، `docs/design/interaction-map.md`، preview assets فقط در `docs/design/previews/`.

**Acceptance:** جهت UI غیرآیکون پس از نقد و preview به‌صورت خودکار انتخاب و به runtime artifact تبدیل شود؛ آیکون منتخب در Android، Windows و Web/PWA با آزمون build و بازبینی اندازه‌های کوچک ثابت شود. preview mock است، نه runtime proof.

**یادداشت اجرای 2026-09-23:** ۲۴ recipe، دو HTML mock متمایز و چهار screenshot مرورگر در `docs/design/` ساخته شد؛ Chrome headless عرض 320/375/768/1440، جهت فارسی، icon loading و drawer را تست کرد و یک overflow موبایل اصلاح شد. Evidence Atelier فقط جهت موقت منتخب است. چون دستور جدید کاربر استفاده از مدل تصویریِ دیگر را منع کرده، previewها imagegen نیستند؛ این gate و تبدیل به Flutter runtime هنوز **کامل نشده‌اند**. تعارض را با مدل دیگری دور نزن؛ طراحی/قراردادهای مستقل را پیش ببر و پیش از rollout UI وسیع تکلیف شرط imagegen را با کاربر روشن کن.

### Stage 6 — design tokens و responsive contract

**Objective:** tokenهای رنگ، type، spacing، radius، elevation، motion، RTL و platform density.

**Files:** `packages/trace_design/lib/src/tokens/`، `docs/design/responsive-contract.md`.

**Acceptance:** desktop 3-pane، tablet 2-pane، mobile drawer؛ 200% text، LTR chrome و RTL فقط برای محتوای فارسی chat/lesson، reduced motion، keyboard و touch targets مشخص. هیچ label فارسی در product chrome نیست.

**Tests:** golden matrix برای narrow/wide، English LTR shell، Persian RTL content، mixed technical terms/number/citation، long text و screen reader.

### Stage 7 — canonical domain schema

**Objective:** تعریف modelهای بخش 4 با serialization و versioning.

**Files:** `packages/trace_domain/lib/src/models/`، `packages/trace_domain/test/serialization/`، `docs/contracts/domain-v1.json`.

**Acceptance:** همه entityها ID/version/hash دارند؛ round-trip JSON pass؛ unknown enum safe fallback دارد.

### Stage 8 — local database foundation

**Objective:** Drift schema، migrations، local repositories و transaction helper.

**Files:** `packages/trace_data/lib/src/local/database.dart`، `tables/`، `migrations/`، `repositories/`.

**Acceptance:** insert/read/update/delete برای library، source page، lesson، annotation، review و oplog atomic است.

**Tests:** migration from empty، duplicate idempotency، rollback، corrupted row handling.

### Stage 9 — Web storage proof

**Objective:** اثبات Drift Web storage روی browserهای هدف قبل از وابستگی product.

**Files:** `apps/trace_flutter/web/`، `packages/trace_data/test/web/`، `docs/platform/web-storage-matrix.md`.

**Acceptance:** persistence after reload، behavior with no OPFS، single-tab guard، stale storage recovery. Multi-tab write claim فقط با evidence.

### Stage 10 — library و import UX

**Objective:** import PDF، Markdown، folder و archive-safe inventory.

**Files:** `apps/trace_flutter/lib/features/library/`، `packages/trace_data/lib/src/import/`.

**Format policy:** MVP: PDF و MD/TXT و پوشهٔ این‌ها، تصاویر مستقل PNG/JPEG به‌عنوان صفحهٔ Vision و تصاویر ارجاع‌شده از MD؛ ZIP فقط بعد از path/size/decompression-limit audit. EPUB/DOCX/HTML با conversion adapter نسخه‌بندی‌شده در فاز بعدی، پس از pilot fidelity/license. «هر فرمتی» ادعای پذیرش بی‌حد نیست: فرمت ناشناخته original را تغییر نمی‌دهد و با `UNSUPPORTED_FORMAT` و مسیر adapter متوقف می‌شود. انتخاب پوشه در Web فقط با capability واقعی browser؛ fallback انتخاب چند فایل/ZIP و caveat واضح.

**Acceptance:** file/folder selection platform-specific adapter دارد؛ originals immutable؛ duplicate source hash شناسایی می‌شود؛ progress و cancel وجود دارد.

**Tests:** empty folder، nested folder، unsupported format، duplicate، cancel، offline.

### Stage 11 — immutable manifest و provenance

**Objective:** hash-bound source manifest و origin map.

**Files:** `packages/trace_domain/lib/src/models/source_manifest.dart`، `services/ingestion_worker/src/manifest/`، `docs/contracts/source-manifest-v1.md`.

**Acceptance:** path، size، modified time، SHA-256، MIME، logical role و exclusion reason ذخیره می‌شود؛ تغییر input job جدید می‌سازد.

### Stage 12 — PDF render و contact-sheet worker

**Objective:** render کم‌هزینه thumbnail/page و ساخت grid labelled.

**Files:** `services/ingestion_worker/src/render/`، `services/ingestion_worker/src/contact_sheet/`، `test/fixtures/pdf/`.

**Acceptance:** همه pageها stable pageId و pixel hash دارند؛ contact sheet فقط برای navigation/structure است؛ visual crop بدون clipping.

**Tests:** page order، RTL page labels، rotated page، large PDF، cancel/resume.

### Stage 13 — structure scan و tree proposal

**Objective:** تشخیص pattern کلی، chapter/section candidate و confidence.

**Files:** `services/ai_gateway/src/capabilities/structure_scan/`، `services/ingestion_worker/src/planning/structure_proposal/`.

**Acceptance:** input فقط contact sheet/metadata؛ output strict JSON با candidate ranges، reason، confidence و `needsReview`; هیچ lesson text تولید نمی‌شود.

**Tests:** golden fixtures با chapter heading، no-heading، multi-column، Persian/English mix.

### Stage 14 — Vision page extraction

**Objective:** استخراج متن، figure، caption، bbox و citation از pageهای انتخابی.

**Files:** `services/ai_gateway/src/capabilities/page_vision_extract/`، `services/ingestion_worker/src/extraction/`.

**Acceptance:** OCR dependency در runtime اصلی وجود ندارد؛ page vision result hash-bound است؛ unreadable token quarantine می‌شود؛ figure کامل و inline-capable است.

**Tests:** schema validation، malformed model JSON، missing figure، low confidence، retry bounded.

### Stage 15 — page cache و dedupe

**Objective:** جلوگیری قطعی از vision دوباره.

**Files:** `packages/trace_data/lib/src/cache/vision_cache_repository.dart`، `services/ingestion_worker/src/cache/`.

**Acceptance:** همان `PageVisionCacheKey` hit می‌خورد؛ prompt/model/render change miss می‌سازد؛ cache invalidation قابل توضیح است.

**Tests:** hit/miss matrix، concurrent same-page job، crash resume، hash mismatch.

### Stage 16 — source block normalization

**Objective:** تبدیل خروجی Vision/native Markdown به SourceBlock canonical.

**Files:** `services/ingestion_worker/src/normalize/`، `packages/trace_domain/lib/src/models/source_block.dart`.

**Acceptance:** reading order، paragraph/list/table/formula/figure، page locator و source hash حفظ می‌شود؛ text rewrite در این layer ممنوع.

**Tests:** mixed RTL/LTR، table cells، formula symbols، cross-page paragraph.

### Stage 17 — planner و SliceCursor

**Objective:** تعیین مرز باکس‌ها و next vision point بدون context leak.

**Files:** `services/ingestion_worker/src/planning/slice_planner/`، `packages/trace_domain/lib/src/models/slice_cursor.dart`.

**Acceptance:** planner با source blocks cacheشده، sliceهای ordered، boundary reason، lookahead و `nextVisionRequiredAt` می‌دهد؛ تکرار page ندارد.

**Tests:** 2-page example، boundary وسط page، figure وابسته به page بعد، end-of-node، resume after crash.

### Stage 18 — Lesson AST schema و validator

**Objective:** قرارداد دقیق box آموزشی.

**Files:** `docs/contracts/lesson-ast-v1.json`، `packages/trace_domain/lib/src/lesson_ast/`، `services/ai_gateway/src/validation/lesson_ast/`.

**Acceptance:** block type allowlist؛ citation required برای factual block؛ figure explanation اجباری؛ HTML/style arbitrary rejected.

**Tests:** valid AST، missing citation، invalid block، too-long block، unsafe link، duplicate IDs.

### Stage 19 — teacher-fa capability

**Objective:** تولید Lesson Box فارسی از slice محدود.

**Files:** `services/ai_gateway/src/capabilities/teacher_fa/`، `services/ai_gateway/src/prompts/teacher-fa/`، `test/golden/teacher_fa/`.

**Acceptance:** prompt کاربر به policyهای versioned شکسته؛ tone، depth، mechanism، example، emoji و citation testable؛ source خارج از context وارد نمی‌شود.

**Tests:** Persian، English technical terms، long context، user asks shallow summary، source contradiction، prompt injection in book.

### Stage 20 — Flutter renderer

**Objective:** render Lesson AST به boxهای جذاب و accessible.

**Files:** `packages/trace_design/lib/src/lesson/`، `apps/trace_flutter/lib/features/teaching_stage/`.

**Acceptance:** `definition_box`، `mechanism_box`، `tip_box`، `warning_box`، table، figure، explanation، citation و action footer روی سه target semantic parity دارند.

**Tests:** widget/golden، RTL، 200% text، missing image، dark/light، reduced motion.

### Stage 21 — Codex-like shell و Worktree

**Objective:** library rail، tree، chat stage، inspector و command palette.

**Files:** `apps/trace_flutter/lib/features/shell/`، `features/worktree/`، `features/chat/`، `features/source_inspector/`.

**Acceptance:** انتخاب هر node، chat context را عوض می‌کند؛ deep link به slice کار می‌کند؛ mobile drawer و desktop keyboard path کار می‌کنند. progress node فقط از مطالعه/فهم/مرور واقعی مشتق می‌شود؛ حالت locked هرگز دسترسی پایه به منبع را از کاربر شخصی نمی‌گیرد.

**Tests:** route restoration، focus order، collapse/expand، empty/loading/error/offline states.

### Stage 22 — chat stream و tool router

**Objective:** chat input، streaming، cancellation، typed tools و mutation receipt.

**Files:** `apps/trace_flutter/lib/features/chat/`، `services/ai_gateway/src/tools/`، `packages/trace_domain/lib/src/tools/`.

**Acceptance:** model نمی‌تواند مستقیم DB را تغییر دهد؛ tool call validation و idempotency ثبت می‌شود؛ input پس از failure حفظ می‌شود؛ stop کار می‌کند.

**Tests:** tool allowlist، duplicate mutation، timeout، partial stream، unauthorized node، malformed args.

### Stage 23 — lesson state و footer actions

**Objective:** «خواندم»، «یاد نگرفتم»، «بعداً»، «مسلطم»، «رد کردن».

**Files:** `apps/trace_flutter/lib/features/learning_state/`، `packages/trace_domain/lib/src/usecases/mark_lesson_state.dart`.

**Acceptance:** action local-first ثبت می‌شود، UI feedback می‌دهد، event و projection consistent می‌مانند، status با chat tool و direct UI یکی است.

### Stage 24 — deterministic review scheduler

**Objective:** fixed ladder و adaptive-after-30-days بدون AI.

**Files:** `packages/trace_domain/lib/src/review/`، `packages/trace_data/lib/src/repositories/review_repository.dart`.

**Acceptance:** schedule دقیق 1/3/7/15/30؛ timezone-safe؛ duplicate event safe؛ due query سریع؛ manual snooze و reset تعریف‌شده.

**Tests:** clock-controlled tests، missed review، hard/easy، device timezone، duplicate action، rebuild schedule from events.

**Gamify contract:** `lesson_studied`، `concept_understood`، `review_completed` و `mistake_corrected` eventهای private، idempotent و versioned هستند. پیشرفت map و recap معنادار از eventهای معتبر مشتق می‌شوند؛ replay آفلاین/Supabase double-award ندارد. بازخورد بدون شرم و با reduced-motion؛ امتیاز passive time و فشار streak وجود ندارد.

### Stage 25 — Review Inbox و cached replay

**Objective:** ارسال lesson boxهای due بدون generation دوباره.

**Files:** `apps/trace_flutter/lib/features/review_inbox/`، `features/review_session/`.

**Acceptance:** due target با artifact cache باز می‌شود؛ citation و link به source حفظ می‌شود؛ فقط request explicit مدل را صدا می‌زند.

### Stage 26 — highlight anchor engine

**Objective:** selection، persistence، reattach، detached repair.

**Files:** `apps/trace_flutter/lib/features/annotations/`، `packages/trace_domain/lib/src/annotations/`.

**Acceptance:** quote/prefix/suffix/source block/hash ذخیره؛ regeneration anchor را بی‌صدا جابه‌جا نمی‌کند؛ repair UI دارد.

**Tests:** resize، different renderer، regenerated lesson version، deleted block، Persian normalization، selection across inline figure.

### Stage 27 — notes و source-linked annotation

**Objective:** note متنی، pin، drawing optional و backlink به lesson/source.

**Files:** `apps/trace_flutter/lib/features/notes/`، `packages/trace_domain/lib/src/models/note.dart`.

**Acceptance:** note به page/block/lesson وصل؛ export/import؛ local-first؛ conflict state قابل دیدن.

### Stage 28 — sync engine و Supabase schema

**Objective:** Supabase Auth/Postgres/private Storage به‌همراه Drift local-first، oplog push/pull، RLS و ownership؛ backend جایگزین برای MVP پذیرفته نیست.

**Files:** `supabase/migrations/`، `services/sync/`، `packages/trace_data/lib/src/sync/`، `docs/security/rls-matrix.md`.

**Acceptance:** owner فقط resource خودش را می‌بیند؛ offline mutations بعداً replay می‌شوند؛ retry bounded؛ conflict rules بخش 10 اجرا می‌شوند.

**Tests:** anon، owner، non-owner، stale device، duplicate operation، partial batch، delete tombstone، RLS test suite.

### Stage 29 — native adapters و background jobs

**Objective:** Android notification، Windows file/window integration، Web PWA lifecycle و worker progress.

**Files:** `apps/trace_flutter/android/`، `windows/`، `web/`، `lib/platform/`، `services/ingestion_worker/`.

**Acceptance:** هر platform capability پشت interface مشترک؛ unsupported feature fallback دارد؛ import/vision job با app restart ادامه می‌یابد؛ notification فقط due item واقعی می‌فرستد.

**Tests:** permission denied، background pause/resume، browser refresh، Windows path، Android process death.

### Stage 30 — performance، security، QA و release gate

**Objective:** prove end-to-end vertical slice و سپس release readiness.

**Files:** `docs/qa/acceptance-matrix.md`، `docs/ops/runbook.md`، `.github/workflows/ci.yml`، `benchmarks/`، `test/e2e/`.

**Acceptance vertical slice:** import یک PDF کوچک → structure tree → vision دو page → cache → Lesson Box فارسی با figure/citation → mark studied → due review → highlight/note → second device sync.

**Budgets پیشنهادی برای pilot:**

- local library open: p95 زیر 250ms در dataset آزمایشی.
- cached lesson open: p95 زیر 300ms.
- UI هیچ wait نامحدود نداشته باشد.
- contact sheet و thumbnails lazy باشند؛ full-resolution فقط در inspector/lesson لازم.
- memory و frame pacing روی Windows/Android با dataset واقعی اندازه‌گیری شود، نه حدس.
- AI cost per slice، cache hit rate، duplicate vision count، schema failure rate و p95 latency ثبت شود.

**Verification:** `flutter analyze`، unit/widget/integration، web build، Windows build روی host مناسب، Android build/emulator/device smoke، browser persistence، RLS tests، AI mocked golden set، fault injection، accessibility و RTL matrix. هر check که host اجازه ندهد با status دقیق گزارش شود.

---

## 12. تست و acceptance matrix

### Content fidelity

- هر factual LessonBlock citation دارد.
- هر figure explanation دقیقاً به figure مربوط است.
- page/source coverage gap قابل مشاهده است.
- unreadable text guess نمی‌شود.
- source edit باعث sourceHash جدید می‌شود.

### AI correctness

- JSON schema failure به user-facing retry قابل فهم تبدیل می‌شود.
- prompt injection داخل source policy را تغییر نمی‌دهد.
- teacher فقط slice مجاز را می‌بیند.
- cache hit دوباره مدل را صدا نمی‌زند.
- هزینه و latency هر call ثبت می‌شود.

### Learning behavior

- status actions idempotent هستند.
- 1/3/7/15/30 دقیق است.
- review cached replay بدون AI کار می‌کند.
- «یاد نگرفتم» مسیر توضیح ساده‌تر و schedule زودتر دارد.
- highlight به lesson/source برمی‌گردد.

### Cross-platform

- Android، Windows، Web یک domain contract دارند.
- تفاوت native فقط در adapter است.
- drawer/keyboard/Touch/RTL/reduced motion تست شده.
- Web reload local DB را از بین نمی‌برد.
- sync پس از offline/online کار می‌کند.

### Security

- هیچ secret در bundle/log/DB client-visible نیست.
- همه exposed tableها RLS دارند.
- tool mutation authorization دوباره بررسی می‌شود.
- file path traversal و archive escape بسته است.
- source payload خام در telemetry نمی‌رود.

---

## 13. error و recovery contract

| failure | وضعیت درست | recovery |
|---|---|---|
| network قطع | content محلی + banner offline | queue sync |
| Vision timeout | job pending/failed، cursor محفوظ | retry bounded با همان idempotency |
| مدل JSON خراب | artifact ساخته نشود | repair/one retry، سپس error قابل فهم |
| source hash تغییر | import جدید | نسخه قبلی immutable بماند |
| sync conflict | conflict marker | user compare/resolve؛ silent overwrite ممنوع |
| missing figure | lesson partial با placeholder صادقانه | open source inspector / retry extraction |
| expired auth | local read-only | sign in و replay امن |
| ambiguous mutation | pending state | reconcile by operation ID |
| Web storage unavailable | warning + safe fallback | پیشنهاد native app یا browser supported |
| corrupted local DB | preserve export if possible | rebuild from synced data + incident log |

---

## 14. observability و هزینه

برای هر AI run:

- capability/profile، prompt/schema version.
- source/figure/input hashes، نه raw private payload.
- request ID، latency، retry count، status.
- input/output token estimate و provider cost اگر available.
- cache hit/miss و reason.
- user-visible outcome: lesson created، review replay، error، cancel.

داشبورد personal کافی است:

- pages visioned / cached.
- cache hit rate.
- slices generated / replayed.
- average cost per new slice.
- failed jobs.
- review completion.

Kill switch: disable AI calls ولی local library، cached lessons، highlights، notes و review همچنان کار کنند.

---

## 15. ریسک‌ها و تصمیم‌های باز

| ریسک | اثر | mitigation | زمان تصمیم |
|---|---|---|---|
| Vision فارسی/فرمول کم‌دقت | محتوای غلط | golden set، quarantine، source inspect | قبل از Stage 14 |
| Drift Web multi-tab limitation | data race | single-tab guard یا native recommendation | Stage 9 |
| PDF renderer/license | lock-in یا legal risk | spike و adapter | Stage 4 |
| long-running worker | job stuck | resumable checkpoints، idempotency | Stage 12 |
| raw HTML temptation | security/drift | AST renderer اجباری | Stage 18 |
| sync conflict پیچیده | data loss | append-only events، tombstones | Stage 28 |
| context رشد بی‌حد | هزینه بالا | slice cursor، hashes، compact plan | Stage 17 |
| emoji/محاوره کیفیت علمی را کم کند | اعتماد پایین | user preference و prompt regression | Stage 19 |
| design بیش از حد futuristic | خستگی | workbench hierarchy و usability gate | Stage 5/6 |
| StudyHub code drift | reuse اشتباه | reference-only، copy contracts نه files | Stage 1 |

### تصمیم‌هایی که قبل از build باید بسته شوند

1. نام نهایی محصول.
2. provider/model profile مجاز روی AI Gateway.
3. Supabase project/credentials و migration/test target (فقط انتخاب instance باز است؛ فناوری Supabase قطعی است).
4. PDF renderer و license.
5. notification policy و timezone.
6. آیا drawing note در MVP لازم است یا text note کافی است.
7. آیکون نهایی انتخاب و به‌صورت source hash-bound نصب شد؛ جهت UI غیرآیکون خودکار و evidence-backed.

---

## 16. MVP cut line

### Must ship

- Flutter Android/Windows/Web shell.
- private auth و sync.
- PDF/Markdown/folder import.
- manifest/hash/provenance.
- contact sheet structure scan.
- vision page cache بدون OCR runtime.
- source tree و manual override.
- slice cursor و next page policy.
- Persian Lesson AST با box، figure explanation و citation.
- chat با typed tools.
- status actions.
- 1/3/7/15/30 review.
- highlight/note/source backlink.
- offline local-first و sync.
- progress map و feedback/recap private و غیرتحمیلی با ruleهای deterministic، idempotent و تست‌شده.

### بعد از vertical slice

- adaptive scheduler پیشرفته.
- quiz generation.
- voice/TTS.
- semantic search/embeddings.
- concept graph visualization.
- mascot پیچیده و celebrationهای چندمرحله‌ای پس از اثبات حلقه یادگیری.
- multi-book cross-reference.
- export HTML/PDF.

### ممنوع در MVP

- public collaboration.
- arbitrary HTML injection.
- autonomous web research بدون درخواست.
- full-book prompt به teacher.
- auto-delete یا auto-rewrite source.
- notification برای چیزی که واقعاً due نشده.

---

## 17. ترتیب اجرای پیشنهادی و gateها

```text
Stage 1-4  -> Discovery/architecture gate
Stage 5-6  -> Approved design/UX gate
Stage 7-9  -> Data/local persistence gate
Stage 10-16 -> Source ingestion gate
Stage 17-20 -> First lesson vertical slice gate
Stage 21-23 -> Agent/UI mutation gate
Stage 24-27 -> Learning loop gate
Stage 28-29 -> Cross-device/platform gate
Stage 30 -> Integrated release gate
```

هر gate باید این سه چیز را داشته باشد:

1. artifact واقعی.
2. test یا runtime evidence.
3. known limitations صریح.

Activity، تعداد token، تعداد commit یا تعداد AI call progress محسوب نمی‌شود؛ فقط gate evidence progress است.

---

## 18. تعریف done نهایی

پروژه فقط وقتی «نسخه اول قابل استفاده» محسوب می‌شود که این flow با source واقعی اجرا و ثبت شده باشد:

1. یک PDF طولانی import شود.
2. tree پیشنهادی با confidence نمایش داده شود.
3. user tree را approve/edit کند.
4. دو page انتخابی با Vision استخراج شوند.
5. source text، figure، caption و citation ذخیره شوند.
6. slice اول و مرز slice دوم ساخته شود.
7. Lesson Box فارسی با tone انتخابی render شود.
8. figure داخل box و توضیحش کنار آن دیده شود.
9. کاربر status بزند و review در 1 روز ساخته شود.
10. فردای آن، box از cache بدون AI replay شود.
11. highlight و note به block/source وصل بمانند.
12. device دوم همان library، state، annotation و due queue را sync کند.
13. یک page جدید فقط وقتی vision شود که cursor واقعاً به آن نیاز دارد.
14. هزینه، cache hit، failure و recovery در ledger قابل مشاهده باشد.
15. Android، Windows و Web هرکدام با evidence واقعی یا limitation دقیق گزارش شوند.

**نتیجه مطلوب:** کاربر به‌جای جنگیدن با یک کتاب حجیم، یک workbench زنده دارد که می‌داند چه چیزی را از کجا خوانده، الان چه چیزی باید یاد بگیرد، بعدی از کجا می‌آید، چه چیزی باید مرور شود و هر ادعا به کدام تکه منبع برمی‌گردد.
