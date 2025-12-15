<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>스냅 수정</title>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<h1>스냅 수정</h1>

<form action="${pageContext.request.contextPath}/snaps/edit/ok" method="post" enctype="multipart/form-data">
    <input type="hidden" name="snap_id" value="${u.snap_id}">
    <!-- 기존 이미지 경로 hidden으로 보관 -->
    <input type="hidden" name="coord_image" value="${u.coord_image}">
    <input type="hidden" name="product_image" value="${u.product_image}">

    <p>
        <label>제목</label><br>
        <input type="text" name="snap_title" value="${u.snap_title}" required>
    </p>
    <p>
        <label>코디 사진</label><br>
        <img src="${pageContext.request.contextPath}${u.coord_image}" width="150"><br>
        <input type="file" name="coordFile" accept="image/*">
        <small>새 이미지를 선택하지 않으면 기존 이미지 유지</small>
    </p>
    <p>
        <label>상품 사진</label><br>
        <img src="${pageContext.request.contextPath}${u.product_image}" width="150"><br>
        <input type="file" name="productFile" accept="image/*">
        <small>새 이미지를 선택하지 않으면 기존 이미지 유지</small>
    </p>
    <p>
        <label>카테고리</label><br>
        <select name="category">
            <option value="상의" ${u.category == '상의' ? 'selected' : ''}>상의</option>
            <option value="하의" ${u.category == '하의' ? 'selected' : ''}>하의</option>
            <option value="아우터" ${u.category == '아우터' ? 'selected' : ''}>아우터</option>
            <option value="신발" ${u.category == '신발' ? 'selected' : ''}>신발</option>
            <option value="악세서리" ${u.category == '악세서리' ? 'selected' : ''}>악세서리</option>
        </select>
    </p>
    <p>
        <label>스타일</label><br>
        <select name="style">
            <option value="캐주얼" ${u.style == '캐주얼' ? 'selected' : ''}>캐주얼</option>
            <option value="스트릿" ${u.style == '스트릿' ? 'selected' : ''}>스트릿</option>
            <option value="미니멀" ${u.style == '미니멀' ? 'selected' : ''}>미니멀</option>
            <option value="빈티지" ${u.style == '빈티지' ? 'selected' : ''}>빈티지</option>
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