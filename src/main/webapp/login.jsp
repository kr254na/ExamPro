<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Exam Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #080c14;
            --surface: #0e1420;
            --accent: #3b8ef3;
            --accent2: #6c63ff;
            --text: #e8edf5;
            --muted: #6b7a99;
            --danger: #ff5e7d;
            --success: #22d4a0;
        }

        body {
            margin: 0;
            font-family: 'DM Sans', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }

        /* Ambient background glow */
        body::before {
            content: ''; position: absolute; width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(59,142,243,0.1) 0%, transparent 70%);
            top: -100px; left: -100px; z-index: -1;
        }

        .login-card {
            background: var(--surface);
            padding: 2.5rem;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.05);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 380px;
            text-align: center;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        p.subtitle { color: var(--muted); font-size: 0.9rem; margin-bottom: 2rem; }

        .input-group { text-align: left; margin-bottom: 1.2rem; }

        label { display: block; font-size: 0.8rem; color: var(--muted); margin-bottom: 0.5rem; text-transform: uppercase; letter-spacing: 1px; }

        input {
            width: 100%;
            padding: 0.8rem 1rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 10px;
            color: white;
            font-family: inherit;
            transition: all 0.3s;
            box-sizing: border-box;
        }

        input:focus {
            outline: none;
            border-color: var(--accent);
            background: rgba(59,142,243,0.05);
            box-shadow: 0 0 0 4px rgba(59,142,243,0.1);
        }

        .btn-login {
            width: 100%;
            padding: 1rem;
            margin-top: 1rem;
            background: linear-gradient(135deg, var(--accent2), var(--accent));
            border: none;
            border-radius: 10px;
            color: white;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(108,99,255,0.3);
        }

        .alert {
            font-size: 0.85rem;
            padding: 0.75rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        .alert-error { background: rgba(255, 94, 125, 0.1); color: var(--danger); border: 1px solid rgba(255, 94, 125, 0.2); }
        .alert-success { background: rgba(34, 212, 160, 0.1); color: var(--success); border: 1px solid rgba(34, 212, 160, 0.2); }

        .footer-links { margin-top: 1.5rem; font-size: 0.85rem; color: var(--muted); }
        .footer-links a { color: var(--accent); text-decoration: none; font-weight: 500; }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (LOGIN PAGE) ─── */

        @media (max-width: 768px) {
            body {
                padding: 20px;
                /* Allow scroll if the keyboard pushes content up */
                overflow-y: auto;
                align-items: flex-start;
                padding-top: 10vh;
            }

            .login-card {
                padding: 2rem 1.5rem;
                max-width: 100%;
                border-radius: 24px;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4);
            }

            h2 {
                font-size: 1.6rem;
            }
        }

        @media (max-width: 480px) {
            body {
                padding-top: 5vh;
            }

            .login-card {
                background: transparent;
                border: none;
                box-shadow: none;
                padding: 1rem;
            }

            h2 {
                font-size: 1.8rem; /* Slightly larger for emphasis on small screens */
                margin-bottom: 0.8rem;
            }

            p.subtitle {
                font-size: 0.85rem;
                margin-bottom: 2.5rem;
            }

            .input-group {
                margin-bottom: 1.5rem;
            }

            input {
                padding: 1rem; /* Better tap target */
                font-size: 1rem; /* Prevents iOS auto-zoom */
            }

            .btn-login {
                padding: 1.1rem;
                font-size: 1rem;
                margin-top: 1.5rem;
            }

            /* Ambient glow adjustment for mobile */
            body::before {
                width: 300px;
                height: 300px;
                top: -50px;
                left: -50px;
            }
        }

        /* ─── LANDSCAPE / KEYBOARD PROTECTION ─── */
        @media (max-height: 550px) {
            body {
                align-items: flex-start;
                padding-top: 20px;
                overflow-y: auto;
            }

            .login-card {
                margin-bottom: 40px;
            }
        }

        /* ─── TOUCH FEEDBACK ─── */
        @media (pointer: coarse) {
            .btn-login:active {
                transform: scale(0.98);
                filter: brightness(1.2);
                transition: 0.1s;
            }

            input {
                font-size: 16px; /* Strict enforcement to prevent iOS zoom */
            }
        }
    </style>
</head>
<body>

    <div class="login-card">
        <h2>Welcome Back</h2>
        <p class="subtitle">Enter your credentials to access the portal</p>

        <c:if test="${param.error == '1'}">
            <div class="alert alert-error">Invalid username or password.</div>
        </c:if>

        <c:if test="${param.registered == 'true'}">
            <div class="alert alert-success">Account created! Please login.</div>
        </c:if>

        <form action="LoginServlet" method="post">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="e.g. krishna_01" required>
            </div>

            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn-login">Sign In</button>
        </form>

        <div class="footer-links">
            Don't have an account? <a href="register.jsp">Create one</a>
        </div>
    </div>

</body>
</html>