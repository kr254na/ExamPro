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
    <title>Assign Exam | ExamPro</title>
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
        .main-content { flex: 1; padding: 3rem; display: flex; flex-direction: column; align-items: center; justify-content: center; }

        .assignment-card {
            width: 100%;
            max-width: 550px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 28px;
            padding: 3rem;
            box-shadow: 0 25px 50px rgba(0,0,0,0.4);
        }

        header { text-align: center; margin-bottom: 2.5rem; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2.2rem; margin-bottom: 0.5rem; }
        header p { color: var(--muted); font-size: 0.95rem; }

        .form-group { margin-bottom: 2rem; }
        label {
            display: block; font-size: 0.7rem; color: var(--accent);
            margin-bottom: 0.8rem; text-transform: uppercase;
            letter-spacing: 2px; font-weight: 700;
        }

        select {
            width: 100%; padding: 1.2rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border); border-radius: 14px;
            color: var(--text); font-family: inherit; font-size: 1rem;
            appearance: none; cursor: pointer; transition: 0.3s;
            option{
            color:black;
            }
        }
        select:focus { outline: none; border-color: var(--accent); background: rgba(59,142,243,0.05); }

        .btn-release {
            width: 100%; padding: 1.2rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none; border-radius: 14px; color: white;
            font-family: 'Syne', sans-serif; font-weight: 800;
            cursor: pointer; transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            text-transform: uppercase; letter-spacing: 1px; font-size: 1rem;
        }
        .btn-release:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(108,99,255,0.4); }

        .hint {
            margin-top: 1.5rem; text-align: center;
            font-size: 0.8rem; color: var(--muted);
        }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (ASSIGN EXAM) ─── */

        @media (max-width: 1024px) {
            body {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                padding: 1rem 1.5rem;
                border-right: none;
                border-bottom: 1px solid var(--border);
                flex-direction: row;
                align-items: center;
                justify-content: space-between;
                position: sticky;
                top: 0;
                z-index: 100;
                background: rgba(11, 17, 32, 0.95);
                backdrop-filter: blur(10px);
            }

            .nav-links {
                display: none;
            }

            .main-content {
                padding: 2rem 1rem;
                min-height: calc(100vh - 70px); /* Adjust for sticky header */
            }
        }

        @media (max-width: 768px) {
            .assignment-card {
                padding: 2rem 1.5rem;
                border-radius: 20px;
                box-shadow: 0 15px 30px rgba(0,0,0,0.3);
            }

            header h1 {
                font-size: 1.8rem;
            }

            header p {
                font-size: 0.85rem;
            }

            /* Professional Select Styling for Mobile */
            select {
                padding: 1rem;
                font-size: 0.9rem;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%233b8ef3' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 1rem center;
                background-size: 1rem;
            }

            .btn-release {
                padding: 1rem;
                font-size: 0.9rem;
            }
        }

        /* ─── UI FIX FOR SELECT OPTIONS (DARK THEME PRESERVATION) ─── */
        select option {
            background-color: #0b1120; /* var(--panel) hex */
            color: var(--text);
        }

        @media (max-width: 480px) {
            .assignment-card {
                padding: 1.5rem 1rem;
                border: none;
                background: transparent;
                box-shadow: none;
            }

            header h1 {
                font-size: 1.6rem;
            }

            .hint {
                font-size: 0.75rem;
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
            ExamPro Admin
        </div>
        <button class="menu-toggle" onclick="toggleMobileMenu()">☰</button>
        <ul class="nav-links" id="mobileMenu">
            <li><a href="/teacher-dashboard">Dashboard</a></li>
            <li><a href="/manage-questions">Question Bank</a></li>
            <li><a href="/exam/new">Create Exam</a></li>
            <li><a href="/my-exams">My Exams</a></li>
            <li><a href="/batch" class="active">Batches</a></li>
             <li><a href="/assignments" >Exam Assignments</a></li>
            <li><a href="/view-results">Exam Results</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <div class="assignment-card">
            <header>
                <h1>Release Exam</h1>
                <p>Link a specific assessment to a virtual classroom.</p>
            </header>

            <form action="/exam/assign" method="post">
                <div class="form-group">
                <input type="hidden" name="batchId" value="${selectedBatchId}">
                    <label>Select Examination</label>
                    <select name="examId" required>
                        <option value="" disabled selected>Choose an exam...</option>
                        <c:forEach var="exam" items="${myExams}">
                            <option value="${exam.examId}">${exam.examTitle} - ${exam.subjectName} (${exam.questionCount} Questions)</option>
                        </c:forEach>
                    </select>
                </div>



                <button type="submit" class="btn-release">Assign to Batch</button>
            </form>

            <div class="hint">
                Students in the selected batch will receive a notification instantly.
            </div>
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