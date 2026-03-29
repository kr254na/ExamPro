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
    <title>Create Batch | ExamPro</title>
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
            position: relative;
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

        /* ─── CODE GENERATOR BOX ─────────────────────── */
        .code-preview-wrapper {
            background: rgba(108,99,255,0.05);
            border: 1px dashed var(--accent2);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            margin-bottom: 2.5rem;
            position: relative;
        }
        .code-label { font-size: 0.65rem; color: var(--accent2); font-weight: 800; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 10px; display: block; }
        .generated-code {
            font-family: 'Syne', sans-serif;
            font-size: 2.5rem;
            color: var(--text);
            letter-spacing: 8px;
            text-shadow: 0 0 20px rgba(108,99,255,0.3);
        }

        .btn-launch {
            width: 100%;
            padding: 1.2rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none;
            border-radius: 14px;
            color: white;
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            cursor: pointer;
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 1rem;
        }
        .btn-launch:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(108,99,255,0.4); }

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
        <div class="form-container">
            <header>
                <h1>New Classroom</h1>
                <p>Set a name and generate a secure join code for your students.</p>
            </header>

            <form action="/batch/new" method="post">
                <div class="form-group">
                    <label>Batch Name</label>
                    <input type="text" name="batchName" placeholder="e.g., BCA Final Year - Section A" required autofocus>
                </div>

                <div class="code-preview-wrapper">
                    <span class="code-label">Unique Invite Code</span>
                    <div class="generated-code" id="codeDisplay">------</div>
                    <input type="hidden" name="batchCode" id="hiddenBatchCode">
                </div>

                <button type="submit" class="btn-launch">Launch Batch</button>
            </form>

            <div style="text-align: center;">
                <a href="/batch" class="back-link">← Cancel and Go Back</a>
            </div>
        </div>
    </main>

    <script>

        function generateSecureCode() {
            const charset = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
            let code = "";
            for (let i = 0; i < 6; i++) {
                code += charset.charAt(Math.floor(Math.random() * charset.length));
            }
            document.getElementById('codeDisplay').innerText = code;
            document.getElementById('hiddenBatchCode').value = code;
        }

        // Generate the code immediately when the page loads
        window.onload = generateSecureCode;
    </script>

</body>
</html>