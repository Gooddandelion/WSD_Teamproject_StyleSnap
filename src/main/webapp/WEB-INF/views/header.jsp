<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="header">
    <a href="${pageContext.request.contextPath}/snaps/list">🏠 홈</a> |
    <a href="${pageContext.request.contextPath}/snaps/write">✏️ 새 글 작성</a> |

    <c:choose>
        <c:when test="${not empty sessionScope.loginUser}">
            <span>${sessionScope.loginUser.nickname}님</span> |
            <a href="${pageContext.request.contextPath}/folder/my">📂 내 보관함</a> |
            <a href="${pageContext.request.contextPath}/users/logout">로그아웃</a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/users/login">로그인</a> |
            <a href="${pageContext.request.contextPath}/users/signup">회원가입</a>
        </c:otherwise>
    </c:choose>
</div>
<hr/>