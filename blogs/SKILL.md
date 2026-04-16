---
name: topic-generator
description: "Topic Generator is an agentic skill that accepts -t TOPIC and -s SUBTOPIC arguments (e.g. topicGenerator -t JAVA -s Thread) and generates a comprehensive, structured, richly formatted HTML blog page about the subtopic. It covers definitions, history, architecture, competitors, trends, key players, and more — with diagrams and step-by-step explanations. The report progresses from basic to advanced concepts and ends with senior-level interview questions. Output is saved as <subtopic_lowercase>.html in the blogs directory and index.html is automatically updated with a sidebar link. Trigger for: 'topicGenerator -t X -s Y', '-t X -s Y', 'generate a report on', 'deep dive into', 'explain everything about', or any lone topic/subtopic pair."
---

# Topic Generator Skill

## Overview
Generates a **comprehensive, basic-to-advanced** HTML blog page on any Topic + Sub-Topic.
Always includes diagrams (CSS/HTML visuals), code examples with syntax highlighting,
best practices, and ends with **senior-level interview questions**.

Saves output as `<subtopic_lowercase>.html` in the blogs directory
AND **updates `index.html`** to add the new sidebar link under the correct category.

---

## Input Format
```
topicGenerator -t <TOPIC> -s <SUBTOPIC>
```
- `-t` — The parent topic / category (e.g. `JAVA`, `Spring Boot`, `Kubernetes`)
- `-s` — The specific sub-topic to deep-dive (e.g. `Thread`, `Exception`, `Deployment`)

### Examples
```
topicGenerator -t JAVA -s Exception
topicGenerator -t JAVA -s Thread
topicGenerator -t Spring -s Security
topicGenerator -t Kubernetes -s Ingress
```

---

## Output
| Item | Detail |
|------|--------|
| **HTML File** | `<subtopic_lowercase>.html` — e.g. `exception.html`, `thread.html` |
| **Location** | `/Users/sanjay82/Documents/GITHUB/ai-projects/sanjay-dhiman/blogs/` |
| **index.html** | Sidebar updated: new `<button>` added under correct category section |

Filename rules:
- Lowercase the subtopic
- Replace spaces with hyphens
- Examples: `Thread Safety` → `thread-safety.html` · `Exception` → `exception.html`

---

## Execution Steps

### Step 1 — Parse Arguments
- Extract `-t VALUE` → `TOPIC`
- Extract `-s VALUE` → `SUBTOPIC`
- Compute `htmlFile` = lowercase(SUBTOPIC).replace(/ /g, '-') + '.html'
- Compute `categoryKey` = lowercase(TOPIC).replace(/ /g, '-')
- Full output path = `/Users/sanjay82/Documents/GITHUB/ai-projects/sanjay-dhiman/blogs/<htmlFile>`

### Step 2 — Research (use web search when available)
- Search for accurate, up-to-date information on `<SUBTOPIC>` within `<TOPIC>` context
- Gather data covering all 16 sections listed in Step 3
- Never hallucinate version numbers, dates, or statistics

### Step 3 — Generate the HTML Content (all 16 sections)

The HTML file is a **standalone styled page** matching the look of `index.html`.
Use the HTML TEMPLATE defined at the bottom of this skill.
Populate every section below within the `<main class="blog-main">` area.

#### Section 1 — Page Title & Breadcrumb
```html
<div class="topic-breadcrumb">
  <a href="index.html">Blog</a> ›
  <span class="cat-name">☕ TOPIC</span> ›
  <span class="sub-name">SUBTOPIC</span>
</div>
<h1 class="topic-title">SUBTOPIC — Comprehensive Deep Dive</h1>
<div class="tag-row"><!-- 4–6 relevant tags --></div>
```

#### Section 2 — What is `<SUBTOPIC>`?
- Definition (1–2 sentences, beginner-friendly)
- Simple analogy
- Two easy-to-remember one-sentence definitions
- Category (e.g. Concurrency / IO / Security / Framework)
- Official docs link if applicable

#### Section 3 — Why Does It Exist?
- Problem it solves (2–3 sentences)
- Before vs After comparison table (HTML `<table>`)

