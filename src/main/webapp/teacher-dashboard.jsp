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
    <title>Teacher Dashboard | Exam Portal</title>
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
            background: rgba(59,142,243,0.1);
            color: var(--accent);
        }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content {
            flex: 1;
            padding: 3rem;
            overflow-y: auto;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 3rem;
        }

        header h1 { font-family: 'Syne', sans-serif; font-size: 2rem; }

        /* Quick Stats */
        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: var(--surface);
            padding: 1.5rem;
            border-radius: 16px;
            border: 1px solid var(--border);
        }
        .stat-card span { color: var(--muted); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; }
        .stat-card h2 { font-family: 'Syne', sans-serif; font-size: 1.8rem; margin-top: 0.5rem; color: var(--accent2); }

        /* Action Cards */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
        }

        .card {
            background: linear-gradient(145deg, #10192c, #0e1420);
            padding: 2.5rem 2rem;
            border-radius: 24px;
            border: 1px solid var(--border);
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(45deg, transparent, rgba(108,99,255,0.05), transparent);
            transform: translateX(-100%); transition: 0.6s;
        }

        .card:hover {
            transform: translateY(-10px);
            border-color: var(--accent);
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }
        .card:hover::before { transform: translateX(100%); }

        .card h3 {
            font-family: 'Syne', sans-serif;
            font-size: 1.3rem;
            margin-bottom: 1rem;
            color: var(--accent);
        }

        .card p { color: var(--muted); line-height: 1.6; font-size: 0.95rem; }

    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <div style="width:10px; height:10px; background:var(--accent); border-radius:50%; box-shadow:0 0 10px var(--accent);"></div>
            ExamPro Admin
        </div>
        <ul class="nav-links">
            <li><a href="#" class="active">Dashboard</a></li>
            <li><a href="/manage-questions">Question Bank</a></li>
            <li><a href="view-results.jsp">Exam Results</a></li>
            <li><a href="manage-students.jsp">Students</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <div>
                <h1>Hello, ${sessionScope.user.username}</h1>
                <p style="color:var(--muted);">Manage your curriculum and track student progress.</p>
            </div>
            <div style="background: rgba(34,212,160,0.1); color: var(--success); padding: 0.5rem 1rem; border-radius: 99px; font-size: 0.8rem; font-weight: 700;">
                Live Session
            </div>
        </header>

        <section class="stats-bar">
            <div class="stat-card">
                <span>Total Questions</span>
                <h2>${totalQuestions}</h2>
            </div>
            <div class="stat-card">
                <span>Active Students</span>
                <h2>482</h2>
            </div>
            <div class="stat-card">
                <span>Exams Taken</span>
                <h2>1.2k</h2>
            </div>
        </section>

        <section class="card-grid">
            <div class="card" onclick="location.href='/prepare-question'">
                <h3>Create Question</h3>
                <p>Build your question bank by adding multi-choice questions with customized options and subjects.</p>
            </div>

            <div class="card" onclick="location.href='/manage-questions'">
                <h3>Manage Bank</h3>
                <p>Edit, refine, or remove existing questions. Ensure your exam content stays up to date.</p>
            </div>

            <div class="card" onclick="location.href='view-results.jsp'">
                <h3>View Performance</h3>
                <p>Analyze student scores and detailed metrics to identify learning gaps and top performers.</p>
            </div>
        </section>
    </main>

</body>
</html>