<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>스냅 수정 - StyleSnap</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/write.css" rel="stylesheet">
</head>
<body>

<form action="${pageContext.request.contextPath}/snaps/edit/ok" method="post" enctype="multipart/form-data" id="editForm">
    <input type="hidden" name="snap_id" value="${snap.snap_id}">
    <input type="hidden" name="coord_image" value="${snap.coord_image}" id="existingCoordImage">
    <input type="hidden" name="product_image" value="${snap.product_image}" id="existingProductImage">

    <div class="write-header">
        <div class="container">
            <a href="${pageContext.request.contextPath}/snaps/view/${snap.snap_id}" class="back-btn">
                <i class="fas fa-times"></i>
            </a>
            <h1>스냅 수정</h1>
            <button type="submit" class="submit-btn">완료</button>
        </div>
    </div>

    <div class="write-container">

        <div class="image-upload-section">
            <h3><i class="fas fa-camera"></i> 사진</h3>
            <div class="image-uploads">
                <div class="image-upload-box ${not empty snap.coord_image ? 'has-image' : ''}" onclick="document.getElementById('coordFile').click()">
                    <input type="file" id="coordFile" name="coordFile" accept="image/*" onchange="previewImage(this, 'coordPreview')">
                    <i class="fas fa-plus upload-icon" style="${not empty snap.coord_image ? 'display:none' : ''}"></i>
                    <div class="upload-text" style="${not empty snap.coord_image ? 'display:none' : ''}">
                        코디 사진
                        <span>전신 착용샷</span>
                    </div>
                    <img id="coordPreview" class="preview-image"
                         src="${not empty snap.coord_image ? pageContext.request.contextPath.concat(snap.coord_image) : ''}"
                         style="${not empty snap.coord_image ? '' : 'display:none'}">
                    <button type="button" class="remove-btn" onclick="removeImage(event, 'coordFile', 'coordPreview', 'existingCoordImage')">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <div class="image-upload-box ${not empty snap.product_image ? 'has-image' : ''}" onclick="document.getElementById('productFile').click()">
                    <input type="file" id="productFile" name="productFile" accept="image/*" onchange="previewImage(this, 'productPreview')">
                    <i class="fas fa-plus upload-icon" style="${not empty snap.product_image ? 'display:none' : ''}"></i>
                    <div class="upload-text" style="${not empty snap.product_image ? 'display:none' : ''}">
                        상품 사진
                        <span>상품 상세샷</span>
                    </div>
                    <img id="productPreview" class="preview-image"
                         src="${not empty snap.product_image ? pageContext.request.contextPath.concat(snap.product_image) : ''}"
                         style="${not empty snap.product_image ? '' : 'display:none'}">
                    <button type="button" class="remove-btn" onclick="removeImage(event, 'productFile', 'productPreview', 'existingProductImage')">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="input-section">
            <div class="input-group">
                <label>제목 <span class="required">*</span></label>
                <input type="text" name="snap_title" value="${snap.snap_title}" placeholder="스냅 제목을 입력하세요" required>
            </div>

            <div class="input-group">
                <label>카테고리 <span class="required">*</span></label>
                <div class="select-buttons" id="categoryButtons">
                    <button type="button" class="select-btn ${snap.category == '상의' ? 'active' : ''}" data-value="상의">상의</button>
                    <button type="button" class="select-btn ${snap.category == '하의' ? 'active' : ''}" data-value="하의">하의</button>
                    <button type="button" class="select-btn ${snap.category == '아우터' ? 'active' : ''}" data-value="아우터">아우터</button>
                    <button type="button" class="select-btn ${snap.category == '신발' ? 'active' : ''}" data-value="신발">신발</button>
                    <button type="button" class="select-btn ${snap.category == '악세서리' ? 'active' : ''}" data-value="악세서리">악세서리</button>
                </div>
                <input type="hidden" name="category" id="categoryInput" value="${snap.category}" required>
            </div>

            <div class="input-group">
                <label>스타일 <span class="required">*</span></label>
                <div class="select-buttons" id="styleButtons">
                    <button type="button" class="select-btn ${snap.style == '캐주얼' ? 'active' : ''}" data-value="캐주얼">캐주얼</button>
                    <button type="button" class="select-btn ${snap.style == '스트릿' ? 'active' : ''}" data-value="스트릿">스트릿</button>
                    <button type="button" class="select-btn ${snap.style == '미니멀' ? 'active' : ''}" data-value="미니멀">미니멀</button>
                    <button type="button" class="select-btn ${snap.style == '빈티지' ? 'active' : ''}" data-value="빈티지">빈티지</button>
                    <button type="button" class="select-btn ${snap.style == '스포티' ? 'active' : ''}" data-value="스포티">스포티</button>
                    <button type="button" class="select-btn ${snap.style == '포멀' ? 'active' : ''}" data-value="포멀">포멀</button>
                </div>
                <input type="hidden" name="style" id="styleInput" value="${snap.style}" required>
            </div>
        </div>

        <div class="input-section">
            <div class="input-group">
                <label>색상</label>
                <div class="color-buttons" id="colorButtons">
                    <button type="button" class="color-btn black ${snap.color == '블랙' ? 'active' : ''}" data-value="블랙" title="블랙"></button>
                    <button type="button" class="color-btn white ${snap.color == '화이트' ? 'active' : ''}" data-value="화이트" title="화이트"></button>
                    <button type="button" class="color-btn gray ${snap.color == '그레이' ? 'active' : ''}" data-value="그레이" title="그레이"></button>
                    <button type="button" class="color-btn navy ${snap.color == '네이비' ? 'active' : ''}" data-value="네이비" title="네이비"></button>
                    <button type="button" class="color-btn blue ${snap.color == '블루' ? 'active' : ''}" data-value="블루" title="블루"></button>
                    <button type="button" class="color-btn red ${snap.color == '레드' ? 'active' : ''}" data-value="레드" title="레드"></button>
                    <button type="button" class="color-btn pink ${snap.color == '핑크' ? 'active' : ''}" data-value="핑크" title="핑크"></button>
                    <button type="button" class="color-btn purple ${snap.color == '퍼플' ? 'active' : ''}" data-value="퍼플" title="퍼플"></button>
                    <button type="button" class="color-btn green ${snap.color == '그린' ? 'active' : ''}" data-value="그린" title="그린"></button>
                    <button type="button" class="color-btn yellow ${snap.color == '옐로우' ? 'active' : ''}" data-value="옐로우" title="옐로우"></button>
                    <button type="button" class="color-btn brown ${snap.color == '브라운' ? 'active' : ''}" data-value="브라운" title="브라운"></button>
                    <button type="button" class="color-btn beige ${snap.color == '베이지' ? 'active' : ''}" data-value="베이지" title="베이지"></button>
                </div>
                <input type="hidden" name="color" id="colorInput" value="${snap.color}">
            </div>

            <div class="input-group">
                <label>가격</label>
                <div class="price-input-wrap">
                    <input type="number" name="price" value="${snap.price}" placeholder="0" min="0">
                    <span class="currency">원</span>
                </div>
            </div>
        </div>

        <div class="input-section" style="text-align: center;">
            <a href="${pageContext.request.contextPath}/snaps/delete/${snap.snap_id}"
               class="delete-link" onclick="return confirm('정말 삭제하시겠습니까?');">
                <i class="fas fa-trash"></i> 이 스냅 삭제하기
            </a>
        </div>

    </div>

    <div class="bottom-submit">
        <button type="submit" class="submit-btn">수정 완료</button>
    </div>

