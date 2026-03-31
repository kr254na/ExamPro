<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%
    // Security check: Ensure student is logged in and exam session is active
    if (session.getAttribute("user") == null || session.getAttribute("currentExamQuestions") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live Examination | ExamPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        /* ─── CSS VARIABLES FROM YOUR THEME ────────────────── */
        :root {
            --bg: #080c14;
            --surface: #0e1420;
            --panel: #0b1120;
            --border: rgba(255,255,255,.07);
            --accent: #3b8ef3;
            --accent2: #6c63ff;
            --success: #22d4a0;
            --text: #e8edf5;
            --muted: #6b7a99;
            --danger: #ff5e7d;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: var(--bg); font-family: 'DM Sans', sans-serif; color: var(--text); display: flex; height: 100vh; overflow: hidden; }

        /* ─── SIDEBAR (QUESTION PALETTE) ───────────────────── */
        .sidebar {
            width: 280px; background: var(--panel); border-right: 1px solid var(--border);
            display: flex; flex-direction: column; padding: 1.5rem;
        }

        .sidebar-header { margin-bottom: 2rem; }
        .sidebar-logo { font-family: 'Syne', sans-serif; font-weight: 800; color: var(--accent2); margin-bottom: 1.5rem; }

        .progress-container { margin-bottom: 2rem; }
        .progress-label { display: flex; justify-content: space-between; font-size: 0.7rem; color: var(--muted); margin-bottom: 8px; text-transform: uppercase; }
        .progress-bar { height: 6px; background: rgba(255,255,255,0.05); border-radius: 10px; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, var(--accent), var(--accent2)); transition: 0.5s; }

        .palette-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; overflow-y: auto; padding-right: 5px; }
        .palette-btn {
            aspect-ratio: 1; border-radius: 10px; border: 1px solid var(--border);
            background: rgba(255,255,255,0.03); color: var(--muted); font-family: 'Syne', sans-serif;
            font-weight: 700; cursor: pointer; transition: 0.2s; text-decoration: none; display: grid; place-items: center;
        }
        .palette-btn.active { border-color: var(--accent2); color: var(--text); background: rgba(108,99,255,0.1); }
        .palette-btn.answered { background: var(--success); color: #080c14; border: none; }

        /* Enhanced Review Buttons */
        .btn-mark, .btn-unmark {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 0.8rem 1.5rem;
            border-radius: 12px;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid var(--accent2);
        }

        /* State: Not yet marked */
        .btn-mark {
            background: rgba(108, 99, 255, 0.1);
            color: var(--accent2);
        }

        .btn-mark:hover {
            background: var(--accent2);
            color: white;
            box-shadow: 0 0 15px rgba(108, 99, 255, 0.4);
        }

        /* State: Already marked (Unmark mode) */
        .btn-unmark {
            background: var(--accent2);
            color: white;
            box-shadow: 0 0 10px rgba(108, 99, 255, 0.3);
        }

        .btn-unmark:hover {
            background: transparent;
            color: var(--accent2);
        }

        .btn-icon {
            font-size: 1.1rem;
        }

        /* Palette Animation for Review */
        .palette-btn.review {
            background: var(--accent2) !important;
            color: white !important;
            border: none;
            animation: pulse-purple 2s infinite;
        }

        .palette-btn.answered-review {
            background: linear-gradient(135deg, var(--success) 0%, var(--accent2) 100%) !important;
            color: #080c14 !important; /* Dark text for better contrast on green/purple */
            border: none;
            box-shadow: 0 0 10px rgba(108, 99, 255, 0.4);
            animation: pulse-purple 2s infinite;
        }

        .palette-btn.answered-review {
            font-weight: 800;
        }

        @keyframes pulse-purple {
            0% { box-shadow: 0 0 0 0 rgba(108, 99, 255, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(108, 99, 255, 0); }
            100% { box-shadow: 0 0 0 0 rgba(108, 99, 255, 0); }
        }

        /* ─── MAIN EXAM AREA ───────────────────────────────── */
        .main-exam { flex: 1; display: flex; flex-direction: column; background: var(--bg); }

        .top-bar {
            padding: 1.5rem 3rem; border-bottom: 1px solid var(--border);
            display: flex; justify-content: space-between; align-items: center; background: var(--surface);
        }
        .timer-box {
            background: rgba(255,94,125,0.1); color: var(--danger); padding: 0.6rem 1.2rem;
            border-radius: 12px; font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.2rem;
            border: 1px solid rgba(255,94,125,0.2);
        }

        .question-content { flex: 1; padding: 4rem 6rem; overflow-y: auto; }
        .q-number { color: var(--accent2); font-weight: 800; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 1rem; display: block; }
        .q-text { font-family: 'Syne', sans-serif; font-size: 1.8rem; line-height: 1.4; margin-bottom: 3rem; }

        /* Options */
        .options-list { display: grid; gap: 15px; max-width: 700px; }
        .option-card {
            background: var(--surface); border: 1px solid var(--border); padding: 1.2rem 1.5rem;
            border-radius: 16px; cursor: pointer; display: flex; align-items: center; gap: 15px;
            transition: 0.3s; position: relative;
        }
        .option-card:hover { border-color: var(--accent); background: rgba(59,142,243,0.05); }
        .option-card input { appearance: none; -webkit-appearance: none; }
        .option-card.selected { border-color: var(--accent); background: rgba(59,142,243,0.1); }
        .option-card.selected::before {
            content: '✓'; position: absolute; right: 20px; color: var(--accent); font-weight: 900;
        }
        .option-letter {
            width: 30px; height: 30px; background: rgba(255,255,255,0.05);
            border-radius: 8px; display: grid; place-items: center; font-weight: 800; font-size: 0.8rem;
        }

        /* ─── FOOTER NAVIGATION ────────────────────────────── */
        .exam-footer {
            padding: 1.5rem 3rem; border-top: 1px solid var(--border);
            display: flex; justify-content: space-between; background: var(--surface);
        }
        .btn-nav {
            padding: 0.8rem 2rem; border-radius: 12px; border: 1px solid var(--border);
            background: rgba(255,255,255,0.05); color: var(--text); font-weight: 700;
            cursor: pointer; transition: 0.3s; text-decoration: none;
        }
        .btn-nav:hover { background: var(--accent); border-color: var(--accent); }
        .btn-primary { background: var(--accent2); border: none; color: white; }
        .btn-submit { background: var(--success); color: #080c14; border: none; }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (EXAM ENGINE) ─── */

        @media (max-width: 1024px) {
            body { flex-direction: column; overflow: auto; }

            /* Transform Sidebar into a Collapsible Top Section */
            .sidebar {
                width: 100%;
                height: auto;
                border-right: none;
                border-bottom: 1px solid var(--border);
                padding: 1rem;
                order: 2; /* Move palette below the question on very small screens if desired */
            }

            .palette-grid {
                grid-template-columns: repeat(8, 1fr); /* More columns for wider tablet view */
                max-height: 120px;
            }

            .question-content {
                padding: 2rem;
            }
        }

        @media (max-width: 768px) {
            .top-bar {
                padding: 1rem;
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .timer-box {
                font-size: 1rem;
                padding: 0.4rem 0.8rem;
            }

            .q-text {
                font-size: 1.3rem;
                margin-bottom: 2rem;
            }

            .options-list {
                max-width: 100%;
            }

            .option-card {
                padding: 1rem;
            }

            .exam-footer {
                padding: 1rem;
                flex-wrap: wrap; /* Stack buttons if they don't fit */
                gap: 10px;
            }

            .btn-nav, .btn-mark, .btn-unmark {
                flex: 1;
                justify-content: center;
                font-size: 0.8rem;
                padding: 0.7rem 1rem;
            }
        }

        @media (max-width: 480px) {
            .sidebar {
                padding: 0.8rem;
            }

            .palette-grid {
                grid-template-columns: repeat(5, 1fr); /* 5 buttons per row on phones */
            }

            .sidebar-header, .sidebar div[style*="margin-top: auto"] {
                display: none; /* Hide logo and legend on tiny screens to save space */
            }

            .q-number { font-size: 0.6rem; }

            .btn-text { display: none; } /* Show only icons for Mark for Review on tiny screens */
            .btn-icon { font-size: 1.2rem; }

            /* Final Submit should always be prominent */
            .btn-submit {
                width: 100%;
                order: -1; /* Push to top of footer stack */
            }
        }

        /* ─── MOBILE TOUCH OPTIMIZATION ─── */
        @media (pointer: coarse) {
            .option-card {
                min-height: 60px; /* Larger tap target for options */
            }

            .palette-btn {
                min-height: 44px; /* Accessible touch targets for palette */
            }

            /* Prevent text selection during exam */
            body {
                -webkit-user-select: none;
                user-select: none;
            }
        }


    </style>
</head>
<body>

    <aside class="sidebar">

        <div class="sidebar-header">
            <div class="sidebar-logo">LIVE EXAM ENGINE</div>
            <div class="progress-container">
                <div class="progress-label">
                    <span>Completion</span>
                    <span>${answeredCount}%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${answeredCount}%"></div>
                </div>
            </div>
        </div>
<div class="palette-grid">
    <c:forEach var="i" begin="1" end="${totalQuestions}">
        <c:set var="isAnswered" value="${sessionScope.answeredMap.containsKey(i)}" />
        <c:set var="isReview" value="${sessionScope.reviewSet.contains(i)}" />

        <a href="/student/live-test?q=${i}" style="text-decoration: none;">
           <div class="palette-btn
               ${currentIndex == i ? 'active' : ''}
               ${isAnswered && isReview ? 'answered-review' : (isReview ? 'review' : (isAnswered ? 'answered' : ''))}">
               ${i}
           </div>
        </a>
    </c:forEach>
</div>
    <div style="margin-top: auto; padding-top: 2rem; display: flex; flex-direction: column; gap: 8px;">
        <div style="display: flex; gap: 10px; font-size: 0.7rem; color: var(--muted); align-items: center;">
            <div style="width:12px; height:12px; background:var(--success); border-radius:3px;"></div> Answered
        </div>
        <div style="display: flex; gap: 10px; font-size: 0.7rem; color: var(--muted); align-items: center;">
            <div style="width:12px; height:12px; background:var(--accent2); border-radius:3px;"></div> Marked for Review
        </div>
        <div style="display: flex; gap: 10px; font-size: 0.7rem; color: var(--muted); align-items: center;">
            <div style="width:12px; height:12px; background: linear-gradient(135deg, var(--success), var(--accent2)); border-radius:3px;"></div> Answered & Review
        </div>
        <div style="display: flex; gap: 10px; font-size: 0.7rem; color: var(--muted); align-items: center;">
            <div style="width:12px; height:12px; background:rgba(108,99,255,0.1); border: 1px solid var(--accent2); border-radius:3px;"></div> Active
        </div>
    </div>
    </aside>

    <main class="main-exam">
        <div class="top-bar">
            <div>
                <h4 style="font-family: 'Syne';">${sessionScope.currentExamTitle}</h4>
                <p style="color: var(--muted); font-size: 0.8rem;">Candidate: ${sessionScope.user.username}</p>
            </div>
            <div class="timer-box" id="timer">00:00</div>
        </div>

        <div class="question-content">
            <span class="q-number">Question ${currentIndex} of ${sessionScope.totalQuestions}</span>
            <h2 class="q-text">${currentQuestion.questionText}</h2>

            <form id="examForm" action="/student/save-answer" method="POST">
                <input type="hidden" name="questionId" value="${sessionScope.currentQuestion.id}">
                <input type="hidden" name="nextIdx" id="nextIdx" value="${currentIndex + 1}">

                <div class="options-list">
                    <label class="option-card ${selectedAnswer == 'A' ? 'selected' : ''}">
                        <input type="radio" name="answer" value="A" ${selectedAnswer == 'A' ? 'checked' : ''} onchange="this.form.submit()">
                        <div class="option-letter">A</div>
                        <div class="option-text">${currentQuestion.optionA}</div>
                    </label>

                    <label class="option-card ${selectedAnswer == 'B' ? 'selected' : ''}">
                        <input type="radio" name="answer" value="B" ${selectedAnswer == 'B' ? 'checked' : ''} onchange="this.form.submit()">
                        <div class="option-letter">B</div>
                        <div class="option-text">${currentQuestion.optionB}</div>
                    </label>

                    <label class="option-card ${selectedAnswer == 'C' ? 'selected' : ''}">
                        <input type="radio" name="answer" value="C" ${selectedAnswer == 'C' ? 'checked' : ''} onchange="this.form.submit()">
                        <div class="option-letter">C</div>
                        <div class="option-text">${currentQuestion.optionC}</div>
                    </label>

                    <label class="option-card ${selectedAnswer == 'D' ? 'selected' : ''}">
                        <input type="radio" name="answer" value="D" ${selectedAnswer == 'D' ? 'checked' : ''} onchange="this.form.submit()">
                        <div class="option-letter">D</div>
                        <div class="option-text">${currentQuestion.optionD}</div>
                    </label>
                </div>
            </form>
        </div>

        <div class="exam-footer">
            <c:if test="${currentIndex > 1}">
                <a href="/student/live-test?q=${currentIndex - 1}" class="btn-nav">← Previous</a>
            </c:if>

            <c:if test="${not empty selectedAnswer}">
                    <button type="button" onclick="clearOption()" class="btn-nav"
                            style="color: var(--danger); border-color: rgba(255,94,125,0.2);">
                        Clear Answer ✕
                    </button>
                </c:if>

            <c:set var="isInReview" value="${sessionScope.reviewSet.contains(currentIndex)}" />

            <button type="button" onclick="toggleReview()" class="btn ${isInReview ? 'btn-unmark' : 'btn-mark'}">
                <span class="btn-icon">${isInReview ? '⚐' : '⚑'}</span>
                <span class="btn-text">${isInReview ? 'Unmark Review' : 'Mark for Review'}</span>
            </button>

            <c:if test="${currentIndex < totalQuestions}">
                <a href="/student/live-test?q=${currentIndex + 1}" class="btn-nav btn-primary">Next Question →</a>
            </c:if>
            <c:if test="${currentIndex == totalQuestions}">
                <button onclick="confirmSubmit()" class="btn-nav btn-submit">Final Submit ✦</button>
            </c:if>
        </div>
    </main>

    <form id="finalSubmitForm" action="/student/submit-exam" method="POST" style="display:none;"></form>

    <script>

    // Detect Tab Switching or Browser Minimizing
    document.addEventListener("visibilitychange", function() {
        if (document.hidden) {
            autoSubmitExam("Tab switching or browser minimization detected.");
        }
    });

    window.addEventListener('pageshow', function(event) {
        // persisted is true if the page was loaded from cache (Back button)
        if (event.persisted) {
            autoSubmitExam("Back button navigation detected via BFCache.");
        }
    });

    window.history.pushState(null, null, window.location.href);

    window.addEventListener('popstate', function(event) {
        autoSubmitExam("Back/Forward navigation detected.");
    });

    window.addEventListener("beforeunload", function (e) {
        autoSubmitExam("Browser closure detected.");
    });

    document.addEventListener('contextmenu', event => event.preventDefault());

    function autoSubmitExam(reason) {
        console.log("Auto-submitting: " + reason);

        if (window.isSubmitting) return;
        window.isSubmitting = true;

        document.getElementById("finalSubmitForm").submit();
    }

    function confirmSubmit() {
        if (confirm("Are you sure you want to submit? You cannot change your answers after this.")) {
            window.isSubmitting = true;
            document.getElementById("finalSubmitForm").submit();
        }
    }

        function clearOption() {

                const radios = document.getElementsByName('answer');
                for(let i = 0; i < radios.length; i++) {
                    radios[i].checked = false;
                }

                document.getElementById('examForm').submit();
            }

            function toggleReview() {
                const input = document.createElement("input");
                input.type = "hidden";
                input.name = "mode";
                input.value = "review";
                document.getElementById('examForm').appendChild(input);
                document.getElementById('examForm').submit();
            }

        // Timer Logic
        const endTime = ${sessionScope.examEndTime};

        function updateTimer() {
            const now = new Date().getTime();
            const distance = endTime - now;

            if (distance <= 0) {
                clearInterval(timerInterval);
                document.getElementById("timer").innerHTML = "00:00";
                alert("Time is up! Your exam will be submitted automatically.");
                document.getElementById("finalSubmitForm").submit();
                return;
            }

            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

            document.getElementById("timer").innerHTML =
                (minutes < 10 ? "0" + minutes : minutes) + ":" +
                (seconds < 10 ? "0" + seconds : seconds);


            if (minutes < 2) {
                document.querySelector('.timer-box').style.background = 'rgba(255, 94, 125, 0.3)';
            }
        }

        const timerInterval = setInterval(updateTimer, 1000);
        updateTimer();

    </script>
</body>
</html>