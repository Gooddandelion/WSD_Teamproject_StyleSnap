<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Snap List</title>
</head>
<body>

<h1>Snap List</h1>

<a href="write">✏️ 새 글 작성</a> |
<a href="${pageContext.request.contextPath}/folder/my">📂 내 보관함</a>
<a href="${pageContext.request.contextPath}/users/logout" style="float:right; color:red;">로그아웃</a>

<hr/>

<h1>Snap List</h1>
<a href="write">새 글 작성</a> <hr/>

<table border="1" width="80%">
    <tr>
        <th>ID</th>
        <th>카테고리</th>
        <th>제목</th>
        <th>스타일</th>
        <th>가격</th>
        <th>관리</th>
    </tr>
    <c:forEach items="${list}" var="u">
        <tr>
            <td>${u.snap_id}</td>
            <td>${u.category}</td>
            <td> <a href="view/${u.snap_id}">${u.snap_title}</a></td>
            <td>${u.style}</td>
            <td>${u.price}</td>
            <td>
                <a href="delete/${u.snap_id}">삭제</a>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>