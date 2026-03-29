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
    <title>Edit Exam | ExamPro</title>
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
        .main-content { flex: 1; padding: 3rem; overflow-y: auto; }

        header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 2.5rem;
        }
        header h1 { font-family: 'Syne', sans-serif; font-size: 1.8rem; margin-bottom: 0.5rem; }

        .form-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }

        .input-row { display: grid; grid-template-columns: 1fr 1fr 150px; gap: 1.5rem; margin-bottom: 2rem; }

        label { display: block; font-size: 0.75rem; color: var(--muted); margin-bottom: 0.6rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; }

        input[type="text"], input[type="number"] {
            width: 100%; padding: 1rem; background: rgba(255,255,255,0.03);
            border: 1px solid var(--border); border-radius: 12px; color: var(--text); font-family: inherit; transition: 0.3s;
        }
        input:focus { outline: none; border-color: var(--accent); background: rgba(59,142,243,0.05); }

        /* ─── QUESTION SELECTOR ──────────────────────── */
        .question-selector {
            margin-top: 1rem;
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid var(--border);
            border-radius: 16px;
            background: rgba(0,0,0,0.2);
        }

        .question-selector::-webkit-scrollbar { width: 6px; }
        .question-selector::-webkit-scrollbar-thumb { background: var(--border); border-radius: 10px; }

        .q-item {
            display: flex;
            align-items: center;
            padding: 1.2rem;
            border-bottom: 1px solid var(--border);
            transition: 0.3s;
            cursor: pointer;
        }
        .q-item:hover { background: rgba(255,255,255,0.02); }

        input[type="checkbox"] {
            appearance: none;
            width: 20px; height: 20px;
            border: 2px solid var(--muted);
            border-radius: 6px;
            margin-right: 15px;
            cursor: pointer;
            position: relative;
            transition: 0.2s;
        }
        input[type="checkbox"]:checked {
            background: var(--accent);
            border-color: var(--accent);
        }
        input[type="checkbox"]:checked::after {
            content: '✓'; position: absolute; color: white; font-size: 14px; left: 3px; top: -1px;
        }

        .q-info h4 { font-size: 0.95rem; margin-bottom: 4px; font-weight: 500; }
        .q-tag { font-size: 0.75rem; color: var(--accent); font-weight: 700; text-transform: uppercase; }

        .btn-update {
            width: 100%; padding: 1.2rem; margin-top: 2rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none; border-radius: 12px; color: white;
            font-family: 'Syne', sans-serif; font-weight: 800; cursor: pointer;
            transition: 0.3s; text-transform: uppercase; letter-spacing: 1px;
        }
        .btn-update:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(108,99,255,0.3); }

        .selection-count { color: var(--success); font-weight: 700; font-size: 0.9rem; }
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
        <header>
            <div>
                <h1>Modify Exam</h1>
                <p style="color:var(--muted)">Update title, duration, or manage question selections.</p>
            </div>
            <div class="selection-count" id="countDisplay">0 Questions Selected</div>
        </header>

        <div class="form-container">
            <form action="/exam/update" method="post">
                <input type="hidden" name="examId" value="${exam.examId}">

                <div class="input-row">
                    <div class="form-group">
                        <label>Exam Title</label>
                        <input type="text" name="examTitle" value="${exam.examTitle}" required>
                    </div>

                    <div class="form-group">
                        <label>Subject Name</label>
                        <input type="text" name="subjectName" value="${exam.subjectName}" required>
                    </div>

                    <div class="form-group">
                        <label>Duration</label>
                        <input type="number" name="duration" value="${exam.duration}" min="1"
                        oninput="this.value = Math.abs(this.value) || ''" required>
                    </div>
                </div>

                <label>Update Questions from Bank</label>
                <div class="question-selector">
                    <c:forEach var="bankQ" items="${fullBank}">
                        <%-- Logical check to see if this bank question is already in the exam --%>
                        <c:set var="isSelected" value="false" />
                        <c:forEach var="examQ" items="${currentExamQuestions}">
                            <c:if test="${examQ.id == bankQ.id}">
                                <c:set var="isSelected" value="true" />
                            </c:if>
                        </c:forEach>

                        <label class="q-item">
                            <input type="checkbox" name="selectedQuestions" value="${bankQ.id}"
                                   class="q-checkbox" ${isSelected ? 'checked' : ''}>
                            <div class="q-info" style="flex: 1;">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                                    <h4 style="margin: 0; font-size: 1rem;">${bankQ.questionText}</h4>
                                    <span class="q-tag" style="background: rgba(59,142,243,0.1); padding: 2px 8px; border-radius: 4px;">
                                        ${bankQ.subjectId}
                                    </span>
                                </div>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; font-size: 0.8rem; color: var(--muted);">
                                    <span><strong style="color: var(--accent2);">A:</strong> ${bankQ.optionA}</span>
                                    <span><strong style="color: var(--accent2);">B:</strong> ${bankQ.optionB}</span>
                                </div>
                            </div>
                        </label>
                    </c:forEach>
                </div>

                <button type="submit" class="btn-update">Save Changes</button>
            </form>
        </div>
    </main>

    <script>
        const checkboxes = document.querySelectorAll('.q-checkbox');
        const display = document.getElementById('countDisplay');

        function updateCounter() {
            const count = document.querySelectorAll('.q-checkbox:checked').length;
            display.innerText = count + ` Questions Selected`;
        }

        checkboxes.forEach(cb => cb.addEventListener('change', updateCounter));
        window.onload = updateCounter;
    </script>

</body>
</html>