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
    <title>Add Question | Exam Portal</title>
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
        .nav-links a { text-decoration: none; color: var(--muted); padding: 0.8rem 1rem; display: block; border-radius: 10px; transition: 0.3s; }
        .nav-links a:hover, .nav-links a.active { background: rgba(59,142,243,0.1); color: var(--accent); }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content { flex: 1; padding: 3rem; overflow-y: auto; display: flex; flex-direction: column; align-items: center; }

        .form-container {
            width: 100%;
            max-width: 700px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }

        header { width: 100%; max-width: 700px; margin-bottom: 2rem; text-align: left; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 1.8rem; margin-bottom: 0.5rem; }
        header p { color: var(--muted); font-size: 0.9rem; }

        /* ─── FORM ELEMENTS ──────────────────────────── */
        .form-group { margin-bottom: 1.5rem; }
        label { display: block; font-size: 0.8rem; color: var(--muted); margin-bottom: 0.6rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; }

        input, textarea, select {
            width: 100%;
            padding: 1rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border);
            border-radius: 12px;
            color: var(--text);
            font-family: inherit;
            font-size: 0.95rem;
            transition: all 0.3s;
        }

        textarea { resize: vertical; min-height: 100px; }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: var(--accent);
            background: rgba(59,142,243,0.05);
        }

        option{
           color:black;
        }

        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
        }

        .btn-submit {
            width: 100%;
            padding: 1rem;
            margin-top: 1rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none;
            border-radius: 12px;
            color: white;
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(59,142,243,0.3);
        }

        .alert-success {
            padding: 1rem;
            background: rgba(34,212,160,0.1);
            color: var(--success);
            border: 1px solid rgba(34,212,160,0.2);
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            text-align: center;
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <div style="width:10px; height:10px; background:var(--accent); border-radius:50%; box-shadow:0 0 10px var(--accent);"></div>
            ExamPro Admin
        </div>
        <ul class="nav-links">
            <li><a href="/teacher-dashboard">Dashboard</a></li>
            <li><a href="/manage-questions">Question Bank</a></li>
            <li><a href="view-results.jsp">Exam Results</a></li>
            <li><a href="manage-students.jsp">Students</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <h1>Add New Question</h1>
            <p>Fill in the details below to contribute to the global question bank.</p>
        </header>

        <div class="form-container">
            <c:if test="${param.success == 'true'}">
                <div class="alert-success">Question successfully added to the bank!</div>
            </c:if>

            <form action="AddQuestionServlet" method="post">
                <div class="form-group">
                    <label>Question Content</label>
                    <textarea name="questionText" placeholder="Enter the question statement here..." required></textarea>
                </div>

                <div class="options-grid">
                    <div class="form-group">
                        <label>Option A</label>
                        <input type="text" name="optionA" placeholder="First option" required>
                    </div>
                    <div class="form-group">
                        <label>Option B</label>
                        <input type="text" name="optionB" placeholder="Second option" required>
                    </div>
                    <div class="form-group">
                        <label>Option C</label>
                        <input type="text" name="optionC" placeholder="Third option" required>
                    </div>
                    <div class="form-group">
                        <label>Option D</label>
                        <input type="text" name="optionD" placeholder="Fourth option" required>
                    </div>
                </div>

                <div class="options-grid" style="margin-top: 0.5rem;">
                    <div class="form-group">
                        <label>Subject</label>
                        <select name="subjectId" required>
                            <option value="" disabled selected>Select Subject</option>
                            <c:forEach var="subject" items="${subjects}">
                                <option value="${subject.subjectId}">${subject.subjectName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Correct Answer</label>
                        <select name="correctAnswer" required>
                            <option value="" disabled selected>Select option</option>
                            <option value="A">Option A</option>
                            <option value="B">Option B</option>
                            <option value="C">Option C</option>
                            <option value="D">Option D</option>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Publish Question</button>
            </form>
        </div>
    </main>

</body>
</html>