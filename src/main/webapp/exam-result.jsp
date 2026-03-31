<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<%
    // Security check: Ensure result exists in session
    if (session.getAttribute("user") == null || session.getAttribute("result") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<!DOCTYPE html>
<html>
<head>
    <title>Exam Result | ExamPro</title>
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

        body {
            background: var(--bg);
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            text-align: center;
            padding: 40px;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .card {
            background: var(--panel);
            padding: 40px;
            border-radius: 24px;
            width: 100%;
            max-width: 420px;
            border: 1px solid var(--border);
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
            animation: slideUp 0.6s cubic-bezier(0.22, 1, 0.36, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 { font-family: 'Syne', sans-serif; font-weight: 800; margin-top: 0; }

        .score-circle {
            width: 140px;
            height: 140px;
            border: 4px solid var(--success);
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin: 30px auto;
            background: rgba(34, 212, 160, 0.05);
        }

        .score-val {
            font-size: 42px;
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            color: var(--success);
            line-height: 1;
        }

        .score-total {
            font-size: 16px;
            color: var(--muted);
            margin-top: 5px;
        }

        .details {
            background: rgba(255,255,255,0.02);
            padding: 20px;
            border-radius: 16px;
            text-align: left;
            margin-bottom: 30px;
            border: 1px solid var(--border);
        }

        .details p {
            margin: 10px 0;
            display: flex;
            justify-content: space-between;
            font-size: 0.95rem;
        }

        .btn-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 12px;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            font-size: 0.9rem;
        }

        .btn-dash {
            background: var(--accent2);
            color: white;
            box-shadow: 0 4px 15px rgba(108, 99, 255, 0.3);
        }

        .btn-logout {
            background: rgba(255,255,255,0.05);
            color: var(--muted);
            border: 1px solid var(--border);
        }

        .btn:hover {
            transform: translateY(-3px);
            filter: brightness(1.1);
        }

        .btn-dash:hover {
            box-shadow: 0 8px 25px rgba(108, 99, 255, 0.5);
        }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (EXAM RESULT) ─── */

        @media (max-width: 768px) {
            body {
                padding: 20px;
                height: auto; /* Allow scrolling on smaller devices */
                min-height: 100vh;
            }

            .card {
                padding: 30px 20px;
                max-width: 100%;
                border-radius: 20px;
            }

            h2 {
                font-size: 1.5rem;
            }

            .score-circle {
                width: 120px;
                height: 120px;
                margin: 20px auto;
            }

            .score-val {
                font-size: 36px;
            }

            .details {
                padding: 15px;
                margin-bottom: 20px;
            }

            .details p {
                font-size: 0.85rem;
            }
        }

        @media (max-width: 480px) {
            .card {
                background: transparent;
                border: none;
                box-shadow: none;
                padding: 10px;
            }

            .score-circle {
                width: 110px;
                height: 110px;
                border-width: 3px;
            }

            .score-val {
                font-size: 32px;
            }

            .btn-group {
                grid-template-columns: 1fr; /* Stack buttons vertically for better thumb reach */
                gap: 10px;
            }

            .btn {
                padding: 14px;
                font-size: 0.95rem;
                width: 100% !important; /* Ensure both buttons are full width */
            }

            .details p span:first-child {
                opacity: 0.8;
            }
        }

        /* ─── LANDSCAPE / HEIGHT PROTECTION ─── */
        @media (max-height: 650px) {
            body {
                align-items: flex-start;
                padding: 40px 20px;
            }

            .score-circle {
                width: 80px;
                height: 80px;
                margin: 15px auto;
            }

            .score-val {
                font-size: 24px;
            }

            .score-total {
                font-size: 12px;
            }
        }

        /* ─── TOUCH FEEDBACK ─── */
        @media (pointer: coarse) {
            .btn:active {
                transform: scale(0.96);
                transition: 0.1s;
            }
        }
    </style>
</head>
<body>

<div class="card">
    <h2>Performance Report</h2>
    <p style="color: var(--muted); font-size: 0.9rem;">Candidate: ${sessionScope.user.username}</p>

    <div class="score-circle">
        <span class="score-val">${result.score}</span>
        <span class="score-total">out of ${result.total}</span>
    </div>

    <div class="details">
        <p><span>✅ Correct Answers:</span> <span style="color: var(--success); font-weight: 700;">${result.correct}</span></p>
        <p><span>❌ Incorrect/Skipped:</span> <span style="color: var(--danger); font-weight: 700;">${result.wrong}</span></p>
        <p><span>📊 Final Grade:</span> <span style="color: var(--accent); font-weight: 700;">${result.percentage}%</span></p>
    </div>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-dash">Dashboard</a>

        <form action="${pageContext.request.contextPath}/LogoutServlet" method="POST" style="margin:0;">
            <button type="submit" class="btn btn-logout" style="width: 100%;">Logout</button>
        </form>
    </div>
</div>

</body>
</html>