#### Section 4 — Who Should Know This?
HTML table: Role | Why They Need It | Depth Required

#### Section 5 — History & Evolution
Timeline rendered as a styled HTML `<div class="timeline">` list (not Mermaid).
Followed by a 3–5 sentence narrative.

#### Section 6 — Core Concepts — Basic 🟢
5–7 fundamentals, each with:
- Bold name
- 2–3 sentence explanation
- Short code snippet in `<div class="code-block">`
Architecture/concept relationship diagram rendered as a CSS flowchart or HTML table.

#### Section 7 — Core Concepts — Intermediate 🟡
5–7 concepts, each with:
- Bold name + 3–4 sentence explanation including *why* it matters
- Code snippet (10–25 lines)
- Common mistake / gotcha in `<div class="warn-box">`

#### Section 8 — Core Concepts — Advanced 🔴
5–7 advanced topics:
- Deep explanation (4–6 sentences) including internals
- Non-trivial code/config snippet (15–40 lines)
- Real-world trade-off in `<div class="tip-box">`

#### Section 9 — Architecture & Internals
- High-level component diagram (CSS-styled HTML boxes/arrows)
- Step-by-step internal walkthrough (numbered list, minimum 5 steps)
- Key Components table: Component | Role | Internal Mechanism | Failure Mode

#### Section 10 — Key Features
8–12 features, each: **Feature name** — one-line description + advanced trade-off note

#### Section 11 — Key Benefits
6–8 items: ✅ **Benefit** — 2-sentence real-world explanation

#### Section 12 — Key Challenges & Pitfalls
5–7 items: ⚠️ **Challenge** — explanation + mitigation
At least one "works in dev, breaks in prod" gotcha.

#### Section 13 — Best Practices
Three tiers: 🟢 Beginner | 🟡 Intermediate | 🔴 Advanced/Production

#### Section 14 — Ecosystem, Tools & Integrations
Table: Tool/Library | Purpose | Works Best With | Notable
Short paragraph on how it fits modern stacks.

#### Section 15 — Competitors & Comparison
- Comparison table: Competitor | Key Difference | Strengths | Weaknesses | Choose When
- Decision matrix: Criterion | SUBTOPIC | Alt A | Alt B

#### Section 16 — Key Trends & Future Outlook
5–7 trends: Trend name + 2–3 sentence description + timeframe/maturity

#### Section 17 — Interview Questions 🎯
Four tiers, minimum 4 questions each:
1. 🟢 Conceptual & Fundamentals
2. 🟡 Design & Architecture
3. 🔴 Advanced, Internals & Trade-offs
4. 💡 Scenario / Problem-Solving

Every question must have: **Q:** … followed by **What a great answer covers:** …

---

### Step 4 — Write the HTML File

Write the complete HTML to:
`/Users/sanjay82/Documents/GITHUB/ai-projects/sanjay-dhiman/blogs/<htmlFile>`

Use DC: write_file in **chunks of ≤ 30 lines** (mode: rewrite for first chunk, append for subsequent).
Always write the complete HTML document — never truncate.

---

### Step 5 — Update index.html

File: `/Users/sanjay82/Documents/GITHUB/ai-projects/sanjay-dhiman/blogs/index.html`

**5a. Determine category block:**
Search for `data-category="<categoryKey>"` in the sidebar.

**Case A — Category already exists:**
Find `<div class="subtopic-list" id="sub-<categoryKey>">` and append a new button BEFORE its closing `</div>`:
```html
<button class="subtopic-btn" onclick="window.location.href='<htmlFile>'">SUBTOPIC</button>
```
Also increment the `<span class="cat-count">` number by 1.

**Case B — Category does NOT exist:**
Append a brand new category block BEFORE `</div><!-- /sidebar-menu -->`:
```html
<!-- TOPIC -->
<div class="category-block" data-category="<categoryKey>">
  <button class="category-btn" onclick="toggleCategory(this, '<categoryKey>')">
    <span class="cat-icon">📄</span>
    <span class="cat-label">TOPIC</span>
    <span class="cat-count">1</span>
    <svg class="chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
  </button>
  <div class="subtopic-list" id="sub-<categoryKey>">
    <button class="subtopic-btn" onclick="window.location.href='<htmlFile>'">SUBTOPIC</button>
  </div>
</div>
```

