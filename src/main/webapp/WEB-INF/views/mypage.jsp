<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>마이페이지 - StyleSnap</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/mypage.css" rel="stylesheet">
</head>
<body>

<!-- 프로필 섹션 -->
<div class="profile-section">
    <div class="profile-avatar">
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser.profile_image}">
                <img src="${pageContext.request.contextPath}${sessionScope.loginUser.profile_image}" alt="프로필">
            </c:when>
            <c:otherwise>
                <i class="fas fa-user"></i>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="profile-name">${sessionScope.loginUser.nickname}</div>
    <div class="profile-email">${sessionScope.loginUser.email}</div>

    <div class="profile-stats">
        <div class="stat">
            <span class="stat-value">${folders.size()}</span>
            <span class="stat-label">폴더</span>
        </div>
        <div class="stat">
            <span class="stat-value" id="totalSnaps">0</span>
            <span class="stat-label">저장한 스냅</span>
        </div>
        <div class="stat">
            <span class="stat-value">0</span>
            <span class="stat-label">팔로워</span>
        </div>
    </div>

    <div class="profile-actions">
        <button class="btn btn-edit" onclick="location.href='${pageContext.request.contextPath}/users/edit'">
            <i class="fas fa-edit"></i> 프로필 수정
        </button>
        <button class="btn btn-logout" onclick="location.href='${pageContext.request.contextPath}/users/logout'">
            <i class="fas fa-sign-out-alt"></i> 로그아웃
        </button>
    </div>
</div>

<!-- 탭 네비게이션 -->
<div class="tab-nav">
    <a href="#" class="tab active">
        <i class="fas fa-folder"></i>
        내 폴더
    </a>
    <a href="${pageContext.request.contextPath}/snaps/my" class="tab">
        <i class="fas fa-camera"></i>
        내 스냅
    </a>
    <a href="#" class="tab">
        <i class="fas fa-heart"></i>
        좋아요
    </a>
</div>

<!-- 섹션 헤더 -->
<div class="section-header">
    <h2><i class="fas fa-folder"></i> 내 폴더</h2>
    <button class="add-btn" onclick="openNewFolderModal()">
        <i class="fas fa-plus"></i> 새 폴더
    </button>
</div>

<!-- 폴더 그리드 -->
<c:choose>
    <c:when test="${not empty folders}">
        <div class="folder-grid">
            <c:forEach items="${folders}" var="folder">
                <a href="${pageContext.request.contextPath}/folder/view/${folder.folder_id}" class="folder-card">
                    <div class="folder-preview">
                        <!-- 폴더 미리보기 이미지 (추후 구현) -->
                        <div class="preview-item preview-empty"><i class="fas fa-image"></i></div>
                        <div class="preview-item preview-empty"><i class="fas fa-image"></i></div>
                        <div class="preview-item preview-empty"><i class="fas fa-image"></i></div>
                        <div class="preview-item preview-empty"><i class="fas fa-image"></i></div>
                    </div>
                    <div class="folder-info">
                        <div class="folder-name">
                            <i class="fas fa-folder"></i>
                                ${folder.folder_name}
                        </div>
                        <div class="folder-count">스냅 0개</div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="empty-state">
            <i class="far fa-folder-open"></i>
            <h3>아직 폴더가 없습니다</h3>
            <p>마음에 드는 스냅을 폴더에 저장해보세요!</p>
            <button class="btn-create" onclick="openNewFolderModal()">
                <i class="fas fa-plus"></i> 첫 폴더 만들기
            </button>
        </div>
    </c:otherwise>
</c:choose>

<!-- 새 폴더 모달 -->
<div class="modal-overlay" id="newFolderModal">
    <div class="modal-content">
        <h3><i class="fas fa-folder-plus"></i> 새 폴더 만들기</h3>
        <input type="text" id="newFolderName" placeholder="폴더 이름을 입력하세요">
        <div class="modal-buttons">
            <button class="btn-cancel" onclick="closeNewFolderModal()">취소</button>
            <button class="btn-create" onclick="createNewFolder()">만들기</button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 새 폴더 모달 열기
    function openNewFolderModal() {
        document.getElementById('newFolderModal').classList.add('show');
        document.getElementById('newFolderName').focus();
    }

    // 새 폴더 모달 닫기
    function closeNewFolderModal() {
        document.getElementById('newFolderModal').classList.remove('show');
        document.getElementById('newFolderName').value = '';
    }

    // 새 폴더 만들기
    function createNewFolder() {
        const name = document.getElementById('newFolderName').value.trim();
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
                    location.reload();
                } else {
                    alert('폴더 생성 실패');
                }
            });
    }

    // 모달 외부 클릭시 닫기
    document.getElementById('newFolderModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeNewFolderModal();
        }
    });

    // Enter 키로 폴더 생성
    document.getElementById('newFolderName').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            createNewFolder();
        }
    });
</script>
</body>
</html>