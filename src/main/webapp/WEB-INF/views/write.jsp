<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>스냅 작성</title>
</head>
<body>
<h1>스냅 작성</h1>

<form action="/snaps/write" method="post">
    <p>
        <label>제목</label><br>
        <input type="text" name="snap_title" required>
    </p>
    <p>
        <label>이미지 URL</label><br>
        <input type="text" name="image_url" placeholder="이미지 경로 입력">
    </p>
    <p>
        <label>카테고리</label><br>
        <select name="category">
            <option value="상의">상의</option>
            <option value="하의">하의</option>
            <option value="아우터">아우터</option>
            <option value="신발">신발</option>
            <option value="악세서리">악세서리</option>
        </select>
    </p>
    <p>
        <label>스타일</label><br>
        <select name="style">
            <option value="캐주얼">캐주얼</option>
            <option value="스트릿">스트릿</option>
            <option value="미니멀">미니멀</option>
            <option value="빈티지">빈티지</option>
        </select>
    </p>
    <p>
        <label>색상</label><br>
        <input type="text" name="color" placeholder="예: 블랙, 화이트">
    </p>
    <p>
        <label>가격</label><br>
        <input type="number" name="price" value="0">
    </p>
    <p>
        <button type="submit">등록</button>
    </p>
</form>

<a href="/snaps">목록으로</a>
</body>
</html>