<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${folderName} - 폴더 상세</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<h1>📂 ${folderName}</h1>
<p>이 폴더에 저장된 스냅 목록입니다.</p>
<a href="${pageContext.request.contextPath}/folder/my">🔙 내 보관함으로 돌아가기</a>
<hr/>

<div style="display: flex; flex-wrap: wrap; gap: 15px;">
    <c:forEach items="${list}" var="snap">
        <div style="border: 1px solid #ddd; width: 200px; padding: 10px; text-align: center;">
            <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                <img src="${pageContext.request.contextPath}${snap.coord_image}" width="100%" height="200" style="object-fit: cover;">
            </a>
            <p><b>${snap.snap_title}</b></p>
            <p>❤️ ${snap.like_count}</p>
        </div>
    </c:forEach>

    <c:if test="${empty list}">
        <p>이 폴더는 비어있습니다.</p>
    </c:if>
</div>
</body>
</html>