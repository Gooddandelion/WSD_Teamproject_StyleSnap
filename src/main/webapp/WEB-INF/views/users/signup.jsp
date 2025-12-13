<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>회원가입</title>
</head>
<body>
<div class="container">
    <h1>회원가입</h1>

    <form action="${pageContext.request.contextPath}/users/signup" method="post">
        <p>
            <label>이메일</label>
            <input type="email" name="email" required>
        </p>
        <p>
            <label>비밀번호</label>
            <input type="password" name="password" required>
        </p>
        <p>
            <label>닉네임</label>
            <input type="text" name="nickname" required>
        </p>
        <p>
            <button type="submit">가입하기</button>
        </p>
    </form>

    <div class="login-link">
        이미 계정이 있나요? <a href="${pageContext.request.contextPath}/users/login">로그인</a>
    </div>
</div>
</body>
</html>