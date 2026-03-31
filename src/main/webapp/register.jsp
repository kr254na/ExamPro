<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Exam Portal</title>
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

        body::before {
            content: ''; position: absolute; width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(108,99,255,0.08) 0%, transparent 70%);
            bottom: -100px; right: -100px; z-index: -1;
        }

        .register-card {
            background: var(--surface);
            padding: 2.5rem;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.05);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 400px;
            text-align: center;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        h2 {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, var(--accent2), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        p.subtitle { color: var(--muted); font-size: 0.9rem; margin-bottom: 2rem; }

        .input-group { text-align: left; margin-bottom: 1.2rem; }

        label { display: block; font-size: 0.75rem; color: var(--muted); margin-bottom: 0.5rem; text-transform: uppercase; letter-spacing: 1px; }

        input, select {
            width: 100%;
            padding: 0.8rem 1rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 10px;
            font-family: inherit;
            transition: all 0.3s;
            box-sizing: border-box;
            color:white;
        }

        option{
        color:black;
        }
        select {
        cursor: pointer;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%236b7a99' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: calc(100% - 1rem) center;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--accent2);
            background: rgba(108,99,255,0.05);
        }

        .btn-register {
            width: 100%;
            padding: 1rem;
            margin-top: 1rem;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none;
            border-radius: 10px;
            color: white;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-register:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(59,142,243,0.2); }

        .alert-error {
            font-size: 0.85rem; padding: 0.75rem; border-radius: 8px; margin-bottom: 1.5rem;
            background: rgba(255, 94, 125, 0.1); color: var(--danger); border: 1px solid rgba(255, 94, 125, 0.2);
        }

        .footer-links { margin-top: 1.5rem; font-size: 0.85rem; color: var(--muted); }
        .footer-links a { color: var(--accent2); text-decoration: none; font-weight: 500; }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (REGISTER PAGE) ─── */

        @media (max-width: 768px) {
            body {
                padding: 20px;
                overflow-y: auto; /* Enable scrolling for longer forms */
                align-items: flex-start; /* Prevent clipping at the top */
                padding-top: 8vh;
                height: auto;
                min-height: 100vh;
            }

            .register-card {
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
                padding-top: 4vh;
            }

            .register-card {
                background: transparent;
                border: none;
                box-shadow: none;
                padding: 1rem;
            }

            h2 {
                font-size: 1.8rem;
                margin-bottom: 0.8rem;
            }

            p.subtitle {
                font-size: 0.85rem;
                margin-bottom: 2rem;
            }

            .input-group {
                margin-bottom: 1.2rem;
            }

            input, select {
                padding: 1rem;
                font-size: 1rem; /* Crucial: 16px+ prevents iOS auto-zoom */
            }

            /* Custom dropdown arrow placement for mobile */
            select {
                background-position: calc(100% - 1.2rem) center;
            }

            .btn-register {
                padding: 1.1rem;
                font-size: 1rem;
                margin-top: 1rem;
            }

            /* Adjust ambient glow for mobile */
            body::before {
                width: 300px;
                height: 300px;
                bottom: -50px;
                right: -50px;
            }
        }

        /* ─── UI FIX FOR SELECT OPTIONS (DARK THEME) ─── */
        select option {
            background-color: #0e1420; /* Matches --surface */
            color: var(--text);
        }

        /* ─── LANDSCAPE / KEYBOARD FIX ─── */
        @media (max-height: 600px) {
            body {
                align-items: flex-start;
                padding-top: 20px;
            }
            .register-card {
                margin-bottom: 30px;
            }
        }

        /* ─── TOUCH FEEDBACK ─── */
        @media (pointer: coarse) {
            .btn-register:active {
                transform: scale(0.98);
                filter: brightness(1.1);
            }

            input, select {
                font-size: 16px; /* Enforces no-zoom on mobile safari/chrome */
            }
        }
    </style>
</head>
<body>

    <div class="register-card">
        <h2>Create Account</h2>
        <p class="subtitle">Join the portal as a Student or Teacher</p>

        <c:if test="${param.error == 'exists'}">
            <div class="alert-error">Username already taken. Try another.</div>
        </c:if>

        <form action="RegisterServlet" method="post">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Choose a username" required>
            </div>

            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>

            <div class="input-group">
                <label>Select Role</label>
                <select name="role" required>
                    <option value="" disabled selected>Select your role</option>
                    <option value="STUDENT">Student</option>
                    <option value="TEACHER">Teacher</option>
                </select>
            </div>

            <button type="submit" class="btn-register">Sign Up</button>
        </form>

        <div class="footer-links">
            Already have an account? <a href="login.jsp">Sign in here</a>
        </div>
    </div>

</body>
</html>