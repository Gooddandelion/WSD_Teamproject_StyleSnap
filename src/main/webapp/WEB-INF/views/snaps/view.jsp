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

        <div class="stats">
            <a href="${pageContext.request.contextPath}/snaps/like/${snap.snap_id}">
                ❤️ 좋아요 ${snap.like_count}
            </a>

            <button type="button" onclick="openSaveModal()">📥 저장</button>
        </div>
    </div>

    <div class="buttons">
        <a href="${pageContext.request.contextPath}/snaps/edit/${snap.snap_id}">수정</a>
        <a href="${pageContext.request.contextPath}/snaps/delete/${snap.snap_id}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        <a href="${pageContext.request.contextPath}/snaps/list">목록으로</a>
    </div>

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

</div>

<script>
    const snapId = ${snap.snap_id}; // 현재 글 ID

    // 1. 저장 팝업 열기 & 목록 가져오기
    function openSaveModal() {
        document.getElementById('saveModal').style.display = 'block';

        fetch('${pageContext.request.contextPath}/folder/list')
            .then(res => res.json())
            .then(data => {
                const list = document.getElementById('folderList');
                list.innerHTML = ''; // 목록 초기화
                data.forEach(folder => {
                    // 각 폴더를 클릭하면 바로 저장되도록 설정
                    list.innerHTML += '<li style="cursor:pointer; color:blue;" onclick="saveToFolder(' + folder.folder_id + ')">📁 ' + folder.folder_name + '</li>';
                });
            });
    }

    // 2. 팝업 닫기
    function closeSaveModal() {
        document.getElementById('saveModal').style.display = 'none';
    }

    // 3. 새 폴더 만들기
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

                    // [중요] 여기서 다시 목록을 불러와야 함!
                    // 팝업을 닫았다가 다시 열거나, 리스트 갱신 함수를 직접 호출
                    openSaveModal();
                } else {
                    alert("폴더 생성 실패");
                }
            });
    }

    // 4. 폴더에 저장하기
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
                } else {
                    alert("저장 실패");
                }
            });
    }
</script>
</body>
</html>