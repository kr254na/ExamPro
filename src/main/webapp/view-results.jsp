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
    <title>Exam Results | Exam Portal</title>
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
            --warning: #ffb74d;
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
        .main-content { flex: 1; padding: 3rem; overflow-y: auto; }

        header { margin-bottom: 2.5rem; }
        header h1 { font-family: 'Syne', sans-serif; font-size: 1.8rem; margin-bottom: 0.5rem; }
        header p { color: var(--muted); font-size: 0.9rem; }

        /* ─── ANALYTICS CARDS ────────────────────────── */
        .analytics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }
        .ana-card {
            background: var(--surface);
            padding: 1.5rem;
            border-radius: 20px;
            border: 1px solid var(--border);
        }
        .ana-card span { font-size: 0.7rem; color: var(--muted); text-transform: uppercase; letter-spacing: 1px; }
        .ana-card h2 { font-family: 'Syne', sans-serif; font-size: 1.5rem; margin-top: 0.5rem; }

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
            padding: 1.2rem;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--muted);
            border-bottom: 1px solid var(--border);
        }

        td {
            padding: 1.2rem;
            font-size: 0.9rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }

        tr:hover { background: rgba(255,255,255,0.01); }

        /* Score Badge Logic */
        .score-pill {
            padding: 0.4rem 0.8rem;
            border-radius: 99px;
            font-size: 0.8rem;
            font-weight: 700;
        }
        .pass { background: rgba(34,212,160,0.1); color: var(--success); }
        .fail { background: rgba(255,94,125,0.1); color: var(--danger); }
        .average { background: rgba(255,183,77,0.1); color: var(--warning); }

        .progress-mini {
            width: 100px;
            height: 6px;
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            overflow: hidden;
            display: inline-block;
            margin-right: 10px;
        }
        .progress-bar { height: 100%; background: var(--accent); border-radius: 10px; }

        .empty-state { padding: 5rem; text-align: center; color: var(--muted); }
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
            <li><a href="#" class="active">Exam Results</a></li>
            <li><a href="manage-students.jsp">Students</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <h1>Student Performance</h1>
            <p>Review comprehensive results and scoring metrics for recent examinations.</p>
        </header>

        <section class="analytics-grid">
            <div class="ana-card">
                <span>Total Submissions</span>
                <h2 style="color: var(--accent);">248</h2>
            </div>
            <div class="ana-card">
                <span>Class Average</span>
                <h2 style="color: var(--success);">72%</h2>
            </div>
            <div class="ana-card">
                <span>Highest Score</span>
                <h2 style="color: var(--accent2);">10/10</h2>
            </div>
        </section>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Attempted</th>
                        <th>Score</th>
                        <th>Percentage</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Loop through the result records --%>
                    <c:forEach var="res" items="${examResults}">
                        <tr>
                            <td style="font-weight: 500;">${res.studentName}</td>
                            <td style="color: var(--muted);">${res.attempted} / ${res.total}</td>
                            <td style="font-family: 'Syne', sans-serif; font-weight: 700;">${res.score}</td>
                            <td>
                                <div class="progress-mini">
                                    <div class="progress-bar" style="width: ${res.percentage}%"></div>
                                </div>
                                <span>${res.percentage}%</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${res.percentage >= 75}">
                                        <span class="score-pill pass">Excellent</span>
                                    </c:when>
                                    <c:when test="${res.percentage >= 40}">
                                        <span class="score-pill average">Passed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="score-pill fail">Failed</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty examResults}">
                        <tr>
                            <td colspan="5" class="empty-state">
                                No exam records found. Once students complete their tests, results will appear here.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

</body>
</html>