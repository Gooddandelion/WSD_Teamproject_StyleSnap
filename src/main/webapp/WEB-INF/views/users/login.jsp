<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>로그인</title>
</head>
<body>
<div class="container">
    <h1>로그인</h1>

    <c:if test="${param.error == 'true'}">
        <p class="error">이메일 또는 비밀번호가 일치하지 않습니다.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/users/login" method="post">
        <p>
            <label>이메일</label>
            <input type="email" name="email" required>
        </p>
        <p>
            <label>비밀번호</label>
            <input type="password" name="password" required>
        </p>
        <p>
            <button type="submit">로그인</button>
        </p>
    </form>

    <div class="signup-link">
        계정이 없나요? <a href="${pageContext.request.contextPath}/users/signup">회원가입</a>
    </div>
</div>
</body>
</html>