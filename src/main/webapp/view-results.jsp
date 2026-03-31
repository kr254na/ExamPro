<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%
    if (session.getAttribute("user") == null || !"TEACHER".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Results | Exam Pro Teacher</title>
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
            --danger: #ff5e7d;
            --warning: #ffb74d;
            --text: #e8edf5;
            --muted: #6b7a99;
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
            color: var(--accent);
            margin-bottom: 3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .nav-links { list-style: none; flex: 1; }
        .nav-links li { margin-bottom: 0.5rem; }
        .nav-links a { text-decoration: none; color: var(--muted); padding: 0.8rem 1rem; display: block; border-radius: 10px; transition: 0.3s; font-weight: 500;}
        .nav-links a:hover, .nav-links a.active { background: rgba(59,142,243,0.1); color: var(--accent); }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content { flex: 1; padding: 3rem; overflow-y: auto; }

        header { margin-bottom: 2.5rem; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2.2rem; margin-bottom: 0.5rem; }
        header p { color: var(--muted); font-size: 0.9rem; }

        /* ─── ANALYTICS CARDS ────────────────────────── */
        .analytics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }
        .ana-card {
            background: var(--surface);
            padding: 1.5rem;
            border-radius: 20px;
            border: 1px solid var(--border);
        }
        .ana-card span { font-size: 0.7rem; color: var(--muted); text-transform: uppercase; letter-spacing: 1px; }
        .ana-card h2 { font-family: 'Syne', sans-serif; font-size: 1.8rem; margin-top: 0.5rem; }

        /* ─── RESULTS TABLE CONTAINER (Horizontal Scroll Logic) ─── */
        .results-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 24px;
            overflow-x: auto;
            width: 100%;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            min-width: 1000px; /* Increased to accommodate extra columns */
        }

        th {
            background: rgba(255,255,255,0.02);
            padding: 1.2rem 1.5rem;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--muted);
            border-bottom: 1px solid var(--border);
        }

        td {
            padding: 1.2rem 1.5rem;
            font-size: 0.9rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
            white-space: nowrap;
        }

        tr:hover { background: rgba(255,255,255,0.01); }

        /* Typography & Pills */
        .student-name {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1rem;
            color: var(--text);
            display: block;
        }

        .sub-data {
            font-size: 0.85rem;
            color: var(--muted);
            font-weight: 500;
        }

        .score-pill {
            display: inline-block;
            padding: 0.4rem 0.8rem;
            border-radius: 99px;
            font-size: 0.8rem;
            font-weight: 700;
            font-family: 'Syne', sans-serif;
        }
        .pass { background: rgba(34,212,160,0.1); color: var(--success); }
        .fail { background: rgba(255,94,125,0.1); color: var(--danger); }
        .excellent { background: rgba(59, 142, 243, 0.1); color: var(--accent); }

        .percentage {
            font-weight: 700;
            color: var(--accent);
        }

        /* Scrollbar Styling */
        .results-container::-webkit-scrollbar { height: 6px; }
        .results-container::-webkit-scrollbar-track { background: var(--bg); border-radius: 10px; }
        .results-container::-webkit-scrollbar-thumb { background: var(--border); border-radius: 10px; }
        .results-container::-webkit-scrollbar-thumb:hover { background: var(--accent); }

        .empty-state { padding: 5rem; text-align: center; color: var(--muted); }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (EXAM RESULTS) ─── */

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

            /* Stack the Filter Form */
            form[action="/view-results"] {
                flex-direction: column;
                align-items: stretch !important;
                gap: 15px !important;
            }

            form div[style*="flex: 1"] {
                width: 100%;
            }

            form div[style*="display: flex; gap: 10px"] {
                justify-content: space-between;
            }

            form div[style*="display: flex; gap: 10px"] button,
            form div[style*="display: flex; gap: 10px"] a {
                flex: 1;
                text-align: center;
            }

            /* Analytics Grid Stacking */
            .analytics-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .ana-card {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1.2rem;
            }

            .ana-card h2 { margin-top: 0; font-size: 1.5rem; }

            /* Horizontal Scroll Hint for Table */
            .results-container::after {
                content: '← Swipe to view full report →';
                display: block;
                text-align: center;
                font-size: 0.7rem;
                color: var(--muted);
                padding: 12px;
                background: rgba(255,255,255,0.02);
            }
        }

        @media (max-width: 480px) {
            .main-content { padding: 1.5rem 1rem; }

            header h1 { font-size: 1.5rem; }

            /* Full-width Export Button */
            a[href*="export-results"] {
                width: 100%;
                justify-content: center;
                padding: 1rem !important;
            }

            .score-pill {
                font-size: 0.7rem;
                padding: 0.3rem 0.6rem;
            }
        }

        /* ─── TOUCH OPTIMIZATION ─── */
        @media (pointer: coarse) {
            .results-container::-webkit-scrollbar {
                height: 10px; /* Thicker for easier thumb control */
            }

            select {
                font-size: 16px; /* Prevents iOS auto-zoom */
                min-height: 48px;
            }

            button[type="submit"] {
                min-height: 48px;
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
            <div style="width:10px; height:10px; background:var(--accent); border-radius:50%; box-shadow:0 0 10px var(--accent);"></div>
            ExamPro Teacher
        </div>
        <button class="menu-toggle" onclick="toggleMobileMenu()">☰</button>
        <ul class="nav-links" id="mobileMenu">
            <li><a href="/teacher-dashboard">Dashboard</a></li>
            <li><a href="/manage-questions">Question Bank</a></li>
             <li><a href="/exam/new">Create Exam</a></li>
             <li><a href="/my-exams">My Exams</a></li>
             <li><a href="/batch">Batches</a></li>
              <li><a href="/assignments" >Exam Assignments</a></li>
            <li><a href="#" class="active">Exam Results</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <h1>Student Performance</h1>
            <p>Monitor real-time scores and classroom analytics for assigned assessments.</p>
        </header>

<div style="background: var(--surface); padding: 1.5rem; border-radius: 20px; border: 1px solid var(--border); margin-bottom: 2rem;">
    <form action="/view-results" method="GET" style="display: flex; flex-wrap: wrap; gap: 20px; align-items: flex-end;">

        <div style="display: flex; flex-direction: column; gap: 8px; flex: 1; min-width: 200px;">
            <label style="font-family: 'Syne'; font-size: 0.7rem; color: var(--muted); text-transform: uppercase; font-weight: 700;">Classroom:</label>
            <select name="batchId" style="background: var(--bg); border: 1px solid var(--border); padding: 0.8rem; border-radius: 12px; color: white; outline: none;">
                <option value="0">All Batches</option>
                <c:forEach var="batch" items="${allBatches}">
                    <option value="${batch.batchId}" ${param.batchId == batch.batchId ? 'selected' : ''}>${batch.batchName}</option>
                </c:forEach>
            </select>
        </div>

        <div style="display: flex; flex-direction: column; gap: 8px; flex: 1; min-width: 200px;">
            <label style="font-family: 'Syne'; font-size: 0.7rem; color: var(--muted); text-transform: uppercase; font-weight: 700;">Examination:</label>
            <select name="examId" style="background: var(--bg); border: 1px solid var(--border); padding: 0.8rem; border-radius: 12px; color: white; outline: none;">
                <option value="0">All Tests</option>
                <c:forEach var="ex" items="${allExams}">
                    <option value="${ex.examId}" ${param.examId == ex.examId ? 'selected' : ''}>${ex.examTitle}</option>
                </c:forEach>
            </select>
        </div>

        <div style="display: flex; gap: 10px;">
            <button type="submit" style="background: var(--accent); color: white; border: none; padding: 0.8rem 1.5rem; border-radius: 12px; font-weight: 700; cursor: pointer;">Apply Filter</button>
            <a href="/view-results" style="background: rgba(255,255,255,0.05); color: var(--muted); border: 1px solid var(--border); padding: 0.8rem 1.5rem; border-radius: 12px; text-decoration: none; font-size: 0.9rem; font-weight: 600;">Reset</a>
        </div>

        <a href="${pageContext.request.contextPath}/export-results?batchId=${empty param.batchId ? 0 : param.batchId}&examId=${empty param.examId ? 0 : param.examId}"
            style="background: var(--success); color: #080c14; border: none; padding: 0.8rem 1.5rem; border-radius: 12px; text-decoration: none; font-weight: 800; font-size: 0.9rem; display: flex; align-items: center; gap: 8px;">
            <span>📥</span> Export to Excel
        </a>
    </form>

</div>

        <section class="analytics-grid">
            <div class="ana-card">
                <span>Total Submissions</span>
                <h2 style="color: var(--accent);">${totalSubmissions != null ? totalSubmissions : '0'}</h2>
            </div>
            <div class="ana-card">
                <span>Class Average</span>
                <h2 style="color: var(--success);">${classAverage != null ? classAverage : '0'}%</h2>
            </div>
            <div class="ana-card">
                <span>Highest Score</span>
                <h2 style="color: var(--accent2);">${highestScore != null ? highestScore : '0'}%</h2>
            </div>
        </section>

        <section class="results-container">
            <table>
                <thead>
                    <tr>
                        <th>Student Username</th>
                        <th>Assessment</th>
                        <th>Classroom</th>
                        <th>Subject</th>
                        <th>Date</th>
                        <th>Score</th>
                        <th>Percentage</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="res" items="${examResults}">
                        <tr>
                            <td><span class="student-name">${res.studentName}</span></td>
                            <td><span class="sub-data" style="color: var(--text); font-weight: 600;">${res.examTitle}</span></td>
                            <td><span class="sub-data">${res.batchName}</span></td>
                            <td><span class="sub-data">${res.subjectName}</span></td>
                            <td><span class="sub-data">${res.date}</span></td>
                            <td style="font-weight: 700;">${res.correct} / ${res.total}</td>
                            <td class="percentage">${res.percentage}%</td>
                            <td>
                                <c:choose>
                                    <c:when test="${res.percentage >= 75}">
                                        <span class="score-pill excellent">Excellent</span>
                                    </c:when>
                                    <c:when test="${res.percentage >= 40}">
                                        <span class="score-pill pass">Passed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="score-pill fail">Failed</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty examResults}">
                        <tr>
                            <td colspan="8" class="empty-state">
                                <div style="font-size: 2.5rem; margin-bottom: 1rem;">📊</div>
                                <h3>No Performance Data</h3>
                                <p>Student results will appear here once examinations are submitted.</p>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
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