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
    <title>Manage Batches | ExamPro</title>
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
            margin-bottom: 3rem;
        }
        header h1 { font-family: 'Syne', sans-serif; font-size: 2rem; }

        .btn-create {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: white; text-decoration: none; padding: 0.8rem 1.5rem;
            border-radius: 12px; font-weight: 700; font-size: 0.9rem;
            transition: 0.3s;
        }
        .btn-create:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(59,142,243,0.3); }

        /* ─── BATCH GRID ─────────────────────────────── */
        .batch-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2rem;
        }

        .batch-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 2rem;
            position: relative;
            transition: 0.3s;
        }
        .batch-card:hover { border-color: var(--accent2); transform: translateY(-5px); }

        /* BATCH ACTIONS (EDIT/DELETE) */
        .batch-actions {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            display: flex;
            gap: 8px;
        }

        .action-btn {
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--border);
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: 0.2s;
            color: var(--muted);
            text-decoration: none;
            font-size: 0.8rem;
            position: relative;
        }

        .btn-edit:hover { background: rgba(59,142,243,0.1); border-color: var(--accent); color: var(--accent); }
        .btn-delete:hover { background: rgba(255,94,125,0.1); border-color: var(--danger); color: var(--danger); }

        .batch-name { font-family: 'Syne', sans-serif; font-size: 1.25rem; margin-bottom: 0.5rem; color: var(--text); padding-right: 60px; display: block; }
        .batch-date { font-size: 0.75rem; color: var(--muted); margin-bottom: 1.5rem; display: block; }

        .code-box {
            background: rgba(108,99,255,0.05);
            border: 1px dashed var(--accent2);
            padding: 1rem;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .code-box span { font-size: 0.7rem; color: var(--muted); text-transform: uppercase; letter-spacing: 1px; display: block; margin-bottom: 4px; }
        .code-box strong { font-family: 'Syne', sans-serif; font-size: 1.4rem; color: var(--accent2); letter-spacing: 3px; }

        .batch-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border);
        }

        .stat-group { display: flex; flex-direction: column; }
        .stat-group label { font-size: 0.7rem; color: var(--muted); text-transform: uppercase; }
        .stat-group span { font-weight: 700; color: var(--success); font-size: 1.1rem; }

        .btn-manage {
            padding: 0.5rem 1rem;
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text);
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 600;
            transition: 0.2s;
        }
        .btn-manage:hover { background: var(--accent); border-color: var(--accent); }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 5rem;
            background: rgba(255,255,255,0.01);
            border: 2px dashed var(--border);
            border-radius: 24px;
            color: var(--muted);
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
            <li><a href="/my-exams">My Exams</a></li>
            <li><a href="#" class="active">Batches</a></li>
            <li><a href="view-results.jsp">Exam Results</a></li>
            <li><a href="manage-students.jsp">Students</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <div>
                <h1>Virtual Classrooms</h1>
                <p style="color:var(--muted);">Manage your student groups and invite codes.</p>
            </div>
            <a href="/batch/new" class="btn-create">+ Create New Batch</a>
        </header>

        <div class="batch-grid">
            <c:forEach var="batch" items="${myBatches}">
                <div class="batch-card">
                    <div class="batch-actions">
                        <a href="/batch/edit?id=${batch.batchId}" class="action-btn btn-edit" title="Edit Batch">✎</a>
                        <a href="/batch/delete?id=${batch.batchId}"
                           class="action-btn btn-delete"
                           title="Delete Batch"
                           onclick="return confirm('Deleting this batch will disconnect all linked students. Continue?')">✕</a>
                    </div>

                    <span class="batch-name">${batch.batchName}</span>
                    <span class="batch-date">Created: ${batch.createdAt}</span>

                    <div class="code-box">
                        <span>Share Invite Code</span>
                        <strong>${batch.batchCode}</strong>
                    </div>

                    <div class="batch-stats">
                        <div class="stat-group">
                            <label>Students</label>
                            <span>${batch.studentCount}</span>
                        </div>
                        <a href="/batch/view-students?id=${batch.batchId}" class="btn-manage">View Students →</a>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty myBatches}">
                <div class="empty-state">
                    <h3>No Classrooms Active</h3>
                    <p>Start by creating a batch and sharing the code with your students.</p>
                    <a href="/batch/new" style="color: var(--accent); text-decoration: none; display: inline-block; margin-top: 1rem;">Create your first batch →</a>
                </div>
            </c:if>
        </div>
    </main>

</body>
</html>