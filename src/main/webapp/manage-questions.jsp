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
    <title>Manage Bank | Exam Portal</title>
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

        /* ─── SIDEBAR (Same as Dashboard) ────────────── */
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
        .nav-links a { text-decoration: none; color: var(--muted); padding: 0.8rem 1rem; display: block; border-radius: 10px; transition: 0.3s; }
        .nav-links a:hover, .nav-links a.active { background: rgba(59,142,243,0.1); color: var(--accent); }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content { flex: 1; padding: 3rem; overflow-y: auto; }

        header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.5rem; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 1.8rem; }

        .btn-add {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: white;
            text-decoration: none;
            padding: 0.7rem 1.2rem;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }
        .btn-add:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(108,99,255,0.2); }

        /* ─── TABLE STYLING ──────────────────────────── */
        .table-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
        }

        table {
            border-collapse: collapse; /* Essential for perfectly straight lines */
            width: 100%;
        }

        td {
            padding: 1.2rem;
            font-size: 0.9rem;
            border-bottom: 1px solid var(--border); /* This is the line you want to align */
            vertical-align: middle; /* Aligns content to the center of the line */
            height: 80px; /* Setting a fixed height ensures the border is in the same place */
        }

        th {
            background: rgba(255,255,255,0.02);
            padding: 1.2rem;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--muted);
            border-bottom: 1px solid var(--border);
        }

        tr:hover { background: rgba(255,255,255,0.01); }

        .q-text {
            max-width: 400px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        td span strong {
            margin-right: 3px;
        }
        .badge {
            padding: 0.3rem 0.6rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(34,212,160,0.1);
            color: var(--success);
        }

        /* Update this specific block in your <style> */
        td.actions {
            text-align: right;
            white-space: nowrap;
            width: 1%;
            padding-right: 2.5rem;
            display: table-cell; /* Ensures it stays a table cell */
        }

        /* Use this to wrap the buttons inside the <td> */
        .actions-container {
            display: inline-flex;
            gap: 8px;
            align-items: center;
            justify-content: flex-end;
        }

        .btn-icon {
            height: 34px;
            min-width: 70px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 1rem;
            background: transparent;
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--muted);
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 500;
            transition: 0.2s;
        }
        .btn-edit:hover { border-color: var(--accent); color: var(--accent); }
        .btn-delete:hover { border-color: var(--danger); color: var(--danger); }

        .empty-state { padding: 4rem; text-align: center; color: var(--muted); }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (QUESTION BANK) ─── */

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

        @media (max-width: 900px) {
            /* ─── TABLE TO CARD TRANSFORMATION ─── */
            .table-container { border: none; background: transparent; }

            thead { display: none; } /* Hide headers on mobile */

            tr {
                display: block;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 20px;
                margin-bottom: 1.5rem;
                padding: 1.5rem;
                height: auto !important; /* Override fixed height */
            }

            td {
                display: block;
                width: 100% !important;
                padding: 0.5rem 0 !important;
                border: none !important;
                height: auto !important;
                text-align: left !important;
            }

            /* Labeling the data manually since headers are hidden */
            td:nth-of-type(1)::before { content: "Question ID: "; color: var(--muted); font-size: 0.7rem; text-transform: uppercase; }

            .q-text {
                max-width: 100%;
                white-space: normal; /* Wrap text on mobile */
                font-size: 1.1rem;
                margin-top: 10px;
            }

            td.actions {
                margin-top: 1.5rem;
                padding-top: 1.5rem !important;
                border-top: 1px solid var(--border) !important;
                display: flex;
                justify-content: space-between;
            }

            .btn-icon {
                flex: 1;
                justify-content: center;
                margin: 0 5px;
            }
        }

        @media (max-width: 480px) {
            header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }

            header h1 { font-size: 1.5rem; }

            .btn-add { width: 100%; justify-content: center; padding: 0.9rem; }

            .q-text { font-size: 1rem; }

            /* Stack options in a single column on very small phones */
            div[style*="grid-template-columns: 1fr 1fr"] {
                grid-template-columns: 1fr !important;
            }
        }

        /* ─── TOUCH TARGETS ─── */
        @media (pointer: coarse) {
            .btn-icon {
                min-height: 44px;
                font-size: 0.9rem;
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
            <li><a href="#" class="active">Question Bank</a></li>
             <li><a href="/exam/new">Create Exam</a></li>
             <li><a href="/my-exams">My Exams</a></li>
             <li><a href="/batch">Batches</a></li>
              <li><a href="/assignments" >Exam Assignments</a></li>
            <li><a href="/view-results">Exam Results</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <h1>Question Bank</h1>
            <a href="/prepare-question" class="btn-add"><span>+</span> Add New Question</a>
        </header>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Question & Options</th> <%-- Combined for better space --%>
                        <th>Subject</th>
                        <th>Correct</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="q" items="${questions}">
                        <tr>
                            <td style="color:var(--muted); font-weight:700;">#${q.id}</td>
                            <td>
                                <div class="q-text" style="font-weight: 500; margin-bottom: 5px;" title="${q.questionText}">
                                    ${q.questionText}
                                </div>
                                <%-- Small options preview --%>
                                <div style="font-size: 0.75rem; color: var(--muted); display: grid; grid-template-columns: 1fr 1fr; gap: 4px; max-width: 300px;">
                                    <span><strong style="color:var(--accent2)">A:</strong> ${q.optionA}</span>
                                    <span><strong style="color:var(--accent2)">B:</strong> ${q.optionB}</span>
                                    <span><strong style="color:var(--accent2)">C:</strong> ${q.optionC}</span>
                                    <span><strong style="color:var(--accent2)">D:</strong> ${q.optionD}</span>
                                </div>
                            </td>
                            <td>${q.subjectName}</td>
                            <td><span class="badge">Option ${q.correctAnswer}</span></td>
                            <td class="actions">
                                <a href="/edit?id=${q.id}" class="btn-icon btn-edit">Edit</a>
                                <a href="/delete?id=${q.id}"
                                   class="btn-icon btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this question?')">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty questions}">
                        <tr>
                            <td colspan="5" class="empty-state">
                                No questions found in the database. <br>
                                <a href="/prepare-question" style="color:var(--accent); text-decoration:none; margin-top:10px; display:inline-block;">Create your first question</a>
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