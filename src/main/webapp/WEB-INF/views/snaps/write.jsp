<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>스냅 작성 - StyleZip</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/write.css" rel="stylesheet">
</head>
<body>

<form action="${pageContext.request.contextPath}/snaps/write" method="post" enctype="multipart/form-data" id="writeForm">

    <!-- 헤더 -->
    <div class="write-header">
        <div class="container">
            <a href="${pageContext.request.contextPath}/snaps/list" class="back-btn">
                <i class="fas fa-times"></i>
            </a>
            <h1>새 스냅</h1>
            <button type="submit" class="submit-btn">등록</button>
        </div>
    </div>

    <div class="write-container">

        <!-- 이미지 업로드 -->
        <div class="image-upload-section">
            <h3><i class="fas fa-camera"></i> 사진 <span class="required">*필수</span></h3>
            <div class="image-uploads">
                <!-- 코디 사진 -->
                <div class="image-upload-box" onclick="document.getElementById('coordFile').click()">
                    <input type="file" id="coordFile" name="coordFile" accept="image/*" required onchange="previewImage(this, 'coordPreview')">
                    <i class="fas fa-plus upload-icon"></i>
                    <div class="upload-text">
                        코디 사진
                        <span>전신 착용샷</span>
                    </div>
                    <img id="coordPreview" class="preview-image" style="display:none;">
                    <button type="button" class="remove-btn" onclick="removeImage(event, 'coordFile', 'coordPreview')">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- 상품 사진 -->
                <div class="image-upload-box" onclick="document.getElementById('productFile').click()">
                    <input type="file" id="productFile" name="productFile" accept="image/*" required onchange="previewImage(this, 'productPreview')">
                    <i class="fas fa-plus upload-icon"></i>
                    <div class="upload-text">
                        상품 사진
                        <span>상품 상세샷</span>
                    </div>
                    <img id="productPreview" class="preview-image" style="display:none;">
                    <button type="button" class="remove-btn" onclick="removeImage(event, 'productFile', 'productPreview')">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- 기본 정보 -->
        <div class="input-section">
            <div class="input-group">
                <label>제목 <span class="required">*</span></label>
                <input type="text" name="snap_title" placeholder="스냅 제목을 입력하세요" required>
            </div>

            <div class="input-group">
                <label>카테고리 <span class="required">*</span></label>
                <div class="select-buttons" id="categoryButtons">
                    <button type="button" class="select-btn" data-value="상의">상의</button>
                    <button type="button" class="select-btn" data-value="하의">하의</button>
                    <button type="button" class="select-btn" data-value="아우터">아우터</button>
                    <button type="button" class="select-btn" data-value="신발">신발</button>
                    <button type="button" class="select-btn" data-value="악세서리">악세서리</button>
                </div>
                <input type="hidden" name="category" id="categoryInput" required>
            </div>

            <div class="input-group">
                <label>스타일 <span class="required">*</span></label>
                <div class="select-buttons" id="styleButtons">
                    <button type="button" class="select-btn" data-value="캐주얼">캐주얼</button>
                    <button type="button" class="select-btn" data-value="스트릿">스트릿</button>
                    <button type="button" class="select-btn" data-value="미니멀">미니멀</button>
                    <button type="button" class="select-btn" data-value="빈티지">빈티지</button>
                    <button type="button" class="select-btn" data-value="스포티">스포티</button>
                    <button type="button" class="select-btn" data-value="포멀">포멀</button>
                </div>
                <input type="hidden" name="style" id="styleInput" required>
            </div>
        </div>

        <!-- 추가 정보 -->
        <div class="input-section">
            <div class="input-group">
                <label>색상</label>
                <div class="color-buttons" id="colorButtons">
                    <button type="button" class="color-btn black" data-value="블랙" title="블랙"></button>
                    <button type="button" class="color-btn white" data-value="화이트" title="화이트"></button>
                    <button type="button" class="color-btn gray" data-value="그레이" title="그레이"></button>
                    <button type="button" class="color-btn navy" data-value="네이비" title="네이비"></button>
                    <button type="button" class="color-btn blue" data-value="블루" title="블루"></button>
                    <button type="button" class="color-btn red" data-value="레드" title="레드"></button>
                    <button type="button" class="color-btn pink" data-value="핑크" title="핑크"></button>
                    <button type="button" class="color-btn purple" data-value="퍼플" title="퍼플"></button>
                    <button type="button" class="color-btn green" data-value="그린" title="그린"></button>
                    <button type="button" class="color-btn yellow" data-value="옐로우" title="옐로우"></button>
                    <button type="button" class="color-btn brown" data-value="브라운" title="브라운"></button>
                    <button type="button" class="color-btn beige" data-value="베이지" title="베이지"></button>
                </div>
                <input type="hidden" name="color" id="colorInput">
            </div>

            <div class="input-group">
                <label>가격</label>
                <div class="price-input-wrap">
                    <input type="number" name="price" placeholder="0" min="0" value="0">
                    <span class="currency">원</span>
                </div>
            </div>
        </div>

    </div>

    <!-- 하단 버튼 (모바일) -->
    <div class="bottom-submit">
        <button type="submit" class="submit-btn">등록하기</button>
    </div>

</form>

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
    function removeImage(event, inputId, previewId) {
        event.stopPropagation();
        const input = document.getElementById(inputId);
        const preview = document.getElementById(previewId);
        const box = input.closest('.image-upload-box');

        input.value = '';
        preview.src = '';
        preview.style.display = 'none';
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
    document.getElementById('writeForm').addEventListener('submit', function(e) {
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