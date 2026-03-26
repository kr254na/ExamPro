<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>Exam Result</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; display: flex; justify-content: center; padding-top: 50px; }
        .result-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: center; width: 400px; }
        .score-circle { width: 120px; height: 120px; line-height: 120px; border-radius: 50%; background: #4CAF50; color: white; font-size: 32px; margin: 20px auto; font-weight: bold; }
        .stats { text-align: left; margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px; }
        .stats p { margin: 8px 0; color: #555; display: flex; justify-content: space-between; }
        .btn-home { display: inline-block; margin-top: 25px; padding: 10px 20px; background: #2196F3; color: white; text-decoration: none; border-radius: 5px; transition: 0.3s; }
        .btn-home:hover { background: #1976D2; }
        .status-pass { color: #4CAF50; font-weight: bold; }
        .status-fail { color: #f44336; font-weight: bold; }
    </style>
</head>
<body>

<div class="result-card">
    <h2>Exam Performance</h2>

    <div class="score-circle">
        ${score} / ${totalQuestions}
    </div>

    <div class="stats">
        <p><span>Total Questions:</span> <strong>${totalQuestions}</strong></p>
        <p><span>Attempted:</span> <strong>${attempted}</strong></p>
        <p><span>Correct Answers:</span> <strong style="color: green;">${score}</strong></p>
        <p><span>Wrong Answers:</span> <strong style="color: red;">${attempted - score}</strong></p>
        <p><span>Percentage:</span> <strong>${(score / totalQuestions) * 100.0}%</strong></p>
    </div>

    <c:choose>
        <c:when test="${(score / totalQuestions) >= 0.4}">
            <p class="status-pass">Status: PASSED</p>
        </c:when>
        <c:otherwise>
            <p class="status-fail">Status: FAILED</p>
        </c:otherwise>
    </c:choose>

    <a href="index.jsp" class="btn-home">Back to Dashboard</a>
</div>
</html>