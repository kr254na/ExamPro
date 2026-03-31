<%@ page isErrorPage="true" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Anomaly | ExamPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #080c14;
            --surface: rgba(14, 20, 32, 0.8);
            --border: rgba(255, 255, 255, 0.08);
            --accent: #3b8ef3;
            --accent2: #6c63ff;
            --text: #e8edf5;
            --muted: #6b7a99;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background-color: var(--bg);
            background-image:
                radial-gradient(circle at 20% 30%, rgba(108, 99, 255, 0.05) 0%, transparent 40%),
                radial-gradient(circle at 80% 70%, rgba(59, 142, 243, 0.05) 0%, transparent 40%);
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        /* ─── FLOATING BACKGROUND ELEMENTS ─── */
        .orb {
            position: absolute;
            width: 300px;
            height: 300px;
            background: var(--accent2);
            filter: blur(120px);
            border-radius: 50%;
            opacity: 0.1;
            z-index: -1;
            animation: float 10s infinite alternate ease-in-out;
        }

        /* ─── ERROR CONTAINER ─── */
        .error-container {
            position: relative;
            text-align: center;
            padding: 4rem;
            background: var(--surface);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--border);
            border-radius: 40px;
            max-width: 600px;
            box-shadow: 0 40px 100px rgba(0, 0, 0, 0.5);
            z-index: 10;
        }

        .error-code {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 10rem;
            line-height: 0.8;
            background: linear-gradient(135deg, var(--accent2), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
            filter: drop-shadow(0 10px 20px rgba(108, 99, 255, 0.3));
            animation: pulse 4s infinite;
        }

        h1 {
            font-family: 'Syne', sans-serif;
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            letter-spacing: -1px;
        }

        p {
            color: var(--muted);
            line-height: 1.6;
            margin-bottom: 2.5rem;
            font-size: 1.1rem;
        }

        /* ─── BUTTON STYLING ─── */
        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            padding: 1.2rem 2.5rem;
            background: linear-gradient(135deg, var(--accent2), var(--accent));
            color: white;
            text-decoration: none;
            border-radius: 20px;
            font-weight: 700;
            font-family: 'Syne', sans-serif;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.9rem;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 30px rgba(108, 99, 255, 0.3);
        }

        .btn-home:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 20px 40px rgba(108, 99, 255, 0.5);
        }

        .glitch-wrapper {
            position: absolute;
            top: -50px;
            left: 50%;
            transform: translateX(-50%);
            opacity: 0.3;
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 12rem;
            color: white;
            z-index: -1;
            pointer-events: none;
            user-select: none;
        }

        /* ─── ANIMATIONS ─── */
        @keyframes float {
            from { transform: translate(-20%, -20%); }
            to { transform: translate(20%, 20%); }
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.8; transform: scale(0.98); }
        }

        /* Mobile Optimization */
        @media (max-width: 600px) {
            .error-code { font-size: 6rem; }
            h1 { font-size: 1.5rem; }
            .error-container { margin: 20px; padding: 2rem; }
        }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (ERROR PAGE) ─── */

        @media (max-width: 768px) {
            .error-container {
                padding: 3rem 2rem;
                margin: 0 1.5rem;
                border-radius: 30px;
            }

            .error-code {
                font-size: 7rem; /* Scale down the main error number */
            }

            .glitch-wrapper {
                font-size: 8rem; /* Scale down the ghost background number */
                top: -30px;
            }

            h1 {
                font-size: 1.8rem;
            }

            p {
                font-size: 1rem;
                margin-bottom: 2rem;
            }
        }

        @media (max-width: 480px) {
            .error-container {
                padding: 2.5rem 1.5rem;
                border-radius: 24px;
                /* Remove border/glass effect slightly to keep it clean on tiny screens */
                backdrop-filter: blur(10px);
            }

            .error-code {
                font-size: 5rem;
                margin-bottom: 0.5rem;
            }

            .glitch-wrapper {
                font-size: 6rem;
                top: -20px;
            }

            h1 {
                font-size: 1.5rem;
            }

            p {
                font-size: 0.9rem;
                line-height: 1.5;
            }

            .btn-home {
                padding: 1rem 1.8rem;
                font-size: 0.8rem;
                width: 100%; /* Full width button for easier thumb access */
                justify-content: center;
            }

            .orb {
                width: 150px;
                height: 150px;
            }
        }

        /* ─── LANDSCAPE / HEIGHT FIX ─── */
        @media (max-height: 600px) {
            body {
                padding: 2rem 0;
                height: auto;
                overflow-y: auto; /* Allow scrolling if screen is too short for the box */
            }
            .error-container {
                margin: 2rem 0;
            }
            .glitch-wrapper {
                display: none; /* Hide background text in landscape to save vertical space */
            }
        }
    </style>
</head>
<body>

    <div class="orb"></div>

    <div class="error-container">
        <div class="glitch-wrapper"><%= response.getStatus() %></div>

        <div class="error-code">
            <%= response.getStatus() %>
        </div>

        <h1>System Anomaly</h1>
        <p>
            The requested sequence was interrupted. This could be due to an expired session,
            a missing link, or a temporary ripple in our server matrix.
        </p>

        <a href="/index.jsp" class="btn-home">
            <span>⚡</span> Escape to Safety
        </a>
    </div>

</body>
</html>