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
    <title>Batch Students | ExamPro</title>
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

        .back-nav {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: var(--accent);
            font-weight: 700;
            margin-bottom: 2rem;
            transition: 0.3s;
        }
        .back-nav:hover { transform: translateX(-5px); }

        header {
            margin-bottom: 3rem;
        }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2rem; margin-bottom: 0.5rem; }
        .batch-info { color: var(--muted); font-size: 0.95rem; }

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

        .student-avatar {
            width: 35px; height: 35px;
            background: linear-gradient(135deg, var(--accent2), var(--accent));
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; color: white; font-size: 0.8rem;
        }

        .empty-state { padding: 5rem; text-align: center; color: var(--muted); }
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
            <li><a href="/my-exams">My Exams</a></li>
            <li><a href="/batch" class="active">Batches</a></li>
            <li><a href="view-results.jsp">Exam Results</a></li>
            <li><a href="manage-students.jsp">Students</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <a href="/batch" class="back-nav">← Back to Batches</a>

        <header>
            <h1>${batch.batchName}</h1>
            <div class="batch-info">
                <span>Code: <strong>${batch.batchCode}</strong></span>
                <span style="margin: 0 10px;">|</span>
                <span>${students.size()} Enrolled Students</span>
            </div>
        </header>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th>Student Username</th>
                        <th style="text-align: center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="student" items="${students}" varStatus="status">
                        <tr>
                            <td>${status.count}</td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div class="student-avatar">
                                        ${student.username.substring(0,1).toUpperCase()}
                                    </div>
                                    <span style="font-weight: 600;">${student.username}</span>
                                </div>
                            </td>
                            <td style="text-align: center;">
                                <a href="/batch/remove-student?batchId=${batch.batchId}&studentId=${student.id}"
                                   style="color: var(--danger); text-decoration: none; font-size: 0.8rem; font-weight: 700;"
                                   onclick="return confirm('Remove ${student.username} from this batch?')">Remove</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty students}">
                        <tr>
                            <td colspan="5" class="empty-state">
                                No students have joined this batch yet.<br>
                                <span style="font-size: 0.8rem; color: var(--accent2);">Share code "${batch.batchCode}" to invite them!</span>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

</body>
</html>