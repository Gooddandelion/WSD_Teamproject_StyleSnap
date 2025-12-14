package com.example.controller;

import com.example.bean.FolderVO;
import com.example.bean.SnapVO; // 이거 없으면 에러남
import com.example.bean.UserVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // 이거 없으면 에러남
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.HashMap;
import java.util.List; // 이거 없으면 에러남
import java.util.Map;

@Controller
@RequestMapping("/folder")
public class FolderController {

    @Autowired
    SqlSession sqlSession;

    // 1. 내 폴더 리스트 가져오기 (팝업용 + 마이페이지용 공용)
    @GetMapping("/list")
    @ResponseBody
    public List<FolderVO> getFolders(HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("loginUser");
        if (user == null) return null;
        return sqlSession.selectList("folder.getFolders", user.getUser_id());
    }

    // 2. 새 폴더 만들기 (DB + 실제 폴더)
    @PostMapping("/add")
    @ResponseBody
    public String addFolder(@RequestParam("folder_name") String folderName, HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("loginUser");
        if (user == null) return "fail";

        // DB 저장
        FolderVO vo = new FolderVO();
        vo.setUser_id(user.getUser_id());
        vo.setFolder_name(folderName);
        sqlSession.insert("folder.addFolder", vo);

        // 실제 폴더 생성
        String path = session.getServletContext().getRealPath("/resources/saved/" + user.getUser_id() + "/" + folderName);
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return "success";
    }

    // 3. 스냅 저장하기
    @PostMapping("/save")
    @ResponseBody
    public String saveSnap(@RequestParam("folder_id") int folderId,
                           @RequestParam("snap_id") int snapId) {
        Map<String, Object> map = new HashMap<>();
        map.put("folder_id", folderId);
        map.put("snap_id", snapId);

        sqlSession.insert("folder.saveSnap", map);
        return "success";
    }

    // ================= [아래 부분이 추가된 내용] =================

    // 4. 마이페이지 (내 폴더 리스트 보여주기)
    @GetMapping("/my")
    public String myPage(HttpSession session, Model model) {
        UserVO user = (UserVO) session.getAttribute("loginUser");
        if (user == null) return "redirect:/users/login";

        // 내 폴더 목록 가져오기
        List<FolderVO> folders = sqlSession.selectList("folder.getFolders", user.getUser_id());
        model.addAttribute("folders", folders);

        return "mypage";
    }

    // 5. 폴더 상세 보기 (폴더 안의 사진들)
    @GetMapping("/view/{folder_id}")
    public String viewFolder(@PathVariable("folder_id") int folderId, Model model) {
        // 해당 폴더에 있는 스냅 리스트 가져오기
        List<SnapVO> list = sqlSession.selectList("folder.getSnapsByFolder", folderId);

        // 폴더 이름 가져오기
        String folderName = sqlSession.selectOne("folder.getFolderName", folderId);

        model.addAttribute("list", list);
        model.addAttribute("folderName", folderName);

        return "folder_view";
    }
}