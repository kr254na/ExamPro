<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%
    if (session.getAttribute("user") == null || !"STUDENT".equals(session.getAttribute("role"))) {
        response.sendRedirect("/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Instructions | ExamPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #080c14;
            --surface: #0e1420;
            --panel: #0b1120;
            --border: rgba(255,255,255,.07);
            --accent2: #6c63ff;
            --success: #22d4a0;
            --text: #e8edf5;
            --muted: #6b7a99;
            --danger: #ff5e7d;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background-color: var(--bg);
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            display: flex;
            min-height: 100vh;
        }

        /* ─── SIDEBAR ────────────────────────────────── */
        .sidebar {
            width: 260px;
            background: var(--panel);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            padding: 2rem 1.5rem;
        }

        .logo {
            font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.2rem;
            color: var(--accent2); margin-bottom: 3rem;
            display: flex; align-items: center; gap: 10px;
        }

        .nav-links { list-style: none; flex: 1; }
        .nav-links a {
            text-decoration: none; color: var(--muted); padding: 0.8rem 1rem;
            display: block; border-radius: 10px; transition: 0.3s;
        }
        .nav-links a.active { background: rgba(108,99,255,0.1); color: var(--accent2); }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content {
            flex: 1; padding: 3rem;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
        }

        .instruction-card {
            width: 100%;
            max-width: 700px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 28px;
            padding: 3rem;
            box-shadow: 0 25px 50px rgba(0,0,0,0.4);
        }

        header { text-align: center; margin-bottom: 2.5rem; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2.2rem; margin-bottom: 0.5rem; }
        .subject-badge {
            color: var(--accent2); font-weight: 800; font-size: 0.8rem;
            text-transform: uppercase; letter-spacing: 2px; display: block; margin-bottom: 10px;
        }

        .rules-container {
            background: rgba(255,255,255,0.02);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2.5rem;
        }

        .rules-list { list-style: none; }
        .rules-list li {
            display: flex;
            gap: 15px;
            margin-bottom: 1.2rem;
            color: var(--text);
            font-size: 0.95rem;
            line-height: 1.5;
        }
        .rules-list li span { color: var(--accent2); font-weight: bold; }

        .stat-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 2.5rem;
        }
        .stat-box {
            background: var(--panel);
            padding: 1rem;
            border-radius: 14px;
            text-align: center;
            border: 1px solid var(--border);
        }
        .stat-box label { display: block; font-size: 0.65rem; color: var(--muted); text-transform: uppercase; margin-bottom: 5px; }
        .stat-box span { font-weight: 800; font-size: 1.1rem; color: var(--text); }

        .confirmation {
            display: flex;
            gap: 12px;
            margin-bottom: 2.5rem;
            align-items: flex-start;
            cursor: pointer;
        }
        .confirmation input { margin-top: 4px; accent-color: var(--success); }
        .confirmation p { font-size: 0.85rem; color: var(--muted); line-height: 1.6; }

        .btn-begin {
            width: 100%;
            padding: 1.2rem;
            background: linear-gradient(135deg, var(--success), #18a67d);
            color: #080c14;
            border: none;
            border-radius: 16px;
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: 0.4s;
        }
        .btn-begin:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(34,212,160,0.3); }

        .cancel-link {
            display: block; text-align: center; margin-top: 1.5rem;
            color: var(--muted); text-decoration: none; font-size: 0.85rem; transition: 0.3s;
        }
        .cancel-link:hover { color: var(--danger); }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (EXAM INSTRUCTIONS) ─── */

        @media (max-width: 1024px) {
            body { flex-direction: column; }

            .sidebar {
                width: 100%; height: auto; padding: 1rem 1.5rem;
                flex-direction: row; align-items: center; justify-content: space-between;
                position: sticky; top: 0; z-index: 100;
                background: rgba(11, 17, 32, 0.95); backdrop-filter: blur(10px);
                border-right: none; border-bottom: 1px solid var(--border);
            }

            .nav-links { display: none; }

            .main-content { padding: 2rem 1rem; }
        }

        @media (max-width: 768px) {
            .instruction-card {
                padding: 2rem 1.5rem;
                border-radius: 20px;
            }

            header h1 { font-size: 1.8rem; }
            header p { font-size: 0.85rem; }

            /* Stack the stats horizontally for better readability */
            .stat-row {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .stat-box {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0.8rem 1.2rem;
                text-align: left;
            }

            .stat-box label { margin-bottom: 0; }
            .stat-box span { font-size: 1rem; }

            .rules-container {
                padding: 1.5rem;
            }

            .rules-list li {
                font-size: 0.85rem;
                margin-bottom: 1rem;
            }
        }

        @media (max-width: 480px) {
            .instruction-card {
                padding: 1.5rem 1rem;
                background: transparent;
                border: none;
                box-shadow: none;
            }

            header h1 { font-size: 1.6rem; }

            .subject-badge { font-size: 0.7rem; letter-spacing: 1.5px; }

            .confirmation p { font-size: 0.8rem; }

            .btn-begin {
                padding: 1rem;
                font-size: 0.9rem;
                border-radius: 12px;
            }

            .cancel-link { font-size: 0.8rem; margin-top: 2rem; }
        }

        /* ─── TOUCH & ACCESSIBILITY TWEAKS ─── */
        @media (pointer: coarse) {
            .confirmation {
                padding: 12px;
                background: rgba(255, 255, 255, 0.03);
                border-radius: 10px;
            }

            .btn-begin:active {
                transform: scale(0.98);
                background: var(--success);
            }
        }

        /* --- Global Styles --- */
        .menu-toggle {
            display: none; /* Hide on Desktop */
        }

        .mobile-only {
            display: none; /* Hide on Desktop */
        }

        /* --- Responsive Styles (Inside @media max-width: 1024px) --- */
        @media (max-width: 1024px) {
            .menu-toggle {
                display: block !important; /* Force show on mobile */
                background: rgba(255,255,255,0.05);
                border: 1px solid var(--border);
                color: var(--accent);
                font-size: 1.5rem;
                padding: 0.5rem 0.8rem;
                border-radius: 8px;
                cursor: pointer;
                z-index: 101;
            }

            .desktop-only-logout {
                display: none !important; /* Hide the bottom logout on mobile */
            }

            .mobile-only {
                display: block; /* Show logout inside the menu */
                border-top: 1px solid var(--border);
                margin-top: 1rem;
            }

            .nav-links {
                display: none; /* Hidden by default */
                position: absolute;
                top: 100%;
                left: 0;
                width: 100%;
                background: var(--panel);
                flex-direction: column;
                padding: 1.5rem;
                border-bottom: 1px solid var(--border);
                z-index: 100;
            }

            .nav-links.show {
                display: flex !important; /* Show when toggled */
            }
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <div style="width:10px; height:10px; background:var(--accent2); border-radius:50%; box-shadow:0 0 10px var(--accent2);"></div>
            ExamPro Student
        </div>
        <button class="menu-toggle" onclick="toggleMobileMenu()">☰</button>
        <ul class="nav-links" id="mobileMenu">
            <li><a href="/student/dashboard" class="active">Dashboard</a></li>
            <li><a href="/student/results">Results</a></li>
        </ul>
        <a href="/LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <div class="instruction-card">
            <header>
                <span class="subject-badge">${exam.subjectName}</span>
                <h1>Examinee Guidelines</h1>
                <p style="color: var(--muted);">Please review the exam details and rules before starting.</p>
            </header>

            <div class="stat-row">
                <div class="stat-box">
                    <label>Exam Title</label>
                    <span>${exam.examTitle}</span>
                </div>
                <div class="stat-box">
                    <label>Duration</label>
                    <span>${exam.duration} Mins</span>
                </div>
                <div class="stat-box">
                    <label>Questions</label>
                    <span>${exam.questionCount} Questions</span>
                </div>
            </div>

            <div class="rules-container">
                <ul class="rules-list">
                    <li><span>1.</span> Ensure you have a stable internet connection before clicking "Begin".</li>
                    <li><span>2.</span> The timer will start immediately and cannot be paused.</li>
                    <li><span>3.</span> Switching tabs or refreshing the page may result in auto-submission.</li>
                    <li><span>4.</span> All questions are multiple-choice. Ensure you save each answer.</li>
                    <li><span>5.</span> System will auto-submit once the time expires.</li>
                </ul>
            </div>

            <form action="/student/start-exam" method="POST">
                <input type="hidden" name="examId" value="${exam.examId}">

                <label class="confirmation">
                    <input type="checkbox" required>
                    <p>I confirm that I am ready to begin the exam. I have read the rules and understand that once started, the attempt will count towards my final grade.</p>
                </label>

                <button type="submit" class="btn-begin">Begin Examination →</button>
            </form>

            <a href="/student/dashboard" class="cancel-link">Not ready? Go back to Dashboard</a>
        </div>
    </main>
    <script>
    function toggleMobileMenu() {
                const menu = document.getElementById("mobileMenu");
                menu.classList.toggle("show");
            }
    </script>
</body>
</html>