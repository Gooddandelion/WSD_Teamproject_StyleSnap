<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>프로필 수정 - StyleSnap</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/auth.css" rel="stylesheet">
    <style>
        /* 프로필 사진 미리보기 스타일 추가 */
        .profile-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: #eee;
            margin: 0 auto 20px;
            overflow: hidden;
            position: relative;
            border: 2px solid #ddd;
            cursor: pointer;
        }
        .profile-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .profile-preview:hover::after {
            content: '📸 변경';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="auth-container">
    <div class="auth-logo">
        <h1>프로필 수정</h1>
    </div>

    <div class="auth-card">
        <form action="${pageContext.request.contextPath}/users/edit" method="post" enctype="multipart/form-data">

            <div class="profile-preview" onclick="document.getElementById('fileInput').click()">
                <c:choose>
                    <c:when test="${not empty sessionScope.loginUser.profile_image}">
                        <img id="preview" src="${pageContext.request.contextPath}${sessionScope.loginUser.profile_image}">
                    </c:when>
                    <c:otherwise>
                        <img id="preview" src="https://via.placeholder.com/150?text=User" style="opacity: 0.5">
                    </c:otherwise>
                </c:choose>
            </div>
            <input type="file" name="file" id="fileInput" style="display: none;" accept="image/*" onchange="readURL(this);">

            <div class="input-group">
                <label>닉네임</label>
                <div class="input-wrap">
                    <i class="fas fa-user"></i>
                    <input type="text" name="nickname" value="${sessionScope.loginUser.nickname}" required>
                </div>
            </div>

            <div class="input-group">
                <label>이메일</label>
                <div class="input-wrap">
                    <i class="fas fa-envelope"></i>
                    <input type="text" value="${sessionScope.loginUser.email}" disabled style="background: #f9f9f9; color: #999;">
                </div>
            </div>

            <button type="submit" class="submit-btn">수정 완료</button>
            <a href="${pageContext.request.contextPath}/folder/my" class="btn btn-outline-secondary w-100 mt-2" style="border-radius:10px; padding:12px;">취소</a>
        </form>
    </div>
</div>

<script>
    // 이미지 미리보기 스크립트
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('preview').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>

</body>
</html>