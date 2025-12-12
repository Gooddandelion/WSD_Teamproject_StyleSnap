<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>스냅 수정</title>
</head>
<body>
<h1>스냅 수정</h1>

<form action="${pageContext.request.contextPath}/snaps/edit/ok" method="post">
    <input type="hidden" name="snap_id" value="${u.snap_id}">

    <p>
        <label>제목</label><br>
        <input type="text" name="snap_title" value="${u.snap_title}" required>
    </p>
    <p>
        <label>이미지 URL</label><br>
        <input type="text" name="image_url" value="${u.image_url}">
    </p>
    <p>
        <label>카테고리 (현재: ${u.category})</label><br>
        <select name="category">
            <option value="상의">상의</option>
            <option value="하의">하의</option>
            <option value="아우터">아우터</option>
            <option value="신발">신발</option>
            <option value="악세서리">악세서리</option>
        </select>
    </p>
    <p>
        <label>스타일 (현재: ${u.style})</label><br>
        <select name="style">
            <option value="캐주얼">캐주얼</option>
            <option value="스트릿">스트릿</option>
            <option value="미니멀">미니멀</option>
            <option value="빈티지">빈티지</option>
        </select>
    </p>
    <p>
        <label>색상</label><br>
        <input type="text" name="color" value="${u.color}">
    </p>
    <p>
        <label>가격</label><br>
        <input type="number" name="price" value="${u.price}">
    </p>
    <p>
        <button type="submit">수정 완료</button>
        <a href="${pageContext.request.contextPath}/snaps/list">취소</a>
    </p>
</form>

</body>
</html>