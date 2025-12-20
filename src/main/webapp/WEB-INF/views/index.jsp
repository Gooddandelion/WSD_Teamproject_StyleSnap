<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>StyleZip - AI 기반 패션 추천</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/index.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-light bg-white sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">StyleZip</a>
        <div>
            <a href="${pageContext.request.contextPath}/chat/" title="AI 코디 추천" style="margin-left: 10px; margin-right: 5px; color: #333;">
                <i class="fas fa-robot"></i>
            </a>
            <c:choose>
                <c:when test="${not empty sessionScope.loginUser}">
                    <a href="${pageContext.request.contextPath}/folder/my" class="btn btn-link text-dark">
                        <i class="fas fa-user"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/users/login" class="btn btn-link text-dark">
                        <i class="far fa-user"></i>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<div class="container mt-3">

    <div class="card-section">
        <div class="section-header">
            <h5>AI 맥락 인식 추천</h5>
            <a href="${pageContext.request.contextPath}/chat/">AI에게 물어보기 <i class="fas fa-chevron-right"></i></a>
        </div>

        <div class="row align-items-center">
            <div class="col-4">
                <div class="ai-box">
                    <h6>오늘의 방문지</h6>
                    <h4>서울숲 🌲</h4>
                    <hr style="opacity: 0.1; margin: 10px 0;">
                    <h6>추천 스타일</h6>
                    <h4>캐주얼<br>데이트룩</h4>
                </div>
            </div>
            <div class="col-8">
                <div class="row g-2">
                    <c:choose>
                        <c:when test="${not empty recentSnaps}">
                            <c:forEach items="${recentSnaps}" var="snap" end="2">
                                <div class="col-4">
                                    <div class="snap-card">
                                        <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                                            <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="${snap.snap_title}">
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 empty-state">등록된 스냅이 없습니다.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <div class="card-section">
        <h5 class="mb-3">폴더 & 트렌드</h5>

        <div class="row">
            <div class="col-md-6 two-col-left">
                <div class="section-header">
                    <h6>MY 폴더</h6>
                    <c:if test="${not empty sessionScope.loginUser}">
                        <a href="${pageContext.request.contextPath}/folder/my">더보기 <i class="fas fa-chevron-right"></i></a>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty sessionScope.loginUser}">
                        <div class="row g-2">
                            <c:forEach items="${recentSnaps}" var="snap" begin="0" end="1">
                                <div class="col-6">
                                    <div class="snap-card">
                                        <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                                            <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="">
                                        </a>
                                        <button class="heart-btn"><i class="far fa-heart"></i></button>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty recentSnaps}">
                                <div class="col-12 empty-state small py-3">저장된 스냅이 없습니다.</div>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-folder-open fa-2x mb-3"></i>
                            <p class="small mb-0"><a href="${pageContext.request.contextPath}/users/login">로그인</a>하고<br>나만의 폴더를 만드세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="col-md-6 two-col-right">
                <div class="section-header">
                    <h6>실시간 인기 스타일</h6>
                    <a href="${pageContext.request.contextPath}/snaps/list?sort=popular">더보기 <i class="fas fa-chevron-right"></i></a>
                </div>

                <div class="row">
                    <div class="col-6">
                        <c:forEach items="${popularSnaps}" var="snap" end="0">
                            <div class="snap-card mb-2">
                                <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                                    <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="">
                                    <div style="position:absolute; top:8px; left:8px; background:black; color:white; width:24px; height:24px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size:0.8rem;">1</div>
                                </a>
                            </div>
                            <p class="small mb-0 fw-bold text-truncate">${snap.snap_title}</p>
                            <p class="small text-muted">❤️ ${snap.like_count}</p>
                        </c:forEach>
                    </div>

                    <div class="col-6">
                        <c:forEach items="${popularSnaps}" var="snap" begin="1" end="3">
                            <div class="trend-item">
                                <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                                    <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="">
                                    <div class="info">
                                        <div class="title">${snap.snap_title}</div>
                                        <div class="sub">🔥 인기 급상승</div>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card-section">
        <h5 class="mb-2">유사 스타일 할인 정보</h5>
        <p class="text-muted small mb-3">AI가 분석한 스타일에 맞는 상품입니다.</p>

        <div class="row g-3">
            <c:forEach items="${recentSnaps}" var="snap" end="5">
                <div class="col-4 col-md-2">
                    <div class="shop-card" onclick="location.href='${pageContext.request.contextPath}/snaps/view/${snap.snap_id}'">
                        <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="">
                        <p class="title">[${snap.style}] ${snap.category}</p>
                        <p class="price">
                            <fmt:formatNumber value="${snap.price}" pattern="#,###"/>원
                            <span class="discount">10%</span>
                        </p>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty recentSnaps}">
                <div class="col-12 empty-state">등록된 상품이 없습니다.</div>
            </c:if>
        </div>
    </div>

    <div class="card-section">
        <div class="section-header">
            <h5>최신 업데이트</h5>
            <a href="${pageContext.request.contextPath}/snaps/list">전체보기 <i class="fas fa-chevron-right"></i></a>
        </div>

        <div class="row g-3">
            <c:forEach items="${recentSnaps}" var="snap" end="3">
                <div class="col-6 col-md-3">
                    <div class="snap-card">
                        <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                            <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="${snap.snap_title}">
                        </a>
                        <button class="heart-btn"><i class="far fa-heart"></i></button>
                    </div>
                    <p class="fw-bold mt-2 mb-0 text-truncate">${snap.snap_title}</p>
                    <p class="small text-muted mb-1">${snap.category} · ${snap.style}</p>
                    <p class="small text-secondary">
                        <i class="far fa-heart"></i> ${snap.like_count} &nbsp;
                        <i class="far fa-eye"></i> ${snap.view_count}
                    </p>
                </div>
            </c:forEach>

            <c:if test="${empty recentSnaps}">
                <div class="col-12 empty-state">
                    <i class="fas fa-camera fa-3x mb-3"></i>
                    <p>아직 등록된 스냅이 없습니다.<br>
                        <a href="${pageContext.request.contextPath}/snaps/write">첫 번째 스냅을 올려보세요!</a>
                    </p>
                </div>
            </c:if>
        </div>
    </div>

</div>

<nav class="navbar fixed-bottom navbar-light bg-white border-top d-md-none">
    <div class="container justify-content-around">
        <a href="${pageContext.request.contextPath}/" class="text-center text-decoration-none active">
            <i class="fas fa-home"></i><br><small>홈</small>
        </a>
        <a href="${pageContext.request.contextPath}/snaps/list" class="text-center text-decoration-none">
            <i class="fas fa-search"></i><br><small>검색</small>
        </a>
        <a href="${pageContext.request.contextPath}/snaps/write" class="text-center text-decoration-none">
            <i class="fas fa-plus-square"></i><br><small>등록</small>
        </a>
        <a href="${pageContext.request.contextPath}/folder/my" class="text-center text-decoration-none">
            <i class="fas fa-folder"></i><br><small>폴더</small>
        </a>
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <a href="${pageContext.request.contextPath}/folder/my" class="text-center text-decoration-none">
                    <i class="fas fa-user"></i><br><small>MY</small>
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/users/login" class="text-center text-decoration-none">
                    <i class="far fa-user"></i><br><small>로그인</small>
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>