Use DC: edit_block with `old_string` / `new_string` to make the precise surgical edit.

---

### Step 6 — Confirm Output
- Use `present_files` to surface the HTML file to the user
- Print: `✅ Created <htmlFile> | Topic: TOPIC > SUBTOPIC | index.html updated`

---

## HTML TEMPLATE

Use this exact template for the generated HTML file.
Replace ALL_CAPS placeholders with real content.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>SUBTOPIC — TOPIC | Sanjay Dhiman</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@700&display=swap" rel="stylesheet" />
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --navy: #0f172a; --blue: #1e40af; --accent: #3b82f6;
      --gold: #f59e0b; --light: #f8fafc; --muted: #64748b;
      --border: #e2e8f0; --white: #ffffff;
      --grad: linear-gradient(135deg, #0f172a 0%, #1e3a8a 60%, #1e40af 100%);
    }
    html { scroll-behavior: smooth; }
    body { font-family: 'Inter', sans-serif; background: var(--light); color: var(--navy); line-height: 1.7; }

    nav {
      position: fixed; top: 0; left: 0; right: 0; z-index: 100;
      background: rgba(15,23,42,0.95); backdrop-filter: blur(12px);
      display: flex; align-items: center; justify-content: space-between;
      padding: 0 2rem; height: 56px;
      border-bottom: 1px solid rgba(255,255,255,0.08);
    }
    .nav-logo { color: var(--white); font-weight: 700; font-size: 1rem; }
    .nav-logo span { color: var(--gold); }
    .nav-links { display: flex; gap: 1.5rem; list-style: none; }
    .nav-links a { color: rgba(255,255,255,0.7); text-decoration: none; font-size: 0.85rem; font-weight: 500; transition: color 0.2s; }
    .nav-links a:hover { color: var(--white); }

    .page-hero {
      background: var(--grad); padding: 90px 2rem 40px; text-align: center;
    }
    .page-hero .breadcrumb { color: rgba(255,255,255,0.6); font-size: 0.8rem; margin-bottom: 0.75rem; }
    .page-hero .breadcrumb a { color: rgba(255,255,255,0.6); text-decoration: none; }
    .page-hero .breadcrumb a:hover { color: var(--white); }
    .page-hero .breadcrumb .sep { margin: 0 0.4rem; }
    .page-hero h1 { font-family: 'Playfair Display', serif; font-size: clamp(1.8rem, 4vw, 2.6rem); color: var(--white); font-weight: 700; line-height: 1.2; margin-bottom: 0.6rem; }
    .page-hero .topic-badge { display: inline-block; background: rgba(245,158,11,0.15); border: 1px solid rgba(245,158,11,0.4); color: var(--gold); font-size: 0.72rem; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; padding: 0.3rem 1rem; border-radius: 100px; }

    .tag-row { display: flex; flex-wrap: wrap; gap: 0.4rem; justify-content: center; margin-top: 0.75rem; }
    .tag { background: rgba(255,255,255,0.1); color: rgba(255,255,255,0.8); border: 1px solid rgba(255,255,255,0.2); font-size: 0.72rem; font-weight: 500; padding: 0.2rem 0.6rem; border-radius: 100px; }

    .blog-container { max-width: 900px; margin: 2.5rem auto 4rem; padding: 0 1.5rem; }

    .toc-box { background: var(--white); border: 1px solid var(--border); border-radius: 12px; padding: 1.5rem 2rem; margin-bottom: 2.5rem; }
    .toc-box h2 { font-size: 1rem; font-weight: 700; color: var(--navy); margin-bottom: 1rem; }
    .toc-box ol { padding-left: 1.25rem; }
    .toc-box ol li { font-size: 0.85rem; margin-bottom: 0.35rem; }
    .toc-box ol li a { color: var(--accent); text-decoration: none; }
    .toc-box ol li a:hover { text-decoration: underline; }

    .section { margin-bottom: 3rem; scroll-margin-top: 70px; }
    .section-header { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.25rem; padding-bottom: 0.75rem; border-bottom: 2px solid var(--border); }
    .section-num { background: var(--navy); color: var(--white); font-size: 0.72rem; font-weight: 700; width: 28px; height: 28px; border-radius: 6px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
    .section-header h2 { font-family: 'Playfair Display', serif; font-size: 1.4rem; color: var(--navy); }

    h3 { font-size: 1rem; font-weight: 700; color: var(--navy); margin: 1.5rem 0 0.6rem; display: flex; align-items: center; gap: 0.5rem; }
    h3::before { content: ''; display: inline-block; width: 4px; height: 1em; background: var(--accent); border-radius: 2px; flex-shrink: 0; }
    p { font-size: 0.9rem; color: #475569; margin-bottom: 0.75rem; }
    ul, ol { margin: 0.5rem 0 0.75rem 1.4rem; }
    ul li, ol li { font-size: 0.88rem; color: #475569; margin-bottom: 0.4rem; }

    .code-block { background: var(--navy); color: #e2e8f0; border-radius: 10px; padding: 1.25rem 1.5rem; font-family: 'Courier New', Courier, monospace; font-size: 0.82rem; line-height: 1.7; overflow-x: auto; margin: 1rem 0 1.25rem; position: relative; }
    .code-block .lang-tag { position: absolute; top: 0.6rem; right: 0.8rem; font-size: 0.65rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: var(--gold); opacity: 0.8; }
    .code-block .kw  { color: #93c5fd; }
    .code-block .cl  { color: #fde68a; }
    .code-block .cm  { color: #6b7280; font-style: italic; }
    .code-block .st  { color: #86efac; }
    .code-block .an  { color: #fb923c; }

    .tip-box { display: flex; gap: 0.75rem; align-items: flex-start; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 10px; padding: 1rem 1.1rem; margin: 1rem 0; }
    .tip-box .icon { font-size: 1.1rem; flex-shrink: 0; }
    .tip-box p { font-size: 0.85rem; color: var(--blue); margin: 0; }
    .warn-box { display: flex; gap: 0.75rem; align-items: flex-start; background: #fffbeb; border: 1px solid #fde68a; border-radius: 10px; padding: 1rem 1.1rem; margin: 1rem 0; }
    .warn-box .icon { font-size: 1.1rem; flex-shrink: 0; }
    .warn-box p { font-size: 0.85rem; color: #92400e; margin: 0; }

    table { width: 100%; border-collapse: collapse; font-size: 0.85rem; margin: 1rem 0 1.25rem; }
    th { background: var(--navy); color: var(--white); padding: 0.65rem 1rem; text-align: left; font-size: 0.78rem; font-weight: 600; letter-spacing: 0.04em; }
    td { padding: 0.6rem 1rem; border-bottom: 1px solid var(--border); color: #475569; vertical-align: top; }
    tr:nth-child(even) td { background: #f8fafc; }

    .timeline { list-style: none; padding: 0; margin: 1rem 0; }
    .timeline li { display: flex; gap: 1.2rem; align-items: flex-start; padding: 0.6rem 0; border-left: 2px solid var(--border); padding-left: 1.2rem; margin-left: 0.5rem; position: relative; }
    .timeline li::before { content: ''; position: absolute; left: -6px; top: 1rem; width: 10px; height: 10px; border-radius: 50%; background: var(--accent); border: 2px solid var(--white); }
    .timeline .year { font-size: 0.78rem; font-weight: 700; color: var(--accent); white-space: nowrap; min-width: 50px; padding-top: 0.1rem; }
    .timeline .event { font-size: 0.85rem; color: #475569; }

    .interview-q { background: var(--white); border: 1px solid var(--border); border-radius: 10px; padding: 1.1rem 1.25rem; margin-bottom: 0.9rem; }
    .interview-q .q { font-size: 0.9rem; font-weight: 600; color: var(--navy); margin-bottom: 0.5rem; }
    .interview-q .a { font-size: 0.85rem; color: #475569; }
    .interview-q .a strong { color: var(--navy); }

    .back-link { display: inline-flex; align-items: center; gap: 0.4rem; color: var(--accent); text-decoration: none; font-size: 0.85rem; font-weight: 500; margin-bottom: 1.5rem; }
    .back-link:hover { text-decoration: underline; }

    @media (max-width: 768px) {
      .blog-container { padding: 0 1rem; }
      .nav-links { display: none; }
    }
  </style>
</head>
<body>

  <nav>
    <div class="nav-logo">SD<span>.</span></div>
    <ul class="nav-links">
      <li><a href="../index.html">Home</a></li>
      <li><a href="../profile.html">About</a></li>
      <li><a href="./index.html" class="active">Blog</a></li>
    </ul>
  </nav>

  <div class="page-hero">
    <div class="breadcrumb">
      <a href="index.html">Blog</a>
      <span class="sep">›</span>
      <span>TOPIC_DISPLAY</span>
      <span class="sep">›</span>
      <span>SUBTOPIC_DISPLAY</span>
    </div>
    <h1>SUBTOPIC_DISPLAY — Comprehensive Deep Dive</h1>
    <div class="topic-badge">TOPIC_DISPLAY</div>
    <div class="tag-row">
      <!-- INSERT TAGS HERE -->
    </div>
  </div>

  <div class="blog-container">
    <a href="index.html" class="back-link">← Back to Blog</a>

    <!-- TABLE OF CONTENTS -->
    <div class="toc-box">
      <h2>📋 Table of Contents</h2>
      <ol>
        <li><a href="#s1">What is SUBTOPIC_DISPLAY?</a></li>
        <li><a href="#s2">Why Does It Exist?</a></li>
        <li><a href="#s3">Who Should Know This?</a></li>
        <li><a href="#s4">History &amp; Evolution</a></li>
        <li><a href="#s5">Core Concepts — Basic 🟢</a></li>
        <li><a href="#s6">Core Concepts — Intermediate 🟡</a></li>
        <li><a href="#s7">Core Concepts — Advanced 🔴</a></li>
        <li><a href="#s8">Architecture &amp; Internals</a></li>
        <li><a href="#s9">Key Features</a></li>
        <li><a href="#s10">Key Benefits</a></li>
        <li><a href="#s11">Key Challenges &amp; Pitfalls</a></li>
        <li><a href="#s12">Best Practices</a></li>
        <li><a href="#s13">Ecosystem, Tools &amp; Integrations</a></li>
        <li><a href="#s14">Competitors &amp; Comparison</a></li>
        <li><a href="#s15">Key Trends &amp; Future Outlook</a></li>
        <li><a href="#s16">Interview Questions 🎯</a></li>
      </ol>
    </div>

    <!-- SECTIONS s1 through s16 go here, following the section structure above -->
    <!-- Each section uses: <div class="section" id="sN"> with <div class="section-header"> -->

  </div>

</body>
</html>
```

---

## Rules & Constraints
- ✅ Always generate **all 16 sections** + the TOC
- ✅ HTML file must be **fully standalone** (no external dependencies except Google Fonts)
- ✅ Must match the visual style of the existing `index.html`
- ✅ Use `<div class="code-block">` for ALL code snippets with `<span class="lang-tag">` labels
- ✅ Use `<div class="tip-box">` and `<div class="warn-box">` for callouts
- ✅ Use HTML `<table>` for comparison tables
- ✅ Timeline section uses `<ul class="timeline">` — no Mermaid
- ✅ Interview questions must have **"What a great answer covers"** guidance
- ✅ `index.html` must be updated with a `window.location.href` link to the new file
- ✅ Use DC: write_file in chunks of ≤ 30 lines
- ❌ Do not hallucinate version numbers, dates, or statistics
- ❌ Do not skip sections even if information is sparse
- ❌ Do not make interview questions trivially easy — they must be senior-level
- ❌ Do not use Mermaid.js — render diagrams as CSS/HTML
