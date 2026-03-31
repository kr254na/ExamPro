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
    <title>Manage Students | Exam Portal</title>
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

        .btn-register-link {
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--border);
            color: var(--text);
            text-decoration: none;
            padding: 0.7rem 1.2rem;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.85rem;
            transition: 0.3s;
        }
        .btn-register-link:hover { border-color: var(--accent); background: rgba(59,142,243,0.1); }

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

        .user-avatar {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.8rem;
            color: white;
            margin-right: 12px;
        }

        .role-badge {
            padding: 0.3rem 0.6rem;
            border-radius: 6px;
            font-size: 0.7rem;
            font-weight: 700;
            background: rgba(59,142,243,0.1);
            color: var(--accent);
            text-transform: uppercase;
        }

        .actions { display: flex; gap: 10px; }
        .btn-action {
            background: none;
            border: 1px solid var(--border);
            padding: 0.5rem 0.8rem;
            border-radius: 8px;
            cursor: pointer;
            color: var(--muted);
            transition: 0.2s;
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .btn-edit:hover { border-color: var(--accent); color: var(--accent); }
        .btn-delete:hover { border-color: var(--danger); color: var(--danger); }

        .empty-state { padding: 5rem; text-align: center; color: var(--muted); }

        /* ─── ULTRA PRO MAX RESPONSIVENESS (STUDENT MANAGEMENT) ─── */

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
            header { text-align: center; }
            header h1 { font-size: 1.6rem; }

            /* ─── TRANSFORM TABLE TO CARDS ─── */
            .table-container { background: transparent; border: none; box-shadow: none; }

            table, thead, tbody, th, td, tr { display: block; width: 100%; }

            thead { display: none; } /* Hide headers */

            tr {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 20px;
                margin-bottom: 1.2rem;
                padding: 1.5rem;
                transition: 0.3s;
            }

            td {
                border: none;
                padding: 0.5rem 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            /* Labeling IDs and Roles since headers are gone */
            td:nth-of-type(2)::before { content: "System ID"; color: var(--muted); font-size: 0.75rem; }
            td:nth-of-type(3)::before { content: "Access Level"; color: var(--muted); font-size: 0.75rem; }

            /* Action styling for mobile */
            .actions {
                margin-top: 1rem;
                padding-top: 1rem;
                border-top: 1px solid var(--border);
                justify-content: stretch;
            }

            .btn-action {
                flex: 1;
                text-align: center;
                padding: 0.8rem;
            }
        }

        @media (max-width: 480px) {
            .main-content { padding: 1.5rem 1rem; }

            .user-avatar {
                width: 40px;
                height: 40px;
                font-size: 1rem;
            }

            .actions {
                flex-direction: column; /* Stack Edit and Delete on very small screens */
            }

            .empty-state { padding: 3rem 1rem; }
        }

        /* ─── TOUCH TARGET OPTIMIZATION ─── */
        @media (pointer: coarse) {
            .btn-action {
                min-height: 48px;
                display: flex;
                align-items: center;
                justify-content: center;
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
            <div style="width:10px; height:10px; background:var(--accent); border-radius:50%; box-shadow:0 0 10px var(--accent);"></div>
            ExamPro Teacher
        </div>
        <button class="menu-toggle" onclick="toggleMobileMenu()">☰</button>
        <ul class="nav-links" id="mobileMenu">
            <li><a href="/teacher-dashboard">Dashboard</a></li>
            <li><a href="/manage-questions">Question Bank</a></li>
             <li><a href="/exam/new">Create Exam</a></li>
             <li><a href="/my-exams">My Exams</a></li>
             <li><a href="/batch">Batches</a></li>
              <li><a href="/assignments" >Exam Assignments</a></li>
            <li><a href="/view-results">Exam Results</a></li>
        </ul>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:700; margin-top:auto;">Sign Out →</a>
    </aside>

    <main class="main-content">
        <header>
            <h1>Student Management</h1>
            <p>View, update, or remove student accounts registered in the portal.</p>
        </header>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Student</th>
                        <th>User ID</th>
                        <th>Account Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- JSTL Loop to display users fetched from UserDao --%>
                    <c:forEach var="student" items="${studentList}">
                        <tr>
                            <td>
                                <div style="display: flex; align-items: center;">
                                    <div class="user-avatar">${student.username.substring(0,1).toUpperCase()}</div>
                                    <span style="font-weight: 500;">${student.username}</span>
                                </div>
                            </td>
                            <td style="color: var(--muted); font-family: monospace;">#USR-${student.id}</td>
                            <td><span class="role-badge">${student.role}</span></td>
                            <td class="actions">
                                <a href="EditUserServlet?id=${student.id}" class="btn-action btn-edit">Edit Profile</a>
                                <a href="DeleteUserServlet?id=${student.id}"
                                   class="btn-action btn-delete"
                                   onclick="return confirm('Warning: Deleting this student will also remove their exam history. Proceed?')">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty studentList}">
                        <tr>
                            <td colspan="4" class="empty-state">
                                No students are currently registered. <br>
                                <span style="font-size: 0.85rem;">New students will appear here once they sign up.</span>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
    <script>
    function toggleMobileMenu() {
                const menu = document.getElementById("mobileMenu");
                menu.classList.toggle("show");
            }
    </script>
</body>
</html>