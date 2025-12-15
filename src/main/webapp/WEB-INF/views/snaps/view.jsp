<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${snap.snap_title} - 스냅 상세</title>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container">
    <h1>${snap.snap_title}</h1>

    <div class="images">
        <div>
            <h3>코디 사진</h3>
            <img src="${pageContext.request.contextPath}${snap.coord_image}" alt="코디 사진" width="300">
        </div>
        <div>
            <h3>상품 사진</h3>
            <img src="${pageContext.request.contextPath}${snap.product_image}" alt="상품 사진" width="300">
        </div>
    </div>

    <div class="info">
        <p><span>카테고리:</span> ${snap.category}</p>
        <p><span>스타일:</span> ${snap.style}</p>
        <p><span>색상:</span> ${snap.color}</p>
        <p><span>가격:</span> ${snap.price}원</p>
        <p><span>조회수:</span> ${snap.view_count}</p>

        <div class="stats">
            <a href="${pageContext.request.contextPath}/snaps/like/${snap.snap_id}">
                ❤️ 좋아요 ${snap.like_count}
            </a>
            <button type="button" onclick="openSaveModal()">📥 저장</button>
        </div>
    </div>

    <div class="buttons">
        <!-- 본인 글일 때만 수정/삭제 표시 -->
        <c:if test="${sessionScope.loginUser.user_id == snap.user_id}">
            <a href="${pageContext.request.contextPath}/snaps/edit/${snap.snap_id}">수정</a>
            <a href="${pageContext.request.contextPath}/snaps/delete/${snap.snap_id}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/snaps/list">목록으로</a>
    </div>

    <!-- 로그인한 사용자만 저장 모달 표시 -->
    <c:if test="${not empty sessionScope.loginUser}">
        <div id="saveModal" style="display:none; border: 1px solid black; padding: 20px; margin-top: 20px;">
            <h3>📂 폴더 선택</h3>
            <ul id="folderList"></ul>
            <hr/>
            <div id="newFolderArea">
                <input type="text" id="newFolderName" placeholder="새 폴더 이름">
                <button onclick="createNewFolder()">폴더 만들기</button>
            </div>
            <br/>
            <button onclick="closeSaveModal()">닫기</button>
        </div>
    </c:if>
</div>

<script>
    const snapId = ${snap.snap_id};

    function openSaveModal() {
        <c:if test="${empty sessionScope.loginUser}">
        alert('로그인이 필요합니다.');
        location.href = '${pageContext.request.contextPath}/users/login';
        return;
        </c:if>

        document.getElementById('saveModal').style.display = 'block';
        fetch('${pageContext.request.contextPath}/folder/list')
            .then(res => res.json())
            .then(data => {
                const list = document.getElementById('folderList');
                list.innerHTML = '';
                data.forEach(folder => {
                    list.innerHTML += '<li style="cursor:pointer; color:blue;" onclick="saveToFolder(' + folder.folder_id + ')">📁 ' + folder.folder_name + '</li>';
                });
            });
    }

    function closeSaveModal() {
        document.getElementById('saveModal').style.display = 'none';
    }

    function createNewFolder() {
        const name = document.getElementById('newFolderName').value;
        if(!name) return alert("폴더 이름을 입력하세요");

        fetch('${pageContext.request.contextPath}/folder/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'folder_name=' + encodeURIComponent(name)
        }).then(res => res.text())
            .then(result => {
                if(result === 'success') {
                    alert("폴더가 생성되었습니다.");
                    document.getElementById('newFolderName').value = '';
                    openSaveModal();
                } else {
                    alert("폴더 생성 실패");
                }
            });
    }

    function saveToFolder(folderId) {
        fetch('${pageContext.request.contextPath}/folder/save', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'folder_id=' + folderId + '&snap_id=' + snapId
        }).then(res => res.text())
            .then(result => {
                if(result === 'success') {
                    alert("저장되었습니다! ✅");
                    closeSaveModal();
                } else if(result === 'duplicate') {
                    alert("이미 저장된 스냅입니다.");
                } else {
                    alert("저장 실패");
                }
            });
    }
</script>
</body>
</html>