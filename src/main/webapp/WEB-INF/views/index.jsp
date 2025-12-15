<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>StyleSnap</title>
</head>
<body>

<!-- 헤더 -->
<div class="header">
    <h1>StyleSnap</h1>
    <div>
        <a href="${pageContext.request.contextPath}/snaps/list">🔍</a>
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <a href="${pageContext.request.contextPath}/folder/my">👤</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/users/login">👤</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<hr/>

<!-- ========== 섹션 1: AI 맥락 인식 추천 (추후 구현) ========== -->
<div class="section">
    <div class="section-header">
        <h2>AI 맥락 인식 추천</h2>
        <a href="#">더보기 ></a>
    </div>

    <div class="ai-recommend">
        <div class="ai-info">
            <p>오늘의 방문지:</p>
            <h3><!-- 추후 구현 --></h3>
            <p>상황 최적화 코디:</p>
            <h3><!-- 추후 구현 --></h3>
        </div>
        <div class="ai-snaps">
            <!-- 추후 AI 추천 스냅 표시 -->
            <p>추후 구현 예정</p>
        </div>
    </div>
</div>

<hr/>

<!-- ========== 섹션 2: 폴더 + 커뮤니티 융합 ========== -->
<div class="section">
    <h2>폴더 + 커뮤니티 융합</h2>

    <div class="two-column">
        <!-- MY 폴더 -->
        <div class="my-folder">
            <div class="section-header">
                <h3>MY 폴더</h3>
                <a href="${pageContext.request.contextPath}/folder/my">더보기 ></a>
            </div>

            <c:choose>
                <c:when test="${not empty sessionScope.loginUser}">
                    <div class="folder-preview">
                        <!-- 내 폴더의 스냅 미리보기 (추후 구현) -->
                        <p>로그인 완료 - 폴더 미리보기 추후 구현</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <p><a href="${pageContext.request.contextPath}/users/login">로그인</a>하고 내 폴더를 확인하세요!</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 커뮤니티 트렌드 -->
        <div class="community-trend">
            <div class="section-header">
                <h3>커뮤니티 트렌드</h3>
                <a href="${pageContext.request.contextPath}/snaps/list">더보기 ></a>
            </div>

            <div class="trend-snaps">
                <!-- 인기 스냅 (좋아요 순) -->
                <c:forEach items="${popularSnaps}" var="snap" end="3">
                    <div class="snap-card">
                        <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                            <img src="${pageContext.request.contextPath}${snap.coord_image}" width="100">
                        </a>
                        <p>${snap.snap_title}</p>
                        <p>${snap.price}원</p>
                    </div>
                </c:forEach>

                <c:if test="${empty popularSnaps}">
                    <p>인기 스냅이 없습니다.</p>
                </c:if>
            </div>
        </div>
    </div>
</div>

<hr/>

<!-- ========== 섹션 3: 스마트 쇼핑 (추후 구현) ========== -->
<div class="section">
    <h2>스마트 쇼핑</h2>

    <div class="section-header">
        <h3>AI 유사 스타일 할인 상품</h3>
    </div>

    <div class="shopping-list">
        <!-- 추후 외부 API 연동 또는 상품 DB 구현 -->
        <p>추후 구현 예정</p>
    </div>
</div>

<hr/>

<!-- ========== 섹션 4: 최신 스냅 (현재 구현됨) ========== -->
<div class="section">
    <div class="section-header">
        <h2>최신 스냅</h2>
        <a href="${pageContext.request.contextPath}/snaps/list">더보기 ></a>
    </div>

    <div class="snap-list">
        <c:forEach items="${recentSnaps}" var="snap" end="5">
            <div class="snap-card">
                <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                    <img src="${pageContext.request.contextPath}${snap.coord_image}" width="150" height="200">
                </a>
                <p><b>${snap.snap_title}</b></p>
                <p>${snap.category} | ${snap.style}</p>
                <p>❤️ ${snap.like_count} | 👁️ ${snap.view_count}</p>
            </div>
        </c:forEach>

        <c:if test="${empty recentSnaps}">
            <p>등록된 스냅이 없습니다. <a href="${pageContext.request.contextPath}/snaps/write">첫 스냅을 등록해보세요!</a></p>
        </c:if>
    </div>
</div>

</body>
</html>