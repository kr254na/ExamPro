<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%
    if (session.getAttribute("user") == null || !"STUDENT".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | ExamPro</title>
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
            color: var(--accent2);
            margin-bottom: 3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-links { list-style: none; flex: 1; }
        .nav-links li { margin-bottom: 0.5rem; }
        .nav-links a {
            text-decoration: none;
            color: var(--muted);
            padding: 0.8rem 1rem;
            display: block;
            border-radius: 10px;
            transition: all 0.3s;
            font-weight: 500;
        }
        .nav-links a:hover, .nav-links a.active {
            background: rgba(108,99,255,0.1);
            color: var(--accent2);
        }

        /* ─── MAIN CONTENT ───────────────────────────── */
        .main-content {
            flex: 1;
            padding: 3rem;
            overflow-y: auto;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 3rem;
        }

        header h1 { font-family: 'Syne', sans-serif; font-size: 2rem; }

        /* Join Batch Section */
        .join-box {
            background: var(--surface);
            padding: 1.5rem;
            border-radius: 20px;
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 3rem;
        }

        .join-box input {
            flex: 1;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border);
            padding: 0.8rem 1.2rem;
            border-radius: 12px;
            color: white;
            font-family: inherit;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .btn-join {
            background: linear-gradient(135deg, var(--accent2), #8a84ff);
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-join:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(108,99,255,0.2); }

        /* Quick Stats */
        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: var(--surface);
            padding: 1.5rem;
            border-radius: 16px;
            border: 1px solid var(--border);
        }
        .stat-card span { color: var(--muted); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; }
        .stat-card h2 { font-family: 'Syne', sans-serif; font-size: 1.8rem; margin-top: 0.5rem; color: var(--success); }

        /* Card Grid */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

       .card {
           position: relative; /* Required for absolute positioning of the pill */
           background: linear-gradient(145deg, #10192c, #0e1420);
           padding: 2rem;
           border-radius: 24px;
           border: 1px solid var(--border);
           transition: all 0.4s ease;
       }

       .pending-pill {
           position: absolute;
           top: -10px;
           right: -10px;
           background: var(--danger);
           color: white;
           font-size: 0.9rem;
           font-weight: 800;
           padding: 4px 10px;
           border-radius: 99px;
           box-shadow: 0 4px 12px rgba(255, 94, 125, 0.4);
           border: 2px solid var(--bg);
           font-family: 'Syne', sans-serif;
           animation: bounce 2s infinite;
       }

       @keyframes bounce {
           0%, 100% { transform: translateY(0); }
           50% { transform: translateY(-5px); }
       }

        .card:hover {
            border-color: var(--accent2);
            transform: translateY(-5px);
        }

        .card h3 { font-family: 'Syne', sans-serif; font-size: 1.2rem; margin-bottom: 1rem; color: var(--text); }
        .card .batch-code { color: var(--accent2); font-weight: 700; font-size: 0.8rem; margin-bottom: 1rem; display: block; }

        .btn-action {
            display: inline-block;
            width: 100%;
            text-align: center;
            padding: 0.8rem;
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--border);
            border-radius: 12px;
            color: var(--text);
            text-decoration: none;
            font-weight: 600;
            margin-top: 1rem;
            transition: 0.3s;
        }

        .btn-action:hover { background: var(--accent2); border-color: var(--accent2); }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (STUDENT DASHBOARD) ─── */

        @media (max-width: 1024px) {
            body { flex-direction: column; }

            .sidebar {
                width: 100%; height: auto; padding: 1rem 1.5rem;
                flex-direction: row; align-items: center; justify-content: space-between;
                position: sticky; top: 0; z-index: 100;
                background: rgba(11, 17, 32, 0.95); backdrop-filter: blur(10px);
                border-right: none; border-bottom: 1px solid var(--border);
            }

            .nav-links { display: none; }

            .main-content { padding: 2rem 1.2rem; }
        }

        @media (max-width: 768px) {
            header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
                text-align: left;
            }

            header h1 { font-size: 1.6rem; }

            /* Stack the Join Box elements vertically */
            .join-box {
                flex-direction: column;
                align-items: stretch;
                padding: 1.2rem;
                gap: 10px;
            }

            .join-box label { font-size: 0.8rem; text-align: center; }

            .btn-join { width: 100%; }

            .stats-bar {
                grid-template-columns: 1fr; /* Stack stats vertically */
                gap: 1rem;
            }

            .card-grid {
                grid-template-columns: 1fr;
            }

            .card {
                padding: 1.5rem;
            }
        }

        @media (max-width: 480px) {
            .main-content { padding: 1.5rem 1rem; }

            .join-box input {
                font-size: 0.9rem;
                letter-spacing: 1px;
                text-align: center;
            }

            /* Prevent the pending pill from being too large on tiny screens */
            .pending-pill {
                font-size: 0.75rem;
                padding: 2px 8px;
                top: -5px;
                right: -5px;
            }

            .stat-card h2 { font-size: 1.5rem; }

            .btn-action {
                padding: 1rem;
                font-size: 0.9rem;
            }
        }

        /* ─── TOUCH & ACCESSIBILITY ─── */
        @media (pointer: coarse) {
            .join-box input {
                font-size: 16px; /* Prevents auto-zoom on iOS */
            }

            .card:hover {
                transform: none; /* Disable hover lift to prevent sticky UI */
            }

            .btn-action:active {
                background: var(--accent2);
                transform: scale(0.98);
            }
        }

        /* --- Global Styles --- */
        .menu-toggle {
            display: none; /* Hide on Desktop */
        }

        .mobile-only {
            display: none; /* Hide on Desktop */
        }

        /* --- Responsive Styles (Inside @media max-width: 1024px) --- */
        @media (max-width: 1024px) {
            .menu-toggle {
                display: block !important; /* Force show on mobile */
                background: rgba(255,255,255,0.05);
                border: 1px solid var(--border);
                color: var(--accent);
                font-size: 1.5rem;
                padding: 0.5rem 0.8rem;
                border-radius: 8px;
                cursor: pointer;
                z-index: 101;
            }

            .desktop-only-logout {
                display: none !important; /* Hide the bottom logout on mobile */
            }

            .mobile-only {
                display: block; /* Show logout inside the menu */
                border-top: 1px solid var(--border);
                margin-top: 1rem;
            }

            .nav-links {
                display: none; /* Hidden by default */
                position: absolute;
                top: 100%;
                left: 0;
                width: 100%;
                background: var(--panel);
                flex-direction: column;
                padding: 1.5rem;
                border-bottom: 1px solid var(--border);
                z-index: 100;
            }

            .nav-links.show {
                display: flex !important; /* Show when toggled */
            }
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo">
            <div style="width:10px; height:10px; background:var(--accent2); border-radius:50%; box-shadow:0 0 10px var(--accent2);"></div>
            ExamPro Student
        </div>
        <button class="menu-toggle" onclick="toggleMobileMenu()">☰</button>
        <ul class="nav-links" id="mobileMenu">
            <li><a href="#" class="active">Dashboard</a></li>
            <li><a href="/student/results">Results</a></li>
        </ul>
        <a href="/LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>

    </aside>

    <main class="main-content">
        <header>
            <div>
                <h1>Welcome, ${sessionScope.user.username}</h1>
                <p style="color:var(--muted);">Join a classroom or start the test.</p>
            </div>
            <div style="background: rgba(108,99,255,0.1); color: var(--accent2); padding: 0.5rem 1rem; border-radius: 99px; font-size: 0.8rem; font-weight: 700;">
                Live Session
            </div>
        </header>

        <form action="/student/join-batch" method="post" class="join-box">
            <label style="font-family: 'Syne'; font-weight: 700; color: var(--accent2);">JOIN CLASS:</label>
            <input type="text" name="batchCode" placeholder="ENTER 6-DIGIT BATCH CODE" maxlength="6" required>
            <button type="submit" class="btn-join">Connect +</button>
        </form>

        <section class="stats-bar">
            <div class="stat-card">
                <span>Joined Batches</span>
                <h2>${joinedBatchesCount}</h2>
            </div>
            <div class="stat-card">
                <span>Pending Exams</span>
                <h2>${pendingExamsCount}</h2>
            </div>
            <div class="stat-card">
                <span>Completed Exams</span>
                <h2>${completedExamsCount}</h2>
            </div>
        </section>

        <h2 style="font-family: 'Syne'; margin-bottom: 2rem;">My Active Classrooms</h2>

        <section class="card-grid">
            <c:forEach var="batch" items="${joinedBatches}">
                <div class="card">
                    <c:if test="${batch.pendingCount > 0}">
                        <div class="pending-pill">${batch.pendingCount}</div>
                    </c:if>

                    <span class="batch-code">CODE: ${batch.batchCode}</span>
                    <h3>${batch.batchName}</h3>
                    <p style="font-size: 0.85rem; color: var(--muted); margin-bottom: 1rem;">Instructor: ${batch.teacherName}</p>
                    <a href="/student/batch-exams?id=${batch.batchId}" class="btn-action">View Assignments →</a>
                </div>
            </c:forEach>
        </section>
    </main>
<script>
function toggleMobileMenu() {
            const menu = document.getElementById("mobileMenu");
            menu.classList.toggle("show");
        }
</script>
</body>
</html>