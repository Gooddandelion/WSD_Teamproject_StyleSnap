<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인 - StyleZip</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/auth.css" rel="stylesheet">
</head>
<body>

<div class="auth-container">
    <div class="auth-logo">
        <h1><i class="fas fa-camera"></i> StyleZip</h1>
        <p>나만의 스타일을 공유하세요</p>
    </div>

    <div class="auth-card">
        <h2>로그인</h2>

        <c:if test="${param.error == 'true'}">
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                이메일 또는 비밀번호가 일치하지 않습니다.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/users/login" method="post">
            <div class="input-group">
                <div class="input-wrap">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" placeholder="이메일 주소" required>
                </div>
            </div>

            <div class="input-group">
                <div class="input-wrap">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" placeholder="비밀번호" required>
                </div>
            </div>

            <button type="submit" class="submit-btn">
                <i class="fas fa-sign-in-alt"></i> 로그인
            </button>
        </form>

        <div class="auth-footer">
            <p>아직 계정이 없으신가요?</p>
            <a href="${pageContext.request.contextPath}/users/signup">회원가입</a>
        </div>
    </div>

    <div class="home-link">
        <a href="${pageContext.request.contextPath}/">
            <i class="fas fa-home"></i> 홈으로 돌아가기
        </a>
    </div>
</div>

</body>
</html>