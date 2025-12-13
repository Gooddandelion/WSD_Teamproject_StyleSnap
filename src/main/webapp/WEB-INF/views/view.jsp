<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>${snap.snap_title} - 스냅 상세</title>
</head>
<body>
<div class="container">
  <h1>${snap.snap_title}</h1>

  <div class="images">
    <div>
      <h3>코디 사진</h3>
      <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="코디 사진">
    </div>
    <div>
      <h3>상품 사진</h3>
      <img src="${pageContext.request.contextPath}${snap.product_image}" alt="상품 사진">
    </div>
  </div>

  <div class="info">
    <p><span class="label">카테고리:</span> ${snap.category}</p>
    <p><span class="label">스타일:</span> ${snap.style}</p>
    <p><span class="label">색상:</span> ${snap.color}</p>
    <p><span class="label">가격:</span> ${snap.price}원</p>

    <div class="stats">
      <span>👀 조회수 ${snap.view_count}</span>
      <span>❤️ 좋아요 ${snap.like_count}</span>
    </div>
  </div>

  <div class="buttons">
    <a href="${pageContext.request.contextPath}/snaps/edit/${snap.snap_id}" class="btn-edit">수정</a>
    <a href="${pageContext.request.contextPath}/snaps/delete/${snap.snap_id}" class="btn-delete"
       onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
    <a href="${pageContext.request.contextPath}/snaps/list" class="btn-list">목록으로</a>
  </div>
</div>
</body>
</html>