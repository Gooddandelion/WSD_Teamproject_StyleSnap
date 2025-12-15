<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>${snap.snap_title} - StyleSnap</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/view.css" rel="stylesheet">
</head>
<body>

<!-- 헤더 -->
<div class="container">
    <div class="view-header d-flex justify-content-between align-items-center">
        <a href="${pageContext.request.contextPath}/snaps/list" class="back-btn">
            <i class="fas fa-arrow-left"></i>
        </a>
        <div class="header-icons">
            <a href="#"><i class="fas fa-share-alt"></i></a>
            <a href="#"><i class="fas fa-ellipsis-h"></i></a>
        </div>
    </div>
</div>

<div class="view-container">
    <!-- 이미지 섹션 -->
    <div class="image-section">
        <div class="main-image" id="mainImage">
            <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="${snap.snap_title}" id="mainImg">
        </div>
        <div class="d-flex flex-column gap-2">
            <div class="sub-image active" onclick="changeImage('${pageContext.request.contextPath}${snap.coord_image}', this)">
                <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="코디 사진">
            </div>
            <c:if test="${not empty snap.product_image}">
                <div class="sub-image" onclick="changeImage('${pageContext.request.contextPath}${snap.product_image}', this)">
                    <img src="${pageContext.request.contextPath}${snap.product_image}" alt="상품 사진">
                </div>
            </c:if>
        </div>
    </div>

    <!-- 유저 정보 -->
    <div class="user-info">
        <div class="avatar">
            <i class="fas fa-user" style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; color:#999;"></i>
        </div>
        <div>
            <div class="name">유저 ${snap.user_id}</div>
            <div class="date">${snap.created_at}</div>
        </div>
        <c:if test="${sessionScope.loginUser.user_id != snap.user_id}">
            <button class="follow-btn">팔로우</button>
        </c:if>
    </div>

    <!-- 스냅 정보 -->
    <div class="snap-info">
        <h1 class="title">${snap.snap_title}</h1>
        <div class="tags">
            <span class="tag">${snap.category}</span>
            <span class="tag">${snap.style}</span>
            <c:if test="${not empty snap.color}">
                <span class="tag">${snap.color}</span>
            </c:if>
        </div>
        <div class="price">
            <fmt:formatNumber value="${snap.price}" pattern="#,###"/>원
        </div>
    </div>

    <!-- 통계 -->
    <div class="stats">
        <span><i class="far fa-eye"></i> ${snap.view_count}</span>
        <span><i class="far fa-heart"></i> ${snap.like_count}</span>
    </div>

    <!-- 액션 버튼 -->
    <div class="action-buttons">
        <button class="action-btn like-btn" onclick="likeSnap(${snap.snap_id})">
            <i class="far fa-heart"></i>
            <span>좋아요 ${snap.like_count}</span>
        </button>
        <button class="action-btn save-btn" onclick="openSaveModal()">
            <i class="far fa-bookmark"></i>
            <span>저장하기</span>
        </button>
    </div>

    <!-- 상세 정보 -->
    <div class="detail-table">
        <div class="row">
            <div class="label">카테고리</div>
            <div class="value">${snap.category}</div>
        </div>
        <div class="row">
            <div class="label">스타일</div>
            <div class="value">${snap.style}</div>
        </div>
        <div class="row">
            <div class="label">색상</div>
            <div class="value">${snap.color}</div>
        </div>
        <div class="row">
            <div class="label">가격</div>
            <div class="value"><fmt:formatNumber value="${snap.price}" pattern="#,###"/>원</div>
        </div>
    </div>

    <!-- 관리 버튼 (본인 글일 때만) -->
    <c:if test="${sessionScope.loginUser.user_id == snap.user_id}">
        <div class="manage-buttons">
            <a href="${pageContext.request.contextPath}/snaps/edit/${snap.snap_id}" class="manage-btn">
                <i class="fas fa-edit"></i> 수정
            </a>
            <a href="${pageContext.request.contextPath}/snaps/delete/${snap.snap_id}"
               class="manage-btn delete" onclick="return confirm('정말 삭제하시겠습니까?');">
                <i class="fas fa-trash"></i> 삭제
            </a>
        </div>
    </c:if>
