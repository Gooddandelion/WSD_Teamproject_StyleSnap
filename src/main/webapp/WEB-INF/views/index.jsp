<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>stylezip</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/index.css" rel="stylesheet">
</head>
<body>

<!-- 헤더 -->
<nav class="navbar navbar-light bg-white sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">stylezip</a>
        <div>
            <a href="${pageContext.request.contextPath}/snaps/list" class="btn btn-link text-dark"><i class="fas fa-search"></i></a>
            <c:choose>
                <c:when test="${not empty sessionScope.loginUser}">
                    <a href="${pageContext.request.contextPath}/folder/my" class="btn btn-link text-dark"><i class="fas fa-user"></i></a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/users/login" class="btn btn-link text-dark"><i class="far fa-user"></i></a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<div class="container mt-3">

    <!-- ========== 섹션 1: AI 맥락 인식 추천 ========== -->
    <div class="card-section">
        <div class="section-header">
            <h5>AI 맥락 인식 추천</h5>
            <a href="#">더보기 <i class="fas fa-chevron-right"></i></a>
        </div>

        <div class="row">
            <div class="col-4">
                <div class="ai-box">
                    <h6>오늘의 방문지:</h6>
                    <h4>서울숲</h4>
                    <h6>상황 최적화 코디:</h6>
                    <h4>캐주얼 데이트룩</h4>
                </div>
            </div>
            <div class="col-8">
                <div class="row g-2">
                    <c:forEach items="${recentSnaps}" var="snap" end="2">
                        <div class="col-4">
                            <div class="snap-card">
                                <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                                    <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="${snap.snap_title}">
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty recentSnaps}">
                        <div class="col-12 empty-state">추후 구현 예정</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== 섹션 2: 폴더 + 커뮤니티 융합 ========== -->
    <div class="card-section">
        <h5 class="mb-3">폴더 + 커뮤니티 융합</h5>

        <div class="row">
            <!-- MY 폴더 -->
            <div class="col-md-6 two-col-left">
                <div class="section-header">
                    <h6>MY 폴더</h6>
                    <a href="${pageContext.request.contextPath}/folder/my">더보기 <i class="fas fa-chevron-right"></i></a>
                </div>

                <c:choose>
                    <c:when test="${not empty sessionScope.loginUser}">
                        <div class="row g-2">
                            <c:forEach items="${recentSnaps}" var="snap" end="3">
                                <div class="col-6">
                                    <div class="snap-card">
                                        <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="">
                                        <button class="heart-btn"><i class="far fa-heart"></i></button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-folder-open fa-3x mb-3"></i>
                            <p><a href="${pageContext.request.contextPath}/users/login">로그인</a>하고 내 폴더를 확인하세요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 커뮤니티 트렌드 -->
            <div class="col-md-6 two-col-right">
                <div class="section-header">
                    <h6>커뮤니티 트렌드</h6>
                    <a href="${pageContext.request.contextPath}/snaps/list">더보기 <i class="fas fa-chevron-right"></i></a>
                </div>

                <div class="row">
                    <div class="col-6">
                        <c:forEach items="${popularSnaps}" var="snap" end="1">
                            <div class="snap-card mb-2">
                                <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                                    <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="">
                                </a>
                                <button class="heart-btn"><i class="far fa-heart"></i></button>
                            </div>
                            <p class="small mb-0">${snap.snap_title}</p>
                            <p class="fw-bold">${snap.price}원</p>
                        </c:forEach>
                    </div>

                    <div class="col-6">
                        <c:forEach items="${popularSnaps}" var="snap" end="3">
                            <div class="trend-item">
                                <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="">
                                <div class="info">
                                    <div class="title">${snap.snap_title}</div>
                                    <div class="sub">❤️ ${snap.like_count}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== 섹션 3: 스마트 쇼핑 ========== -->
    <div class="card-section">
        <h5 class="mb-2">스마트 쇼핑</h5>
        <p class="text-muted small">AI 유사 스타일 할인 상품</p>

        <div class="row g-3">
            <c:forEach items="${recentSnaps}" var="snap" end="5">
                <div class="col-4 col-md-2">
                    <div class="shop-card">
                        <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="">
                        <p class="title">${snap.style} 상품</p>
                        <p class="price">${snap.price}원 <span class="discount">10%</span></p>
                        <button class="btn-buy">구매하기</button>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty recentSnaps}">
                <div class="col-12 empty-state">추후 구현 예정</div>
            </c:if>
        </div>
    </div>

    <!-- ========== 섹션 4: 최신 스냅 ========== -->
    <div class="card-section">
        <div class="section-header">
            <h5>최신 스냅</h5>
            <a href="${pageContext.request.contextPath}/snaps/list">더보기 <i class="fas fa-chevron-right"></i></a>
        </div>

        <div class="row g-3">
            <c:forEach items="${recentSnaps}" var="snap">
                <div class="col-6 col-md-4">
                    <div class="snap-card">
                        <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                            <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="${snap.snap_title}">
                        </a>
                        <button class="heart-btn"><i class="far fa-heart"></i></button>
                    </div>
                    <p class="fw-bold mt-2 mb-0">${snap.snap_title}</p>
                    <p class="small text-muted mb-0">${snap.category} | ${snap.style}</p>
                    <p class="small">❤️ ${snap.like_count} &nbsp; 👁️ ${snap.view_count}</p>
                </div>
            </c:forEach>

            <c:if test="${empty recentSnaps}">
                <div class="col-12 empty-state">
                    <i class="fas fa-camera fa-3x mb-3"></i>
                    <p>등록된 스냅이 없습니다.<br><a href="${pageContext.request.contextPath}/snaps/write">첫 스냅을 등록해보세요!</a></p>
                </div>
            </c:if>
        </div>
    </div>

</div>

<!-- 하단 네비게이션 (모바일용) -->
<nav class="navbar fixed-bottom navbar-light bg-white border-top d-md-none">
    <div class="container justify-content-around">
        <a href="${pageContext.request.contextPath}/" class="text-center text-dark text-decoration-none">
            <i class="fas fa-home"></i><br><small>홈</small>
        </a>
        <a href="${pageContext.request.contextPath}/snaps/list" class="text-center text-dark text-decoration-none">
            <i class="fas fa-search"></i><br><small>검색</small>
        </a>
        <a href="${pageContext.request.contextPath}/snaps/write" class="text-center text-dark text-decoration-none">
            <i class="fas fa-plus-square"></i><br><small>등록</small>
        </a>
        <a href="${pageContext.request.contextPath}/folder/my" class="text-center text-dark text-decoration-none">
            <i class="fas fa-folder"></i><br><small>보관함</small>
        </a>
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <a href="${pageContext.request.contextPath}/users/logout" class="text-center text-dark text-decoration-none">
                    <i class="fas fa-user"></i><br><small>로그아웃</small>
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/users/login" class="text-center text-dark text-decoration-none">
                    <i class="far fa-user"></i><br><small>로그인</small>
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>