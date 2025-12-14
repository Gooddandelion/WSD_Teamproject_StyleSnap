<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>마이페이지 - 내 보관함</title>
</head>
<body>
<h1>📂 내 보관함 (My Archive)</h1>
<a href="${pageContext.request.contextPath}/snaps/list">🏠 전체 목록으로</a>
<hr/>

<div style="display: flex; flex-wrap: wrap; gap: 20px;">
    <c:forEach items="${folders}" var="f">
        <div style="border: 1px solid #ccc; padding: 20px; border-radius: 10px; width: 200px; text-align: center; background: #f9f9f9;">
            <div style="font-size: 50px;">📁</div>

            <h3>
                <a href="${pageContext.request.contextPath}/folder/view/${f.folder_id}">
                        ${f.folder_name}
                </a>
            </h3>
        </div>
    </c:forEach>

    <c:if test="${empty folders}">
        <p>생성된 폴더가 없습니다. 마음에 드는 스냅을 저장해보세요!</p>
    </c:if>
</div>
</body>
</html>