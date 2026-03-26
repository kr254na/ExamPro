<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        /* ─── TOKENS ──────────────────────────────────────────────── */
        :root {
            --bg:        #080c14;
            --surface:   #0e1420;
            --panel:     #0b1120;
            --border:    rgba(255,255,255,.07);
            --border-hi: rgba(99,179,237,.35);
            --accent:    #3b8ef3;
            --accent2:   #6c63ff;
            --success:   #22d4a0;
            --danger:    #ff5e7d;
            --text:      #e8edf5;
            --muted:     #6b7a99;
            --sidebar-w: 220px;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }

        body {
            background: var(--bg);
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            overflow: hidden;
        }

        /* ambient blobs */
        body::before, body::after {
            content: ''; position: fixed; border-radius: 50%;
            filter: blur(140px); pointer-events: none; z-index: 0;
        }
        body::before {
            width: 700px; height: 700px;
            background: radial-gradient(circle, rgba(59,142,243,.11) 0%, transparent 70%);
            top: -200px; right: -100px;
        }
        body::after {
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(108,99,255,.09) 0%, transparent 70%);
            bottom: -120px; left: -80px;
        }

        /* ─── APP SHELL ───────────────────────────────────────────── */
        .app {
            position: relative; z-index: 1;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* ─── SIDEBAR ─────────────────────────────────────────────── */
        .sidebar {
            width: var(--sidebar-w);
            flex-shrink: 0;
            background: var(--panel);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            animation: slideIn .5s cubic-bezier(.22,.97,.46,1) both;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to   { opacity: 1; transform: translateX(0); }
        }

        .sidebar-header {
            padding: 1.4rem 1.2rem 1rem;
            border-bottom: 1px solid var(--border);
            flex-shrink: 0;
        }
        .sidebar-logo {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: .8rem;
            letter-spacing: .1em;
            text-transform: uppercase;
            color: var(--accent);
            display: flex;
            align-items: center;
            gap: .5rem;
            margin-bottom: 1rem;
        }
        .sidebar-logo::before {
            content: '';
            width: 7px; height: 7px;
            border-radius: 50%;
            background: var(--accent);
            box-shadow: 0 0 8px var(--accent);
            animation: pulse 2s ease-in-out infinite;
            flex-shrink: 0;
        }
        @keyframes pulse {
            0%,100% { opacity:1; transform:scale(1); }
            50%      { opacity:.4; transform:scale(.6); }
        }

        .progress-wrap { display: flex; flex-direction: column; gap: .35rem; }
        .progress-meta {
            display: flex;
            justify-content: space-between;
            font-size: .65rem;
            letter-spacing: .06em;
            text-transform: uppercase;
            color: var(--muted);
            font-weight: 500;
        }
        .progress-track {
            height: 4px;
            border-radius: 99px;
            background: rgba(255,255,255,.06);
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            border-radius: 99px;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
        }

        .legend {
            display: flex;
            gap: .8rem;
            padding: .7rem 1.2rem;
            border-bottom: 1px solid var(--border);
            flex-shrink: 0;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: .35rem;
            font-size: .62rem;
            letter-spacing: .06em;
            text-transform: uppercase;
            color: var(--muted);
            font-weight: 500;
        }
        .legend-dot {
            width: 8px; height: 8px;
            border-radius: 3px;
            flex-shrink: 0;
        }
        .legend-dot.g { background: var(--success); }
        .legend-dot.r { background: var(--danger); }

        .palette-scroll {
            flex: 1;
            overflow-y: auto;
            padding: 1rem 1.2rem;
            scrollbar-width: thin;
            scrollbar-color: rgba(255,255,255,.08) transparent;
        }
        .palette-scroll::-webkit-scrollbar { width: 4px; }
        .palette-scroll::-webkit-scrollbar-thumb { background: rgba(255,255,255,.08); border-radius: 99px; }

        .palette-label {
            font-size: .6rem;
            letter-spacing: .12em;
            text-transform: uppercase;
            color: var(--muted);
            font-weight: 500;
            margin-bottom: .6rem;
        }
        .palette {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: .4rem;
        }
        .palette button {
            aspect-ratio: 1;
            width: 100%;
            border-radius: 8px;
            border: 1px solid transparent;
            font-family: 'Syne', sans-serif;
            font-size: .72rem;
            font-weight: 700;
            cursor: pointer;
            transition: transform .15s, filter .15s;
            display: grid;
            place-items: center;
            outline: none;
        }
        .palette button:hover {
            transform: scale(1.12);
            filter: brightness(1.3);
            z-index: 2;
            position: relative;
        }
        .palette button:active { transform: scale(.9); }
        .palette button.green {
            background: linear-gradient(135deg, #1a3d2e, #1f4535);
            border-color: rgba(34,212,160,.28);
            color: var(--success);
            box-shadow: 0 0 8px rgba(34,212,160,.15);
        }
        .palette button.red {
            background: linear-gradient(135deg, #2d1620, #361b25);
            border-color: rgba(255,94,125,.22);
            color: var(--danger);
            box-shadow: 0 0 7px rgba(255,94,125,.1);
        }
        .palette button.purple {
            background: linear-gradient(135deg, #4a148c, #6a1b9a);
            border-color: rgba(171, 71, 188, 0.4);
            color: #e1bee7;
            box-shadow: 0 0 10px rgba(106, 27, 154, 0.3);
        }
        .sidebar-stats {
            padding: .9rem 1.2rem;
            border-top: 1px solid var(--border);
            display: flex;
            gap: .5rem;
            flex-shrink: 0;
        }
        .stat-pill {
            flex: 1;
            background: rgba(255,255,255,.03);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: .5rem .4rem;
            text-align: center;
        }
        .stat-pill .sv {
            font-family: 'Syne', sans-serif;
            font-size: .95rem;
            font-weight: 800;
            display: block;
        }
        .stat-pill .sl {
            font-size: .55rem;
            letter-spacing: .08em;
            text-transform: uppercase;
            color: var(--muted);
            font-weight: 500;
        }
        .stat-pill.ok .sv { color: var(--success); }
        .stat-pill.ng .sv { color: var(--danger); }

        /* ─── MAIN ────────────────────────────────────────────────── */
        .main {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            animation: fadeUp .55s .1s cubic-bezier(.22,.97,.46,1) both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(18px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .topbar {
            background: linear-gradient(135deg, #0b1323, #0f1829);
            border-bottom: 1px solid var(--border);
            padding: 1.1rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
        }
        .topbar-title {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1rem;
            letter-spacing: .04em;
        }
        .topbar-title .num { color: var(--accent); }
        .topbar-title .tot { color: var(--muted); font-size: .85rem; font-weight: 400; font-family: 'DM Sans', sans-serif; }
        .q-badge {
            font-family: 'Syne', sans-serif;
            font-size: .68rem;
            font-weight: 700;
            color: var(--muted);
            background: rgba(255,255,255,.04);
            border: 1px solid var(--border);
            padding: .28rem .75rem;
            border-radius: 99px;
            letter-spacing: .05em;
        }

        .question-scroll {
            flex: 1;
            overflow-y: auto;
            padding: 2rem 2.5rem;
            scrollbar-width: thin;
            scrollbar-color: rgba(255,255,255,.06) transparent;
        }
        .question-scroll::-webkit-scrollbar { width: 4px; }
        .question-scroll::-webkit-scrollbar-thumb { background: rgba(255,255,255,.07); border-radius: 99px; }

        .q-tag {
            font-size: .65rem;
            letter-spacing: .14em;
            text-transform: uppercase;
            color: var(--muted);
            font-weight: 500;
            margin-bottom: .6rem;
        }
        .q-text {
            font-size: 1.1rem;
            font-weight: 400;
            line-height: 1.7;
            margin-bottom: 2rem;
            max-width: 660px;
        }

        .options-grid { display: grid; gap: .65rem; max-width: 660px; }

        .option-label {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: .9rem 1.15rem;
            background: rgba(255,255,255,.022);
            border: 1px solid var(--border);
            border-radius: 12px;
            cursor: pointer;
            transition: background .18s, border-color .18s, transform .15s;
            position: relative;
            overflow: hidden;
        }
        .option-label::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, rgba(59,142,243,.06), transparent 60%);
            opacity: 0;
            transition: opacity .2s;
        }
        .option-label:hover {
            background: rgba(59,142,243,.06);
            border-color: var(--border-hi);
            transform: translateX(5px);
        }
        .option-label:hover::after { opacity: 1; }

        .option-label input[type="radio"] {
            appearance: none; -webkit-appearance: none;
            width: 18px; height: 18px;
            border-radius: 50%;
            border: 2px solid var(--muted);
            flex-shrink: 0;
            position: relative;
            transition: border-color .2s, box-shadow .2s;
            z-index: 1;
        }
        .option-label input[type="radio"]::after {
            content: '';
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%,-50%) scale(0);
            width: 8px; height: 8px;
            border-radius: 50%;
            background: var(--accent);
            transition: transform .22s cubic-bezier(.34,1.56,.64,1);
        }
        .option-label input[type="radio"]:checked {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(59,142,243,.2);
        }
        .option-label input[type="radio"]:checked::after {
            transform: translate(-50%,-50%) scale(1);
        }
        .option-label:has(input:checked) {
            background: rgba(59,142,243,.08);
            border-color: rgba(59,142,243,.32);
        }
        .option-label:has(input:checked) .option-key {
            color: var(--accent);
            border-color: rgba(59,142,243,.4);
            background: rgba(59,142,243,.12);
        }

        .option-key {
            font-family: 'Syne', sans-serif;
            font-size: .7rem;
            font-weight: 800;
            letter-spacing: .05em;
            color: var(--muted);
            background: rgba(255,255,255,.05);
            border: 1px solid var(--border);
            border-radius: 6px;
            width: 26px; height: 26px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            transition: color .2s, border-color .2s, background .2s;
            z-index: 1;
        }
        .option-text {
            font-size: .92rem;
            line-height: 1.45;
            z-index: 1;
        }

        /* ─── ACTION BAR ──────────────────────────────────────────── */
        .action-bar {
            border-top: 1px solid var(--border);
            background: rgba(8,12,20,.7);
            backdrop-filter: blur(8px);
            padding: 1rem 2.5rem;
            display: flex;
            align-items: center;
            gap: .75rem;
            flex-shrink: 0;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            font-family: 'Syne', sans-serif;
            font-size: .75rem;
            font-weight: 700;
            letter-spacing: .06em;
            text-transform: uppercase;
            padding: .65rem 1.25rem;
            border-radius: 10px;
            border: 1px solid transparent;
            cursor: pointer;
            transition: transform .15s, filter .15s, box-shadow .2s;
            outline: none;
        }
        .btn:hover  { transform: translateY(-2px); filter: brightness(1.15); }
        .btn:active { transform: scale(.94); }

        .btn-prev {
            background: rgba(255,255,255,.04);
            border-color: var(--border);
            color: var(--muted);
        }
        .btn-prev:hover { border-color: rgba(255,255,255,.14); color: var(--text); }

        .btn-next {
            background: linear-gradient(135deg, #162d52, #1a3665);
            border-color: rgba(59,142,243,.32);
            color: #7ec8f7;
            box-shadow: 0 0 16px rgba(59,142,243,.13);
        }

        .btn-submit {
            margin-left: auto;
            background: linear-gradient(135deg, #5a52e0, #3b8ef3);
            border-color: rgba(108,99,255,.3);
            color: #fff;
            padding: .65rem 1.6rem;
            box-shadow: 0 0 22px rgba(90,82,224,.35), 0 4px 14px rgba(0,0,0,.3);
        }
        .btn-submit:hover {
            box-shadow: 0 0 32px rgba(90,82,224,.55), 0 6px 18px rgba(0,0,0,.4);
        }

        .btn-prev::before { content: '←'; font-size: .85rem; }
        .btn-next::after  { content: '→'; font-size: .85rem; }
        .btn-submit::before { content: '✦'; font-size: .7rem; }

        /* ─── RESPONSIVE ──────────────────────────────────────────── */
        @media (max-width: 700px) {
            body { overflow: auto; }
            .app { flex-direction: column; height: auto; min-height: 100vh; }
            .sidebar { width: 100%; border-right: none; border-bottom: 1px solid var(--border); }
            .palette { grid-template-columns: repeat(8, 1fr); }
            .sidebar-stats { display: none; }
            .main { overflow: visible; }
            .question-scroll { overflow: visible; padding: 1.5rem; }
            .topbar, .action-bar { padding-left: 1.5rem; padding-right: 1.5rem; }
            .btn-submit { margin-left: 0; }
            .action-bar { flex-wrap: wrap; }
        }
    </style>
</head>
<body>
    <%
        if (session == null || session.getAttribute("questions") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
    %>
<div class="app">

    <!-- ════════════════════════════
         SIDEBAR
    ════════════════════════════ -->
    <aside class="sidebar">

        <div class="sidebar-header">
            <div class="sidebar-logo">Exam Portal</div>
            <div class="progress-wrap">
                <div class="progress-meta">
                    <span>Progress</span>
                    <c:set var="answeredCount" value="0"/>
                    <c:forEach var="ans" items="${userAnswers}">
                        <c:if test="${ans != null}">
                            <c:set var="answeredCount" value="${answeredCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    <span>${answeredCount} / ${questions.size()}</span>
                </div>
                <div class="progress-track">
                    <div class="progress-fill"
                         style="width:${questions.size() > 0 ? (answeredCount * 100 / questions.size()) : 0}%">
                    </div>
                </div>
            </div>
        </div>

        <div class="legend">
            <div class="legend-item"><span class="legend-dot g"></span>Answered</div>
            <div class="legend-item"><span class="legend-dot r"></span>Skipped</div>
        </div>

        <div class="palette-scroll">
            <div class="palette-label">Questions</div>
            <div class="palette">
                <c:forEach var="q" items="${questions}" varStatus="status">
                    <a href="exam?action=jump&index=${status.index}" style="text-decoration: none;">
                        <button type="button" class="
                            ${reviewMap[status.index] ? 'purple' : (userAnswers[status.index] != null ? 'green' : 'red')}">
                            ${status.index + 1}
                        </button>
                    </a>
                </c:forEach>
            </div>
        </div>

        <div class="sidebar-stats">
            <div class="stat-pill ok">
                <span class="sv">${answeredCount}</span>
                <span class="sl">Done</span>
            </div>
            <div class="stat-pill ng">
                <span class="sv">${questions.size() - answeredCount}</span>
                <span class="sl">Left</span>
            </div>
        </div>

    </aside>

    <!-- ════════════════════════════
         MAIN
    ════════════════════════════ -->
    <main class="main">

        <div class="topbar">
            <div class="topbar-title">
                Question <span class="num">${currentIdx + 1}</span>
                <span class="tot">of ${questions.size()}</span>
            </div>

            <div style="display: flex; align-items: center; gap: 1rem;">
                <div id="timer-container" style="font-family: 'Syne', sans-serif; font-weight: 700; color: var(--accent2); background: rgba(108,99,255,.1); padding: .28rem .75rem; border-radius: 8px; border: 1px solid rgba(108,99,255,.2); min-width: 70px; text-align: center;">
                    <span id="timer"></span>
                </div>
                <span class="q-badge">In Progress</span>
            </div>
        </div>

        <div class="question-scroll">
            <div class="q-tag">Question ${currentIdx + 1}</div>
            <p class="q-text">${currentQuestion.questionText}</p>

            <%-- GET form for prev/next navigation --%>
            <form id="examForm" action="exam" method="get">
                <div class="options-grid">
                    <label class="option-label">
                        <input type="radio" name="answer" value="A"
                               ${userAnswers[currentIdx] == 'A' ? 'checked' : ''}>
                        <span class="option-key">A</span>
                        <span class="option-text">${currentQuestion.optionA}</span>
                    </label>
                    <label class="option-label">
                        <input type="radio" name="answer" value="B"
                               ${userAnswers[currentIdx] == 'B' ? 'checked' : ''}>
                        <span class="option-key">B</span>
                        <span class="option-text">${currentQuestion.optionB}</span>
                    </label>
                    <label class="option-label">
                        <input type="radio" name="answer" value="C"
                               ${userAnswers[currentIdx] == 'C' ? 'checked' : ''}>
                        <span class="option-key">C</span>
                        <span class="option-text">${currentQuestion.optionC}</span>
                    </label>
                    <label class="option-label">
                        <input type="radio" name="answer" value="D"
                               ${userAnswers[currentIdx] == 'D' ? 'checked' : ''}>
                        <span class="option-key">D</span>
                        <span class="option-text">${currentQuestion.optionD}</span>
                    </label>
                </div>
            </form>
        </div>

        <div class="action-bar">
            <button type="submit" form="examForm" name="action" value="prev"
                    class="btn btn-prev">Previous</button>
            <button type="submit" form="examForm" name="action" value="next"
                    class="btn btn-next">Next</button>
            <button type="submit" form="examForm" name="action" value="review"
                    class="btn" style="background: rgba(108,99,255,0.1); border-color: var(--accent2); color: var(--accent2);">
                    Mark for Review
            </button>
            <button type="button" class="btn btn-submit"
                    onclick="submitExam()">Submit Exam</button>
        </div>

    </main>
</div>

<%-- Hidden POST form — fires only on Submit Exam --%>
<form id="submitForm" action="exam" method="post" style="display:none;">
    <input type="hidden" name="action"  value="submit">
    <input type="hidden" name="answer"  id="hiddenAnswer">
</form>

<script>
    function submitExam() {
        const sel = document.querySelector('#examForm input[name="answer"]:checked');
        document.getElementById('hiddenAnswer').value = sel ? sel.value : '';
        document.getElementById('submitForm').submit();
    }
    const endTime = ${sessionScope.endTime};

        function updateTimer() {
            const now = new Date().getTime();
            const distance = endTime - now;

            if (distance < 0) {
                clearInterval(timerInterval);
                alert("Time is up! Your exam will be submitted automatically.");
                submitExam(); // This calls your existing submit function
                return;
            }

            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

            document.getElementById("timer").innerHTML =
                (minutes < 10 ? "0" + minutes : minutes) + ":" +
                (seconds < 10 ? "0" + seconds : seconds);
        }

        const timerInterval = setInterval(updateTimer, 1000);
</script>
</body>
</html>
