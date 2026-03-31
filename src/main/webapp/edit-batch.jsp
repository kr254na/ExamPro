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
    <title>Edit Batch | ExamPro</title>
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
        .main-content { flex: 1; padding: 3rem; display: flex; flex-direction: column; align-items: center; justify-content: center; }

        .form-container {
            width: 100%;
            max-width: 550px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 3rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }

        header { text-align: center; margin-bottom: 2.5rem; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2rem; margin-bottom: 0.5rem; }
        header p { color: var(--muted); font-size: 0.95rem; }

        .form-group { margin-bottom: 2rem; }
        label {
            display: block;
            font-size: 0.75rem;
            color: var(--muted);
            margin-bottom: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 700;
        }

        input[type="text"] {
            width: 100%;
            padding: 1.2rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border);
            border-radius: 14px;
            color: var(--text);
            font-family: inherit;
            font-size: 1rem;
            transition: 0.3s;
        }
        input:focus { outline: none; border-color: var(--accent); background: rgba(59,142,243,0.05); }

        /* ─── LOCKED CODE BOX ────────────────────────── */
        .code-locked-wrapper {
            background: rgba(255,255,255,0.02);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.5rem;
            text-align: center;
            margin-bottom: 2.5rem;
            opacity: 0.7;
            position: relative;
        }
        .lock-icon {
            position: absolute;
            top: -10px;
            right: -10px;
            background: var(--panel);
            border: 1px solid var(--border);
            padding: 5px;
            border-radius: 50%;
            font-size: 0.7rem;
        }
        .code-label { font-size: 0.65rem; color: var(--muted); font-weight: 800; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 10px; display: block; }
        .static-code {
            font-family: 'Syne', sans-serif;
            font-size: 2.2rem;
            color: var(--accent2);
            letter-spacing: 6px;
        }

        .btn-update {
            width: 100%;
            padding: 1.2rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none;
            border-radius: 14px;
            color: white;
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            cursor: pointer;
            transition: 0.4s;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 1rem;
        }
        .btn-update:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(108,99,255,0.3); }

        .back-link {
            margin-top: 1.5rem;
            display: inline-block;
            color: var(--muted);
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            transition: 0.3s;
        }
        .back-link:hover { color: var(--text); }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (EDIT BATCH) ─── */

        @media (max-width: 1024px) {
            body { flex-direction: column; }
            .sidebar {
                width: 100%; height: auto; padding: 1rem 1.5rem;
                flex-direction: row; align-items: center; justify-content: space-between;
                position: sticky; top: 0; z-index: 100;
                background: rgba(11, 17, 32, 0.95); backdrop-filter: blur(10px);
            }
            .nav-links { display: none; }
            .main-content { padding: 2rem 1.2rem; min-height: calc(100vh - 80px); }
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 2.5rem 1.5rem;
                border-radius: 20px;
            }

            header h1 { font-size: 1.8rem; }

            /* Adjusting the Locked Code Box for Mobile */
            .static-code {
                font-size: 1.8rem;
                letter-spacing: 4px;
            }

            .code-locked-wrapper {
                padding: 1.2rem;
                margin-bottom: 2rem;
            }
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 1rem;
                background: transparent;
                border: none;
                box-shadow: none;
            }

            header h1 { font-size: 1.6rem; }

            .static-code {
                font-size: 1.5rem;
                letter-spacing: 3px;
            }

            .lock-icon {
                top: -5px;
                right: -5px;
                font-size: 0.6rem;
            }

            input[type="text"] {
                padding: 1rem;
                font-size: 0.95rem;
            }

            .btn-update {
                padding: 1.1rem;
                font-size: 0.9rem;
            }
        }

        /* ─── TOUCH SAFETY ─── */
        @media (pointer: coarse) {
            input[type="text"] {
                font-size: 16px; /* Prevents auto-zoom on mobile safari */
            }
            .btn-update:active {
                transform: scale(0.98); /* Tactile feedback for mobile touch */
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
            <li><a href="/batch" class="active">Batches</a></li>
             <li><a href="/assignments" >Exam Assignments</a></li>
            <li><a href="/view-results">Exam Results</a></li>
        </ul>
        <a href="/LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <div class="form-container">
            <header>
                <h1>Edit Batch</h1>
                <p>Modify classroom details. Join codes cannot be changed after creation.</p>
            </header>

            <form action="/batch/edit" method="post">
                <input type="hidden" name="batchId" value="${batch.batchId}">

                <div class="form-group">
                    <label>Batch Name</label>
                    <input type="text" name="batchName" value="${batch.batchName}" required autofocus>
                </div>

                <div class="code-locked-wrapper">
                    <div class="lock-icon">🔒</div>
                    <span class="code-label">Batch Invite Code (Permanent)</span>
                    <div class="static-code">${batch.batchCode}</div>
                </div>

                <button type="submit" class="btn-update">Save Changes</button>
            </form>

            <div style="text-align: center;">
                <a href="/batch" class="back-link">← Discard and Go Back</a>
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