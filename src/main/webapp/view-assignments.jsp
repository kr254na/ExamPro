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
    <title>Active Assignments | ExamPro</title>
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
            font-weight: 800; font-size: 1.2rem;
            color: var(--accent); margin-bottom: 3rem;
            display: flex; align-items: center; gap: 10px;
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
            margin-bottom: 3rem;
        }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2rem; }

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

        td {
            padding: 1.2rem; font-size: 0.95rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }

        tr:hover { background: rgba(255,255,255,0.01); }

        /* Tags */
        .tag {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 99px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .tag-batch { background: rgba(59,142,243,0.1); color: var(--accent); }
        .tag-exam { background: rgba(108,99,255,0.1); color: var(--accent2); }

        .btn-withdraw {
            color: var(--danger);
            text-decoration: none;
            font-weight: 700;
            font-size: 0.85rem;
            transition: 0.3s;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            border: 1px solid transparent;
        }
        .btn-withdraw:hover {
            background: rgba(255,94,125,0.1);
            border-color: var(--danger);
        }

        .empty-state {
            padding: 5rem;
            text-align: center;
            color: var(--muted);
        }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (EXAM ASSIGNMENTS) ─── */

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
            header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1.5rem;
            }

            header h1 { font-size: 1.8rem; }

            /* ─── TRANSFORM TABLE TO CARDS ─── */
            .table-container { background: transparent; border: none; box-shadow: none; }

            table, thead, tbody, th, td, tr { display: block; width: 100%; }

            thead { display: none; } /* Hide headers on mobile */

            tr {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 20px;
                margin-bottom: 1.5rem;
                padding: 1.5rem;
                transition: 0.3s;
            }

            td {
                border: none;
                padding: 0.6rem 0;
                text-align: left !important; /* Reset centering for mobile cards */
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            /* Adding small helper labels for the tags */
            td:nth-of-type(1)::before { content: "Assigned To:"; color: var(--muted); font-size: 0.65rem; text-transform: uppercase; letter-spacing: 1px; }
            td:nth-of-type(2)::before { content: "Examination:"; color: var(--muted); font-size: 0.65rem; text-transform: uppercase; letter-spacing: 1px; }
            td:nth-of-type(3)::before { content: "Assigned On:"; color: var(--muted); font-size: 0.65rem; text-transform: uppercase; letter-spacing: 1px; }

            .tag { font-size: 0.85rem; padding: 6px 14px; width: fit-content; }

            /* Action styling for mobile */
            td:last-child {
                margin-top: 1rem;
                padding-top: 1rem !important;
                border-top: 1px solid var(--border) !important;
            }

            .btn-withdraw {
                display: block;
                text-align: center;
                padding: 0.8rem;
                width: 100%;
                background: rgba(255, 94, 125, 0.05);
                border: 1px solid rgba(255, 94, 125, 0.2);
            }
        }

        @media (max-width: 480px) {
            header h1 { font-size: 1.5rem; }

            .main-content { padding: 1.5rem 1rem; }

            .btn-withdraw {
                font-size: 0.9rem;
            }
        }

        /* ─── TOUCH OPTIMIZATION ─── */
        @media (pointer: coarse) {
            .btn-withdraw {
                min-height: 48px; /* High-end mobile touch target */
                display: flex;
                align-items: center;
                justify-content: center;
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
            <li><a href="#" class="active">Exam Assignments</a></li>
            <li><a href="/view-results">Exam Results</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <div>
                <h1>Exam Assignments</h1>
                <p style="color:var(--muted);">Track and manage exams released to your batches.</p>
            </div>
            <a href="/batch" class="btn-withdraw" style="color: var(--accent); border-color: var(--accent);">+ New Assignment</a>
        </header>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Batch Name</th>
                        <th>Exam Title</th>
                        <th>Assigned Date</th>
                        <th style="text-align: center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${assignments}">
                        <tr>
                            <td>
                                <span class="tag tag-batch">${item.batchName}</span>
                            </td>
                            <td>
                                <span class="tag tag-exam">${item.examTitle}</span>
                            </td>
                            <td style="color: var(--muted); font-size: 0.85rem;">
                                ${item.assignedAt}
                            </td>
                            <td style="text-align: center;">
                                <a href="/exam/withdraw?id=${item.assignmentId}"
                                   class="btn-withdraw"
                                   onclick="return confirm('Withdraw this exam? Students in ${item.batchName} will no longer be able to see or take this exam.')">
                                    Withdraw ✕
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty assignments}">
                        <tr>
                            <td colspan="4" class="empty-state">
                                <div style="font-size: 2rem; margin-bottom: 1rem;">📋</div>
                                No active assignments found.<br>
                                <a href="/batch" style="color: var(--accent); text-decoration: none; font-size: 0.85rem;">Assign an exam to a batch now →</a>
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