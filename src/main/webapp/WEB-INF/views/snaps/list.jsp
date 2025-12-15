<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>SNAP - StyleSnap</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/list.css" rel="stylesheet">
</head>
<body>

<!-- 헤더 -->
<div class="container">
    <div class="header d-flex justify-content-between align-items-center">
        <a href="${pageContext.request.contextPath}/" class="logo">SNAP</a>
        <div class="icons">
            <a href="#"><i class="far fa-bell"></i></a>
            <a href="#"><i class="fas fa-search"></i></a>
            <c:choose>
                <c:when test="${not empty sessionScope.loginUser}">
                    <a href="${pageContext.request.contextPath}/folder/my"><i class="fas fa-user"></i></a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/users/login"><i class="far fa-user"></i></a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 탭 네비게이션 -->
    <div class="tab-nav">
        <a href="${pageContext.request.contextPath}/snaps/list" class="active">스냅</a>
        <a href="#">투데이</a>
        <a href="#">랭킹</a>
        <c:if test="${not empty sessionScope.loginUser}">
            <a href="${pageContext.request.contextPath}/folder/my">팔로잉</a>
        </c:if>
    </div>

    <!-- 필터 영역 -->
    <div class="filter-area">
        <button class="filter-btn" onclick="toggleFilter()">
            <i class="fas fa-sliders-h"></i>
        </button>

        <button class="filter-btn ${param.category == '상의' ? 'active' : ''}"
                onclick="location.href='?category=상의'">상의</button>
        <button class="filter-btn ${param.category == '하의' ? 'active' : ''}"
                onclick="location.href='?category=하의'">하의</button>
        <button class="filter-btn ${param.category == '아우터' ? 'active' : ''}"
                onclick="location.href='?category=아우터'">아우터</button>

        <button class="filter-btn">
            스타일 <i class="fas fa-chevron-down"></i>
        </button>
        <button class="filter-btn">
            카테고리 <i class="fas fa-chevron-down"></i>
        </button>
        <button class="filter-btn">
            색상 <i class="fas fa-chevron-down"></i>
        </button>
    </div>

    <!-- 선택된 필터 -->
    <c:if test="${not empty param.category || not empty param.style}">
        <div class="selected-filters">
            <c:if test="${not empty param.category}">
                <span class="filter-tag">
                    ${param.category}
                    <span class="remove" onclick="location.href='${pageContext.request.contextPath}/snaps/list'">&times;</span>
                </span>
            </c:if>
            <c:if test="${not empty param.style}">
                <span class="filter-tag">
                    ${param.style}
                    <span class="remove" onclick="location.href='${pageContext.request.contextPath}/snaps/list'">&times;</span>
                </span>
            </c:if>
            <a href="${pageContext.request.contextPath}/snaps/list" class="reset-btn">초기화</a>
        </div>
    </c:if>

    <!-- 결과 정보 -->
    <div class="result-info">
        <span class="count">
            <fmt:formatNumber value="${list.size()}" pattern="#,###"/>개
        </span>
        <select class="sort-select" onchange="sortSnaps(this.value)">
            <option value="latest">최신순</option>
            <option value="popular">인기순</option>
            <option value="views">조회순</option>
        </select>
    </div>
</div>

<!-- 스냅 그리드 -->
<div class="snap-grid">
    <c:forEach items="${list}" var="snap">
        <div class="snap-item">
            <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="${snap.snap_title}">
                <div class="overlay"></div>
            </a>
            <button class="heart-btn" onclick="likeSnap(${snap.snap_id}, event)">
                <i class="far fa-heart"></i>
            </button>
        </div>
    </c:forEach>
</div>

<!-- 빈 상태 -->
<c:if test="${empty list}">
    <div class="empty-state">
        <i class="far fa-image"></i>
        <p>등록된 스냅이 없습니다.</p>
        <a href="${pageContext.request.contextPath}/snaps/write" class="btn-write">
            첫 스냅 등록하기
        </a>
    </div>
</c:if>

<!-- 플로팅 버튼 (글쓰기) -->
<c:if test="${not empty sessionScope.loginUser}">
    <a href="${pageContext.request.contextPath}/snaps/write"
       style="position: fixed; bottom: 30px; right: 30px; width: 56px; height: 56px;
              background: #000; color: #fff; border-radius: 50%; display: flex;
              align-items: center; justify-content: center; font-size: 1.5rem;
              box-shadow: 0 4px 12px rgba(0,0,0,0.3); text-decoration: none;">
        <i class="fas fa-plus"></i>
    </a>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 좋아요 기능
    function likeSnap(snapId, event) {
        event.preventDefault();
        event.stopPropagation();

        <c:if test="${empty sessionScope.loginUser}">
        alert('로그인이 필요합니다.');
        location.href = '${pageContext.request.contextPath}/users/login';
        return;
        </c:if>

        const btn = event.currentTarget;
        const icon = btn.querySelector('i');

        // 하트 토글 (실제로는 AJAX로 서버에 요청)
        if (icon.classList.contains('far')) {
            icon.classList.remove('far');
            icon.classList.add('fas');
            btn.classList.add('liked');
        } else {
            icon.classList.remove('fas');
            icon.classList.add('far');
            btn.classList.remove('liked');
        }

        // 서버에 좋아요 요청
        fetch('${pageContext.request.contextPath}/snaps/like/' + snapId)
            .then(response => {
                // 처리 완료
            });
    }

    // 정렬
    function sortSnaps(sortType) {
        location.href = '${pageContext.request.contextPath}/snaps/list?sort=' + sortType;
    }

    // 필터 토글
    function toggleFilter() {
        // 필터 패널 토글 (추후 구현)
        alert('필터 기능 준비 중');
    }
</script>
</body>
</html>