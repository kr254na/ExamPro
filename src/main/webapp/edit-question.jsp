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
    <title>Edit Question | ExamPro</title>
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
        .nav-links a {
            text-decoration: none; color: var(--muted); padding: 0.8rem 1rem;
            display: block; border-radius: 10px; transition: 0.3s;
        }
        .nav-links a:hover, .nav-links a.active {
            background: rgba(59,142,243,0.1); color: var(--accent);
        }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content {
            flex: 1; padding: 3rem; display: flex; flex-direction: column; align-items: center;
        }

        .form-container {
            width: 100%; max-width: 700px; background: var(--surface);
            border: 1px solid var(--border); border-radius: 24px;
            padding: 2.5rem; box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }

        header { width: 100%; max-width: 700px; margin-bottom: 2rem; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 1.8rem; margin-bottom: 0.5rem; }

        .form-group { margin-bottom: 1.5rem; }
        label { display: block; font-size: 0.8rem; color: var(--muted); margin-bottom: 0.6rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; }

        input, textarea, select {
            width: 100%; padding: 1rem; background: rgba(255,255,255,0.03);
            border: 1px solid var(--border); border-radius: 12px;
            color: var(--text); font-family: inherit; transition: 0.3s;
        }

        input:focus, textarea:focus, select:focus {
            outline: none; border-color: var(--accent); background: rgba(59,142,243,0.05);
        }

        option { color: black; }

        .options-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; }

        .btn-submit {
            width: 100%; padding: 1rem; margin-top: 1rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none; border-radius: 12px; color: white;
            font-family: 'Syne', sans-serif; font-weight: 800; cursor: pointer; transition: 0.3s;
        }

        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(59,142,243,0.3); }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (EDIT QUESTION) ─── */

        @media (max-width: 1024px) {
            body { flex-direction: column; }

            .sidebar {
                width: 100%; height: auto; padding: 1rem 1.5rem;
                flex-direction: row; align-items: center; justify-content: space-between;
                position: sticky; top: 0; z-index: 100;
                background: rgba(11, 17, 32, 0.95); backdrop-filter: blur(10px);
                border-bottom: 1px solid var(--border);
            }

            .nav-links { display: none; }

            .main-content { padding: 2rem 1rem; }
        }

        @media (max-width: 768px) {
            header { text-align: center; margin-bottom: 1.5rem; }

            header h1 { font-size: 1.5rem; }

            /* Collapse the 2-column grids into 1 column for easier editing */
            .options-grid {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .form-container {
                padding: 1.5rem;
                border-radius: 20px;
            }

            textarea {
                min-height: 120px; /* More space for the question text on mobile */
            }

            input, textarea, select {
                font-size: 0.9rem;
                padding: 0.8rem;
            }

            .btn-submit {
                padding: 1rem;
                font-size: 0.9rem;
            }
        }

        /* UI FIX FOR THE SELECT DROPDOWNS */
        select option {
            background-color: var(--panel);
            color: var(--text);
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 1.2rem;
                background: transparent;
                border: none;
                box-shadow: none;
            }

            label {
                font-size: 0.7rem;
                letter-spacing: 0.5px;
            }

            header h1 { font-size: 1.4rem; }
        }

        /* ─── TOUCH TARGET OPTIMIZATION ─── */
        @media (pointer: coarse) {
            input, select, textarea {
                font-size: 16px; /* Prevents auto-zoom on focus in iOS Safari */
            }

            .btn-submit:active {
                transform: scale(0.98);
                transition: 0.1s;
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
            <li><a href="/manage-questions" class="active">Question Bank</a></li>
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
            <h1>Edit Question</h1>
            <p style="color:var(--muted)">Modify the question details below. ID: #${question.id}</p>
        </header>

        <div class="form-container">
            <form action="/edit" method="post">
                <input type="hidden" name="id" value="${question.id}">

                <div class="form-group">
                    <label>Question Content</label>
                    <textarea name="questionText" required>${question.questionText}</textarea>
                </div>

                <div class="options-grid">
                    <div class="form-group">
                        <label>Option A</label>
                        <input type="text" name="optionA" value="${question.optionA}" required>
                    </div>
                    <div class="form-group">
                        <label>Option B</label>
                        <input type="text" name="optionB" value="${question.optionB}" required>
                    </div>
                    <div class="form-group">
                        <label>Option C</label>
                        <input type="text" name="optionC" value="${question.optionC}" required>
                    </div>
                    <div class="form-group">
                        <label>Option D</label>
                        <input type="text" name="optionD" value="${question.optionD}" required>
                    </div>
                </div>

                <div class="options-grid">
                    <div class="form-group">
                        <label>Subject</label>
                        <select name="subjectId" required>
                            <c:forEach var="sub" items="${subjects}">
                                <option value="${sub.subjectId}" ${sub.subjectName == question.subjectName ? 'selected' : ''}>
                                    ${sub.subjectName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Correct Answer</label>
                        <select name="correctAnswer" required>
                            <option value="A" ${question.correctAnswer == 'A' ? 'selected' : ''}>Option A</option>
                            <option value="B" ${question.correctAnswer == 'B' ? 'selected' : ''}>Option B</option>
                            <option value="C" ${question.correctAnswer == 'C' ? 'selected' : ''}>Option C</option>
                            <option value="D" ${question.correctAnswer == 'D' ? 'selected' : ''}>Option D</option>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Save Changes</button>
            </form>
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