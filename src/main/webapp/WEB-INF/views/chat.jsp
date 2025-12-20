<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>AI 스타일 추천 - StyleZip</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* 채팅 전용 스타일 */
        body { background-color: #f5f5f5; font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif; }
        .chat-container { max-width: 600px; margin: 0 auto; height: 100vh; display: flex; flex-direction: column; background: white; box-shadow: 0 0 20px rgba(0,0,0,0.1); }

        .chat-header { padding: 15px 20px; border-bottom: 1px solid #eee; display: flex; align-items: center; justify-content: space-between; background: white; z-index: 10; }
        .chat-header h2 { font-size: 1.2rem; margin: 0; font-weight: 700; }
        .back-btn { color: #333; font-size: 1.2rem; }

        .chat-messages { flex: 1; overflow-y: auto; padding: 20px; background: #fafafa; }
        .message { margin-bottom: 20px; max-width: 85%; }
        .message.user { margin-left: auto; text-align: right; }
        .message.ai { margin-right: auto; }

        .bubble { padding: 12px 18px; border-radius: 15px; display: inline-block; font-size: 0.95rem; line-height: 1.5; position: relative; }
        .message.user .bubble { background: #000; color: #fff; border-bottom-right-radius: 5px; }
        .message.ai .bubble { background: #fff; color: #333; border: 1px solid #ddd; border-bottom-left-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }

        .chat-input-area { padding: 15px; background: white; border-top: 1px solid #eee; display: flex; gap: 10px; }
        .chat-input { flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 25px; outline: none; background: #f9f9f9; }
        .chat-input:focus { border-color: #000; background: #fff; }
        .send-btn { width: 50px; height: 50px; border-radius: 50%; background: #000; color: white; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: 0.2s; }
        .send-btn:hover { background: #333; }
        .send-btn:disabled { background: #ccc; }

        /* 추천 스냅 카드 스타일 */
        .recommend-grid { display: flex; gap: 10px; margin-top: 10px; overflow-x: auto; padding-bottom: 5px; }
        .snap-card { min-width: 140px; width: 140px; border: 1px solid #eee; border-radius: 10px; overflow: hidden; background: white; cursor: pointer; transition: transform 0.2s; }
        .snap-card:hover { transform: translateY(-3px); }
        .snap-img { width: 100%; height: 180px; object-fit: cover; }
        .snap-info { padding: 8px; font-size: 0.8rem; }
        .snap-title { font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .snap-meta { color: #888; font-size: 0.75rem; display: flex; justify-content: space-between; margin-top: 3px; }

        /* 로딩 애니메이션 */
        .typing-indicator { display: flex; gap: 5px; padding: 10px 15px; background: #fff; border-radius: 15px; width: fit-content; border: 1px solid #eee; }
        .dot { width: 8px; height: 8px; background: #ccc; border-radius: 50%; animation: bounce 1.4s infinite ease-in-out both; }
        .dot:nth-child(1) { animation-delay: -0.32s; }
        .dot:nth-child(2) { animation-delay: -0.16s; }
        @keyframes bounce { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1); } }
    </style>
</head>
<body>

<div class="chat-container">
    <div class="chat-header">
        <a href="${pageContext.request.contextPath}/snaps/list" class="back-btn"><i class="fas fa-arrow-left"></i></a>
        <h2>AI 스타일 추천</h2>
        <div style="width: 24px;"></div> </div>

    <div class="chat-messages" id="chatBox">
        <div class="message ai">
            <div class="bubble">
                안녕하세요! 👋<br>
                날씨, 장소, 그리고 가지고 계신 옷을 알려주시면<br>
                딱 맞는 코디를 추천해 드릴게요!
            </div>
        </div>
    </div>

    <div id="loading" style="display: none; padding: 0 20px 20px;">
        <div class="typing-indicator">
            <div class="dot"></div><div class="dot"></div><div class="dot"></div>
        </div>
    </div>

    <div class="chat-input-area">
        <input type="text" id="userInput" class="chat-input" placeholder="예: 삿포로 가는데 회색 패딩이랑 입을 코디 추천해줘" onkeypress="handleEnter(event)">
        <button class="send-btn" onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
    </div>
</div>

<script>
    const chatBox = document.getElementById('chatBox');
    const userInput = document.getElementById('userInput');
    const loading = document.getElementById('loading');

    function handleEnter(e) {
        if (e.key === 'Enter') sendMessage();
    }

    function sendMessage() {
        const text = userInput.value.trim();
        if (!text) return;

        // 1. 내 메시지 표시
        addMessage('user', text);
        userInput.value = '';
        loading.style.display = 'block';
        chatBox.scrollTop = chatBox.scrollHeight;

        // 2. 서버에 전송 (AJAX)
        fetch('${pageContext.request.contextPath}/chat/ask', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'message=' + encodeURIComponent(text)
        })
            .then(res => res.json())
            .then(data => {
                loading.style.display = 'none';
                if (data.status === 'success') {
                    // AI 답변 표시
                    addMessage('ai', data.reply);

                    // 추천 스냅이 있으면 카드 형태로 표시
                    if (data.snaps && data.snaps.length > 0) {
                        addSnapCards(data.snaps);
                    }
                } else {
                    addMessage('ai', '죄송합니다. 오류가 발생했어요. 다시 시도해 주세요.');
                }
            })
            .catch(err => {
                loading.style.display = 'none';
                console.error(err);
                addMessage('ai', '서버 연결에 실패했습니다.');
            });
    }

    function addMessage(type, text) {
        const msgDiv = document.createElement('div');
        msgDiv.className = 'message ' + type;
        msgDiv.innerHTML = '<div class="bubble">' + text.replace(/\n/g, '<br>') + '</div>';
        chatBox.appendChild(msgDiv);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function addSnapCards(snaps) {
        const gridDiv = document.createElement('div');
        gridDiv.className = 'message ai';

        let cardsHtml = '<div class="recommend-grid">';
        snaps.forEach(snap => {
            cardsHtml += `
                <div class="snap-card" onclick="location.href='${pageContext.request.contextPath}/snaps/view/\${snap.snap_id}'">
                    <img src="${pageContext.request.contextPath}\${snap.coord_image}" class="snap-img">
                    <div class="snap-info">
                        <div class="snap-title">\${snap.snap_title}</div>
                        <div class="snap-meta">
                            <span>\${snap.style}</span>
                            <span>❤️ \${snap.like_count}</span>
                        </div>
                    </div>
                </div>
            `;
        });
        cardsHtml += '</div>';

        gridDiv.innerHTML = cardsHtml;
        chatBox.appendChild(gridDiv);
        chatBox.scrollTop = chatBox.scrollHeight;
    }
</script>

</body>
</html>