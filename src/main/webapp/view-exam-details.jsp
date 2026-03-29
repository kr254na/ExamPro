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
    <title>Exam Details | ExamPro</title>
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

        .details-header {
            background: var(--surface);
            padding: 2.5rem;
            border-radius: 24px;
            border: 1px solid var(--border);
            margin-bottom: 2.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }

        .details-header h1 { font-family: 'Syne', sans-serif; font-size: 2rem; margin-bottom: 0.5rem; }
        .btn-back {
            color: var(--accent);
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }
        .btn-back:hover { opacity: 0.8; transform: translateX(-5px); }

        /* ─── QUESTION CARDS ─────────────────────────── */
        .q-card {
            background: rgba(255,255,255,0.02);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            transition: 0.3s;
        }
        .q-card:hover { border-color: rgba(59,142,243,0.3); background: rgba(255,255,255,0.03); }

        .q-num {
            color: var(--accent);
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            margin-right: 12px;
        }

        .q-text { font-size: 1.1rem; font-weight: 500; line-height: 1.5; }

        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-top: 1.5rem;
            padding-left: 2.5rem;
        }

        .option-item {
            font-size: 0.9rem;
            color: var(--muted);
            padding: 0.8rem 1.2rem;
            background: rgba(255,255,255,0.03);
            border-radius: 10px;
            border: 1px solid var(--border);
        }

        .correct-answer {
            margin-top: 1.5rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--success);
            font-weight: 700;
            font-size: 0.85rem;
            padding-left: 2.5rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <div style="width:10px; height:10px; background:var(--accent); border-radius:50%; box-shadow:0 0 10px var(--accent);"></div>
            ExamPro Teacher
        </div>
        <ul class="nav-links">
            <li><a href="/teacher-dashboard">Dashboard</a></li>
            <li><a href="/manage-questions">Question Bank</a></li>
            <li><a href="/exam/new">Create Exam</a></li>
            <li><a href="/my-exams" class="active">My Exams</a></li>
            <li><a href="/batch">Batches</a></li>
            <li><a href="/view-results.jsp">Exam Results</a></li>
            <li><a href="/manage-students.jsp">Students</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <div class="details-header">
            <div>
                <span style="color: var(--accent); font-weight: 700; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 2px;">Exam Overview</span>
                <h1>${exam.examTitle}</h1>
                <p style="color: var(--muted);">${exam.subjectName} • ${exam.duration} Minutes • ${questions.size()} Questions</p>
            </div>
            <a href="/my-exams" class="btn-back">← Back to List</a>
        </div>

        <h3 style="margin-bottom: 2rem; font-family: 'Syne'; font-size: 1.4rem;">Question List</h3>

        <c:forEach var="q" items="${questions}" varStatus="status">
            <div class="q-card">
                <div class="q-text">
                    <span class="q-num">${status.count}.</span> ${q.questionText}
                </div>

                <div class="options-grid">
                    <div class="option-item"><strong style="color: var(--accent2)">A</strong> &nbsp; ${q.optionA}</div>
                    <div class="option-item"><strong style="color: var(--accent2)">B</strong> &nbsp; ${q.optionB}</div>
                    <div class="option-item"><strong style="color: var(--accent2)">C</strong> &nbsp; ${q.optionC}</div>
                    <div class="option-item"><strong style="color: var(--accent2)">D</strong> &nbsp; ${q.optionD}</div>
                </div>

                <div class="correct-answer">
                    <div style="width: 8px; height: 8px; background: var(--success); border-radius: 50%;"></div>
                    Correct Answer: Option ${q.correctAnswer}
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty questions}">
            <div style="text-align: center; padding: 5rem; color: var(--muted);">
                No questions are linked to this exam yet.
            </div>
        </c:if>
    </main>

</body>
</html>