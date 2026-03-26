<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home | Exam Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #080c14;
            --surface: #0e1420;
            --accent: #3b8ef3;
            --accent2: #6c63ff;
            --text: #e8edf5;
            --muted: #6b7a99;
        }

        body {
            margin: 0;
            font-family: 'DM Sans', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
        }

        /* Ambient background glow */
        body::before {
            content: ''; position: absolute; width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(108,99,255,0.08) 0%, transparent 70%);
            bottom: -100px; right: -100px; z-index: -1;
        }

        .container {
            text-align: center;
            background: var(--surface);
            padding: 3rem;
            border-radius: 24px;
            border: 1px solid rgba(255,255,255,0.05);
            box-shadow: 0 40px 80px rgba(0,0,0,0.5);
            max-width: 500px;
            width: 90%;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h1 {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 2.2rem;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .user-welcome {
            font-size: 1.1rem;
            color: var(--muted);
            margin-bottom: 2rem;
        }

        .user-welcome strong {
            color: var(--accent);
        }

        .action-cards {
            display: grid;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 1rem 1.5rem;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: white;
            box-shadow: 0 10px 20px rgba(59,142,243,0.2);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(59,142,243,0.4);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.1);
            color: var(--text);
        }

        .btn-outline:hover {
            background: rgba(255,255,255,0.05);
            border-color: var(--accent);
        }

        .logout-link {
            display: block;
            margin-top: 2rem;
            color: var(--muted);
            font-size: 0.85rem;
            text-decoration: none;
            transition: color 0.2s;
        }

        .logout-link:hover {
            color: var(--danger);
        }
    </style>
</head>
<body>

<div class="container">
    <c:choose>
        <%-- CASE 1: USER IS LOGGED IN --%>
        <c:when test="${not empty sessionScope.user}">
            <h1>Welcome, <strong>${sessionScope.user.username}</strong></h1>
            <p class="user-welcome">Role: <span>${sessionScope.role}</span></p>

            <div class="action-cards">
                <c:choose>
                    <%-- If Teacher --%>
                    <c:when test="${sessionScope.role == 'TEACHER'}">
                        <a href="/teacher-dashboard" class="btn btn-primary">Go to Teacher Dashboard</a>
                        <a href="add-question.jsp" class="btn btn-outline">Add New Questions</a>
                    </c:when>

                    <%-- If Student --%>
                    <c:otherwise>
                        <p>Ready to test your knowledge?</p>
                        <form action="exam" method="get">
                            <button type="submit" class="btn btn-primary" style="width: 100%;">Start Exam Now</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>

            <a href="LogoutServlet" class="logout-link">Sign Out</a>
        </c:when>

        <%-- CASE 2: NO USER LOGGED IN --%>
        <c:otherwise>
            <h1>Online Exam Portal</h1>
            <p class="user-welcome">Please sign in to continue or create an account to start your journey.</p>

            <div class="action-cards">
                <a href="login.jsp" class="btn btn-primary">Login to Portal</a>
                <a href="register.jsp" class="btn btn-outline">Register as Student/Teacher</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>