</div>

<!-- 저장 모달 -->
<div class="modal-overlay" id="saveModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-folder"></i> 폴더에 저장</h3>
            <button class="close-btn" onclick="closeSaveModal()">&times;</button>
        </div>
        <div class="modal-body">
            <ul class="folder-list" id="folderList">
                <!-- 폴더 목록이 여기에 로드됨 -->
            </ul>
            <div class="new-folder-input">
                <input type="text" id="newFolderName" placeholder="새 폴더 이름">
                <button onclick="createNewFolder()">만들기</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const snapId = ${snap.snap_id};

    // 이미지 변경
    function changeImage(src, el) {
        document.getElementById('mainImg').src = src;
        document.querySelectorAll('.sub-image').forEach(item => item.classList.remove('active'));
        el.classList.add('active');
    }

    // 좋아요
    function likeSnap(id) {
        <c:if test="${empty sessionScope.loginUser}">
        alert('로그인이 필요합니다.');
        location.href = '${pageContext.request.contextPath}/users/login';
        return;
        </c:if>

        const btn = document.querySelector('.like-btn');
        const icon = btn.querySelector('i');

        if (icon.classList.contains('far')) {
            icon.classList.remove('far');
            icon.classList.add('fas');
            btn.classList.add('liked');
        }

        fetch('${pageContext.request.contextPath}/snaps/like/' + id)
            .then(() => location.reload());
    }

    // 저장 모달 열기
    function openSaveModal() {
        <c:if test="${empty sessionScope.loginUser}">
        alert('로그인이 필요합니다.');
        location.href = '${pageContext.request.contextPath}/users/login';
        return;
        </c:if>

        document.getElementById('saveModal').classList.add('show');
        loadFolders();
    }

    // 저장 모달 닫기
    function closeSaveModal() {
        document.getElementById('saveModal').classList.remove('show');
    }

    // 폴더 목록 로드
    function loadFolders() {
        fetch('${pageContext.request.contextPath}/folder/list')
            .then(res => res.json())
            .then(data => {
                const list = document.getElementById('folderList');
                list.innerHTML = '';
                if (data && data.length > 0) {
                    data.forEach(folder => {
                        list.innerHTML += '<li onclick="saveToFolder(' + folder.folder_id + ')"><i class="fas fa-folder"></i> ' + folder.folder_name + '</li>';
                    });
                } else {
                    list.innerHTML = '<li style="color:#999; cursor:default;">폴더가 없습니다. 새 폴더를 만들어주세요.</li>';
                }
            });
    }

    // 새 폴더 만들기
    function createNewFolder() {
        const name = document.getElementById('newFolderName').value;
        if (!name) {
            alert('폴더 이름을 입력하세요');
            return;
        }

        fetch('${pageContext.request.contextPath}/folder/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'folder_name=' + encodeURIComponent(name)
        })
            .then(res => res.text())
            .then(result => {
                if (result === 'success') {
                    alert('폴더가 생성되었습니다.');
                    document.getElementById('newFolderName').value = '';
                    loadFolders();
                } else {
                    alert('폴더 생성 실패');
                }
            });
    }

    // 폴더에 저장
    function saveToFolder(folderId) {
        fetch('${pageContext.request.contextPath}/folder/save', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'folder_id=' + folderId + '&snap_id=' + snapId
        })
            .then(res => res.text())
            .then(result => {
                if (result === 'success') {
                    alert('저장되었습니다! ✅');
                    closeSaveModal();
                } else if (result === 'duplicate') {
                    alert('이미 저장된 스냅입니다.');
                } else {
                    alert('저장 실패');
                }
            });
    }

    // 모달 외부 클릭시 닫기
    document.getElementById('saveModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeSaveModal();
        }
    });
</script>
</body>
</html>