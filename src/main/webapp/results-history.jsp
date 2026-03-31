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
    <title>My Results | ExamPro</title>
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

        /* ─── SIDEBAR (SAME AS EXAMS PAGE) ─── */
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

        /* ─── MAIN CONTENT ─── */
        .main-content {
            flex: 1;
            padding: 3rem;
            overflow-y: auto;
        }

        header { margin-bottom: 3rem; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2.2rem; margin-bottom: 0.5rem; }
        .sub-header { color: var(--muted); font-weight: 500; }

        /* ─── RESULTS TABLE / LIST ─── */
        /* --- Updated Container Logic --- */
        .results-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 24px;
            /* This is the secret: allow horizontal scroll only inside the card */
            overflow-x: auto;
            width: 100%;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        /* --- Table Width Management --- */
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            /* Ensures the table doesn't shrink its text to an unreadable size */
            min-width: 900px;
        }

        /* --- Prevent Text Wrapping --- */
        td, th {
            padding: 1.2rem 1.5rem;
            /* Keeps everything on one line so the table doesn't get vertically long */
            white-space: nowrap;
        }

        /* --- Custom Scrollbar for a Premium Look --- */
        .results-container::-webkit-scrollbar {
            height: 6px;
        }
        .results-container::-webkit-scrollbar-track {
            background: var(--bg);
            border-radius: 10px;
        }
        .results-container::-webkit-scrollbar-thumb {
            background: var(--border);
            border-radius: 10px;
        }
        .results-container::-webkit-scrollbar-thumb:hover {
            background: var(--accent2);
        }

        /* --- Optional: Slightly reduce sub-text size to save space --- */
        .sub-data {
            font-size: 0.9rem;
            color: var(--muted);
            font-weight: 500;
        }

        .exam-name {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--text);
            display: block;
        }

        .exam-date {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .score-pill {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 10px;
            font-weight: 800;
            font-family: 'Syne', sans-serif;
            font-size: 0.9rem;
        }

        .pass { background: rgba(34, 212, 160, 0.1); color: var(--success); }
        .fail { background: rgba(255, 94, 125, 0.1); color: var(--danger); }

        .percentage {
            font-weight: 700;
            color: var(--accent);
        }

        .empty-state {
            text-align: center;
            padding: 5rem;
            color: var(--muted);
        }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (STUDENT RESULTS) ─── */

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
            header h1 { font-size: 1.8rem; }
            header p { font-size: 0.85rem; }

            .results-container {
                border-radius: 16px;
                /* Ensures the container stays within the screen bounds */
                max-width: calc(100vw - 2rem);
            }

            th, td {
                padding: 1rem;
                font-size: 0.85rem;
            }

            .exam-name { font-size: 1rem; }

            /* Hint for the user that they can scroll the table */
            .results-container::after {
                content: '← Swipe to see more →';
                display: block;
                text-align: center;
                font-size: 0.7rem;
                color: var(--muted);
                padding: 10px;
                background: rgba(255,255,255,0.02);
                border-top: 1px solid var(--border);
            }
        }

        @media (max-width: 480px) {
            header { text-align: center; margin-bottom: 2rem; }

            /* Make the score pill slightly more compact on tiny screens */
            .score-pill {
                padding: 0.3rem 0.7rem;
                font-size: 0.75rem;
            }

            .empty-state { padding: 3rem 1rem; }
        }

        /* ─── SCROLLBAR POLISH ─── */
        @media (pointer: coarse) {
            /* Thicker scrollbar for easier thumb grabbing on touch devices */
            .results-container::-webkit-scrollbar {
                height: 10px;
            }

            .results-container::-webkit-scrollbar-thumb {
                background: rgba(108, 99, 255, 0.3);
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
            <li><a href="/student/dashboard">Dashboard</a></li>
            <li><a href="#" class="active">Results</a></li>
        </ul>
        <a href="/LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <h1>My Performance</h1>
            <p class="sub-header">Detailed history of your completed assessments and scores.</p>
        </header>

        <section class="results-container">
            <c:choose>
                <c:when test="${not empty history}">
                    <table>
                        <thead>
                            <tr>
                                <th>Assessment</th>
                                <th>Classroom</th>
                                <th>Subject</th>
                                <th>Completed On</th>
                                <th>Score (Correct/Total)</th>
                                <th>Percentage</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="res" items="${history}">
                               <tr>
                                   <td>
                                       <span class="exam-name">${res.examTitle}</span>
                                   </td>
                                   <td>
                                      <span class="sub-data">${res.batchName}</span>
                                   </td>
                                   <td>
                                        <span class="sub-data">${res.subjectName}</span>
                                   </td>
                                   <td class="exam-date sub-data">${res.date}</td>
                                   <td style="font-weight: 700;">${res.correct} / ${res.total}</td>
                                   <td class="percentage">${res.percentage}%</td>
                                   <td>
                                       <span class="score-pill ${res.percentage >= 40 ? 'pass' : 'fail'}">
                                           ${res.percentage >= 40 ? 'PASSED' : 'FAILED'}
                                       </span>
                                   </td>
                               </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div style="font-size: 2.5rem; margin-bottom: 1rem;">📊</div>
                        <h3>No Results Found</h3>
                        <p>Complete an exam to see your scores appear here.</p>
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