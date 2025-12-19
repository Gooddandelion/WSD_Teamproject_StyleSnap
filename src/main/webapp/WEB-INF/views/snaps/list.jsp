<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>SNAP - stylezip</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/list.css" rel="stylesheet">
</head>
<body>

<div class="container">
    <div class="header d-flex justify-content-between align-items-center">
        <a href="${pageContext.request.contextPath}/" class="logo">SNAP</a>
        <div class="icons">

            <a href="${pageContext.request.contextPath}/chat/" title="AI 코디 추천" style="margin-left: 10px; margin-right: 5px; color: #333;">
                <i class="fas fa-robot"></i>
            </a>

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

    <div id="searchBar" style="display: none; padding: 10px 0; border-bottom: 1px solid #eee; background: #fff;">
        <form action="${pageContext.request.contextPath}/snaps/list" method="get" class="d-flex gap-2">
            <input type="text" name="keyword" class="form-control" placeholder="제목, 스타일, 카테고리 검색..." value="${param.keyword}">
            <button type="submit" class="btn btn-dark">검색</button>
        </form>
    </div>

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

        <div class="d-inline-block dropdown">
            <button class="filter-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                ${not empty param.style ? param.style : '스타일'}
            </button>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="javascript:applyFilter('style', '')">전체</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('style', '캐주얼')">캐주얼</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('style', '스트릿')">스트릿</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('style', '미니멀')">미니멀</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('style', '빈티지')">빈티지</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('style', '스포티')">스포티</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('style', '포멀')">포멀</a></li>
            </ul>
        </div>

        <div class="d-inline-block dropdown">
            <button class="filter-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                ${not empty param.category ? param.category : '카테고리'}
            </button>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="javascript:applyFilter('category', '')">전체</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('category', '상의')">상의</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('category', '하의')">하의</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('category', '아우터')">아우터</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('category', '신발')">신발</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('category', '악세서리')">악세서리</a></li>
            </ul>
        </div>

        <div class="d-inline-block dropdown">
            <button class="filter-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                ${not empty param.color ? param.color : '색상'}
            </button>
            <ul class="dropdown-menu" style="max-height: 300px; overflow-y: auto;">
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '')">전체</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '블랙')">블랙</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '화이트')">화이트</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '그레이')">그레이</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '네이비')">네이비</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '블루')">블루</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '레드')">레드</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '핑크')">핑크</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '그린')">그린</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '옐로우')">옐로우</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '베이지')">베이지</a></li>
                <li><a class="dropdown-item" href="javascript:applyFilter('color', '브라운')">브라운</a></li>
            </ul>
        </div>
    </div>

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

<c:if test="${empty list}">
    <div class="empty-state">
        <i class="far fa-image"></i>
        <p>등록된 스냅이 없습니다.</p>
        <a href="${pageContext.request.contextPath}/snaps/write" class="btn-write">
            첫 스냅 등록하기
        </a>
    </div>
</c:if>

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

    // 검색창 토글 함수
    function toggleSearchBar() {
        const searchBar = document.getElementById('searchBar');
        if (searchBar.style.display === 'none') {
            searchBar.style.display = 'block';
            searchBar.querySelector('input').focus();
        } else {
            searchBar.style.display = 'none';
        }
    }
    function applyFilter(key, value) {
        const urlParams = new URLSearchParams(window.location.search);

        if (value) {
            urlParams.set(key, value); // 값 설정 또는 변경
        } else {
            urlParams.delete(key); // 값이 없으면(전체) 파라미터 삭제
        }

        // 페이지 이동
        location.href = window.location.pathname + '?' + urlParams.toString();
    }
</script>
</body>
</html>