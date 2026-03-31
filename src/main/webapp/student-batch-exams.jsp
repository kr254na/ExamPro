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
    <title>Batch Exams | ExamPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
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
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.2rem;
            color: var(--accent2);
            margin-bottom: 3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-links { list-style: none; flex: 1; }
        .nav-links li { margin-bottom: 0.5rem; }
        .nav-links a {
            text-decoration: none;
            color: var(--muted);
            padding: 0.8rem 1rem;
            display: block;
            border-radius: 10px;
            transition: all 0.3s;
            font-weight: 500;
        }
        .nav-links a:hover, .nav-links a.active {
            background: rgba(108,99,255,0.1);
            color: var(--accent2);
        }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content {
            flex: 1;
            padding: 3rem;
            overflow-y: auto;
        }

        .back-nav {
            display: inline-flex;
            align-items: center;
            color: var(--muted);
            text-decoration: none;
            font-size: 0.9rem;
            margin-bottom: 2rem;
            transition: 0.3s;
            font-weight: 500;
        }
        .back-nav:hover { color: var(--accent2); transform: translateX(-5px); }

        header {
            margin-bottom: 3rem;
        }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2.2rem; margin-bottom: 0.5rem; }
        .batch-info { color: var(--accent2); font-weight: 700; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1px; }

        /* ─── EXAM GRID ──────────────────────────────── */

        /* Style for Completed Badge */
        .status-badge {
            position: absolute;
            top: 2rem;
            right: 2rem;
            font-size: 0.65rem;
            font-weight: 800;
            padding: 4px 12px;
            border-radius: 99px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .status-pending { background: rgba(108, 99, 255, 0.1); color: var(--accent2); border: 1px solid var(--accent2); }
        .status-completed { background: rgba(34, 212, 160, 0.1); color: var(--success); border: 1px solid var(--success); }

        /* Disabled Button Style */
        .btn-disabled {
            background: rgba(255, 255, 255, 0.05) !important;
            color: var(--muted) !important;
            cursor: not-allowed;
            border: 1px solid var(--border);
            box-shadow: none !important;
            transform: none !important;
        }
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 2rem;
        }

        .exam-card {
            background: linear-gradient(145deg, #10192c, #0e1420);
            padding: 2rem;
            border-radius: 24px;
            border: 1px solid var(--border);
            transition: all 0.4s ease;
            position: relative;
        }

        .exam-card:hover {
            border-color: var(--accent2);
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.4);
        }

        .subject-tag {
            font-size: 0.7rem;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            margin-bottom: 1rem;
            display: block;
        }

        .exam-card h3 {
            font-family: 'Syne', sans-serif;
            font-size: 1.4rem;
            margin-bottom: 1.5rem;
            color: var(--text);
            line-height: 1.2;
        }

        .exam-meta {
            display: flex;
            justify-content: space-between;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border);
        }

        .meta-item { display: flex; flex-direction: column; gap: 4px; }
        .meta-item label { font-size: 0.65rem; color: var(--muted); text-transform: uppercase; font-weight: 700; }
        .meta-item span { font-weight: 700; font-size: 1rem; color: var(--text); }

        .btn-start {
            display: block;
            width: 100%;
            text-align: center;
            padding: 1rem;
            background: linear-gradient(135deg, var(--accent2), #8a84ff);
            color: white;
            text-decoration: none;
            border-radius: 14px;
            font-weight: 800;
            font-family: 'Syne', sans-serif;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 1.5rem;
            transition: 0.3s;
        }

        .btn-start:hover {
            transform: scale(1.02);
            box-shadow: 0 10px 20px rgba(108,99,255,0.3);
        }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 5rem;
            background: rgba(255,255,255,0.01);
            border: 2px dashed var(--border);
            border-radius: 24px;
            color: var(--muted);
        }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (BATCH EXAMS) ─── */

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

            .main-content { padding: 2rem 1.2rem; }
        }

        @media (max-width: 768px) {
            header { text-align: center; }
            header h1 { font-size: 1.8rem; }

            .back-nav {
                margin-bottom: 1.5rem;
                justify-content: center;
                width: 100%;
            }

            .card-grid {
                grid-template-columns: 1fr; /* Force single column on mobile */
                gap: 1.5rem;
            }

            .exam-card {
                padding: 1.5rem;
            }

            /* Reposition status badge for better mobile flow */
            .status-badge {
                top: 1.5rem;
                right: 1.5rem;
                padding: 3px 10px;
            }

            .exam-card h3 {
                font-size: 1.2rem;
                margin-right: 60px; /* Prevent text from hitting the badge */
            }
        }

        @media (max-width: 480px) {
            .main-content { padding: 1.5rem 1rem; }

            header h1 { font-size: 1.5rem; }

            .exam-meta {
                padding-top: 1rem;
            }

            .meta-item span { font-size: 0.9rem; }

            .btn-start {
                padding: 0.9rem;
                font-size: 0.9rem;
                border-radius: 12px;
            }

            .empty-state {
                padding: 3rem 1rem;
            }
        }

        /* ─── TOUCH TARGETS & FEEDBACK ─── */
        @media (pointer: coarse) {
            .exam-card:hover {
                transform: none; /* Prevent sticky hover scaling on mobile */
            }

            .btn-start:active:not(.btn-disabled) {
                transform: scale(0.97);
                filter: brightness(1.2);
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
        <a href="/student/dashboard" class="back-nav">← Back to Dashboard</a>

        <header>
            <span class="batch-info">${batchName}</span>
            <h1>Available Exams</h1>
            <p style="color:var(--muted);">Select an assessment to begin. Ensure your environment is distraction-free.</p>
        </header>
<section class="card-grid">
    <c:choose>
        <%-- Case 1: Exams are available --%>
        <c:when test="${not empty exams}">
            <c:forEach var="exam" items="${exams}">
                <div class="exam-card">
                    <c:choose>
                        <c:when test="${exam.completed}">
                            <span class="status-badge status-completed">Completed ✓</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge status-pending">Pending</span>
                        </c:otherwise>
                    </c:choose>

                    <span class="subject-tag">${exam.subjectName}</span>
                    <h3>${exam.examTitle}</h3>

                    <div class="exam-meta">
                        <div class="meta-item">
                            <label>Duration</label>
                            <span>${exam.duration} Mins</span>
                        </div>
                        <div class="meta-item">
                            <label>Questions</label>
                            <span>${exam.questionCount} Qs</span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${exam.completed}">
                            <div class="btn-start btn-disabled">Assessment Finished</div>
                        </c:when>
                        <c:otherwise>
                            <a href="/student/exam-instructions?id=${exam.examId}" class="btn-start">Attempt Now →</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </c:when>

        <%-- Case 2: No exams found for this batch --%>
        <c:otherwise>
            <div class="empty-state">
                <div style="font-size: 3rem; margin-bottom: 1.5rem;">📝</div>
                <h3>No Exams Available</h3>
                <p>There are currently no assessments assigned to the <strong>${batchName}</strong> classroom.</p>
                <a href="/student/dashboard" class="btn-start" style="display: inline-block; width: auto; padding: 0.8rem 2rem; margin-top: 2rem;">Return to Dashboard</a>
            </div>
        </c:otherwise>
    </c:choose>
</section>
    </main>
<script>
function toggleMobileMenu() {
            const menu = document.getElementById("mobileMenu");
            menu.classList.toggle("show");
        }
</script>
</body>
</html>