</form>

<style>
    .delete-link {
        color: #ff6b6b;
        text-decoration: none;
        font-size: 0.9rem;
    }
    .delete-link:hover {
        text-decoration: underline;
    }
</style>

<script>
    // 이미지 미리보기
    function previewImage(input, previewId) {
        const preview = document.getElementById(previewId);
        const box = input.closest('.image-upload-box');

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
                box.classList.add('has-image');
                box.querySelector('.upload-icon').style.display = 'none';
                box.querySelector('.upload-text').style.display = 'none';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 이미지 제거
    function removeImage(event, inputId, previewId, existingInputId) {
        event.stopPropagation();
        const input = document.getElementById(inputId);
        const preview = document.getElementById(previewId);
        const existingInput = document.getElementById(existingInputId);
        const box = input.closest('.image-upload-box');

        input.value = '';
        preview.src = '';
        preview.style.display = 'none';
        existingInput.value = '';  // 기존 이미지 경로도 삭제
        box.classList.remove('has-image');
        box.querySelector('.upload-icon').style.display = 'block';
        box.querySelector('.upload-text').style.display = 'block';
    }

    // 카테고리 선택
    document.querySelectorAll('#categoryButtons .select-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('#categoryButtons .select-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            document.getElementById('categoryInput').value = this.dataset.value;
        });
    });

    // 스타일 선택
    document.querySelectorAll('#styleButtons .select-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('#styleButtons .select-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            document.getElementById('styleInput').value = this.dataset.value;
        });
    });

    // 색상 선택
    document.querySelectorAll('#colorButtons .color-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('#colorButtons .color-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            document.getElementById('colorInput').value = this.dataset.value;
        });
    });

    // 폼 유효성 검사
    document.getElementById('editForm').addEventListener('submit', function(e) {
        const category = document.getElementById('categoryInput').value;
        const style = document.getElementById('styleInput').value;

        if (!category) {
            e.preventDefault();
            alert('카테고리를 선택해주세요.');
            return;
        }

        if (!style) {
            e.preventDefault();
            alert('스타일을 선택해주세요.');
            return;
        }
    });
</script>
</body>
</html>