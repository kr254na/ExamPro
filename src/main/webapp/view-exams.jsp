<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%
    if (session.getAttribute("user") == null || !"TEACHER".equals(session.getAttribute("role"))) {
        response.sendRedirect("/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Exams | ExamPro</title>
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
            color: var(--accent);
            margin-bottom: 3rem;
            display: flex;
            align-items: center; gap: 10px;
        }

        .nav-links { list-style: none; flex: 1; }
        .nav-links li { margin-bottom: 0.5rem; }
        .nav-links a {
            text-decoration: none; color: var(--muted); padding: 0.8rem 1rem;
            display: block; border-radius: 10px; transition: 0.3s;
        }
        .nav-links a:hover, .nav-links a.active {
            background: rgba(59,142,243,0.1); color: var(--accent);
        }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content { flex: 1; padding: 3rem; overflow-y: auto; }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2.5rem;
        }
        header h1 { font-family: 'Syne', sans-serif; font-size: 1.8rem; }

        .btn-add {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: white; text-decoration: none; padding: 0.7rem 1.2rem;
            border-radius: 10px; font-weight: 700; font-size: 0.85rem;
            transition: 0.3s;
        }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(59,142,243,0.2); }

        /* ─── TABLE STYLING ──────────────────────────── */
        .table-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }

        table { width: 100%; border-collapse: collapse; text-align: left; }

        th {
            background: rgba(255,255,255,0.02);
            padding: 1.2rem; font-size: 0.75rem;
            text-transform: uppercase; letter-spacing: 1px;
            color: var(--muted); border-bottom: 1px solid var(--border);
        }

        /* Center the last header */
        th:last-child {
            text-align: center;
        }

        td {
            padding: 1.2rem; font-size: 0.9rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
            height: 85px;
        }

        tr:hover { background: rgba(255,255,255,0.01); }

        .exam-title { font-weight: 700; color: var(--text); display: block; margin-bottom: 4px; }
        .exam-meta { font-size: 0.75rem; color: var(--muted); }

        .badge {
            padding: 0.3rem 0.6rem; border-radius: 6px;
            font-size: 0.7rem; font-weight: 700;
            background: rgba(108,99,255,0.1); color: var(--accent2);
            text-transform: uppercase;
        }

        /* Centered Actions Column */
        td.actions-cell {
            text-align: center;
            width: 180px;
        }

        .actions-container {
            display: inline-flex;
            gap: 8px;
            align-items: center;
            justify-content: center;
            vertical-align: middle;
        }

        .btn-icon {
            height: 36px;
            background: none; border: 1px solid var(--border);
            padding: 0 1rem; border-radius: 8px;
            color: var(--muted); transition: 0.2s;
            text-decoration: none; font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
        }
        .btn-view:hover { border-color: var(--accent); color: var(--accent); background: rgba(59,142,243,0.05); }
        .btn-delete:hover { border-color: var(--danger); color: var(--danger); background: rgba(255,94,125,0.05); }

        .empty-state { padding: 5rem; text-align: center; color: var(--muted); }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (MY EXAMS) ─── */

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

        @media (max-width: 950px) {
            /* ─── TABLE TO CARD TRANSFORMATION ─── */
            .table-container { border: none; background: transparent; box-shadow: none; }

            thead { display: none; } /* Hide headers */

            tr {
                display: block;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 20px;
                margin-bottom: 1.5rem;
                padding: 1.5rem;
                height: auto !important;
                position: relative;
            }

            td {
                display: block;
                width: 100% !important;
                padding: 0.5rem 0 !important;
                border: none !important;
                height: auto !important;
                text-align: left !important;
            }

            .exam-title { font-size: 1.2rem; }

            /* Meta items for mobile */
            td:nth-of-type(3)::before { content: "Questions: "; color: var(--muted); font-size: 0.8rem; }
            td:nth-of-type(4)::before { content: "Duration: "; color: var(--muted); font-size: 0.8rem; }

            /* Actions row on mobile */
            td.actions-cell {
                margin-top: 1rem;
                padding-top: 1.2rem !important;
                border-top: 1px solid var(--border) !important;
                width: 100% !important;
            }

            .actions-container {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr;
                width: 100%;
                gap: 8px;
            }

            .btn-icon {
                width: 100%;
                padding: 0.8rem 0.5rem;
            }
        }

        @media (max-width: 480px) {
            header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            header h1 { font-size: 1.5rem; }
            .btn-add { width: 100%; text-align: center; }

            .actions-container {
                grid-template-columns: 1fr; /* Stack buttons on very small phones */
            }

            .badge { font-size: 0.65rem; }
        }

        /* ─── TOUCH POLISH ─── */
        @media (pointer: coarse) {
            .btn-icon {
                min-height: 44px; /* Optimal touch target */
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
            <li><a href="#" class="active">My Exams</a></li>
            <li><a href="/batch">Batches</a></li>
             <li><a href="/assignments" >Exam Assignments</a></li>
            <li><a href="/view-results">Exam Results</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <h1>My Published Exams</h1>
            <a href="/exam/new" class="btn-add">+ New Exam</a>
        </header>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Exam Details</th>
                        <th>Subject</th>
                        <th>Questions</th>
                        <th>Duration</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="exam" items="${myExams}">
                        <tr>
                            <td>
                                <span class="exam-title">${exam.examTitle}</span>
                                <span class="exam-meta">Created: ${exam.createdAt}</span>
                            </td>
                            <td><span class="badge">${exam.subjectName}</span></td>
                            <td>${exam.questionCount}</td>
                            <td>${exam.duration} Mins</td>
                            <td class="actions-cell">
                                <div class="actions-container">
                                    <a href="/view-exam-details?id=${exam.examId}" class="btn-icon btn-view">View Details</a>
                                    <a href="/exam/update?id=${exam.examId}" class="btn-icon btn-view">Edit</a>
                                    <a href="/delete-exam?id=${exam.examId}"
                                       class="btn-icon btn-delete"
                                       onclick="return confirm('Delete this exam?')">Delete</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty myExams}">
                        <tr>
                            <td colspan="5" class="empty-state">
                                No exams published yet.<br>
                                <a href="/exam/new" style="color:var(--accent); text-decoration:none; display:inline-block; margin-top:1rem;">Assemble your first exam →</a>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
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