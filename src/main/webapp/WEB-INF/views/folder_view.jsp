<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>${folderName} - 내 폴더</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/folder_view.css" rel="stylesheet">
</head>
<body>

<!-- 헤더 -->
<div class="folder-header">
    <div class="container">
        <div class="d-flex align-items-center">
            <a href="${pageContext.request.contextPath}/folder/my" class="back-btn">
                <i class="fas fa-arrow-left"></i>
            </a>
            <div class="folder-title">
                <i class="fas fa-folder"></i>
                <h1>${folderName}</h1>
                <span class="snap-count">${list.size()}개</span>
            </div>
        </div>

        <div class="folder-actions">
            <button class="btn btn-edit" onclick="renameFolder()">
                <i class="fas fa-edit"></i> 이름 변경
            </button>
            <button class="btn btn-delete" onclick="deleteFolder()">
                <i class="fas fa-trash"></i> 폴더 삭제
            </button>
        </div>
    </div>
</div>

<!-- 스냅 그리드 -->
<c:choose>
    <c:when test="${not empty list}">
        <div class="snap-grid">
            <c:forEach items="${list}" var="snap">
                <div class="snap-card">
                    <div class="image-wrap">
                        <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}">
                            <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="${snap.snap_title}">
                        </a>
                        <button class="remove-btn" onclick="removeFromFolder(${snap.snap_id})" title="폴더에서 제거">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="card-info">
                        <div class="card-title">${snap.snap_title}</div>
                        <div class="card-meta">
                            <span>${snap.category}</span>
                            <span class="likes">
                                <i class="fas fa-heart"></i> ${snap.like_count}
                            </span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="empty-state">
            <i class="far fa-folder-open"></i>
            <h3>폴더가 비어있습니다</h3>
            <p>마음에 드는 스냅을 저장해보세요!</p>
            <a href="${pageContext.request.contextPath}/snaps/list" class="btn-explore">
                <i class="fas fa-search"></i> 스냅 둘러보기
            </a>
        </div>
    </c:otherwise>
</c:choose>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const folderId = ${param.folder_id != null ? param.folder_id : 'null'} || window.location.pathname.split('/').pop();

    // 폴더에서 스냅 제거
    function removeFromFolder(snapId) {
        if (!confirm('이 스냅을 폴더에서 제거하시겠습니까?')) return;

        fetch('${pageContext.request.contextPath}/folder/remove', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'folder_id=' + folderId + '&snap_id=' + snapId
        })
            .then(res => res.text())
            .then(result => {
                if (result === 'success') {
                    location.reload();
                } else {
                    alert('제거 실패');
                }
            });
    }

    // 폴더 이름 변경
    function renameFolder() {
        const newName = prompt('새 폴더 이름을 입력하세요:', '${folderName}');
        if (!newName || newName === '${folderName}') return;

        fetch('${pageContext.request.contextPath}/folder/rename', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'folder_id=' + folderId + '&folder_name=' + encodeURIComponent(newName)
        })
            .then(res => res.text())
            .then(result => {
                if (result === 'success') {
                    location.reload();
                } else {
                    alert('이름 변경 실패');
                }
            });
    }

    // 폴더 삭제
    function deleteFolder() {
        if (!confirm('폴더를 삭제하시겠습니까? 저장된 스냅은 삭제되지 않습니다.')) return;

        fetch('${pageContext.request.contextPath}/folder/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'folder_id=' + folderId
        })
            .then(res => res.text())
            .then(result => {
                if (result === 'success') {
                    location.href = '${pageContext.request.contextPath}/folder/my';
                } else {
                    alert('삭제 실패');
                }
            });
    }
</script>
</body>
</html>