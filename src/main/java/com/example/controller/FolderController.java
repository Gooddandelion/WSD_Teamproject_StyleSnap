package com.example.controller;

import com.example.bean.FolderVO;
import com.example.bean.SnapVO;
import com.example.bean.UserVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/folder")
public class FolderController {

    @Autowired
    SqlSession sqlSession;

    // 1. 내 폴더 리스트 가져오기 (JSON 반환 -> 팝업용)
    @GetMapping("/list")
    @ResponseBody
    public List<FolderVO> getFolders(HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("loginUser");
        if (user == null) return null;
        return sqlSession.selectList("folder.getFolders", user.getUser_id());
    }

    // 2. 새 폴더 만들기
    @PostMapping("/add")
    @ResponseBody
    public String addFolder(@RequestParam("folder_name") String folderName, HttpSession session) {
        UserVO user = (UserVO) session.getAttribute("loginUser");
        if (user == null) return "fail";

        FolderVO vo = new FolderVO();
        vo.setUser_id(user.getUser_id());
        vo.setFolder_name(folderName);

        int result = sqlSession.insert("folder.addFolder", vo);
        return result > 0 ? "success" : "fail";
    }

    // 3. 폴더에 스냅 저장하기
    @PostMapping("/save")
    @ResponseBody
    public String saveSnap(@RequestParam("folder_id") int folderId,
                           @RequestParam("snap_id") int snapId,
                           HttpSession session) {

        UserVO user = (UserVO) session.getAttribute("loginUser");
        if (user == null) return "fail";

        // 중복 저장 체크
        Map<String, Object> map = new HashMap<>();
        map.put("folder_id", folderId);
        map.put("snap_id", snapId);

        Integer exists = sqlSession.selectOne("folder.checkDuplicate", map);
        if (exists != null && exists > 0) {
            return "duplicate";
        }

        sqlSession.insert("folder.saveSnap", map);
        return "success";
    }

    // 4. 마이페이지 - 내 폴더 리스트 화면
    @GetMapping("/my")
    public String myPage(HttpSession session, Model model) {
        UserVO user = (UserVO) session.getAttribute("loginUser");
        if (user == null) return "redirect:/users/login";

        List<FolderVO> folders = sqlSession.selectList("folder.getFolders", user.getUser_id());
        model.addAttribute("folders", folders);

        return "mypage";
    }

    // 5. 폴더 상세 보기 (폴더 내부 스냅들)
    @GetMapping("/view/{folder_id}")
    public String viewFolder(@PathVariable("folder_id") int folderId, Model model) {
        // 해당 폴더에 있는 스냅 리스트
        List<SnapVO> list = sqlSession.selectList("folder.getSnapsByFolder", folderId);
        // 폴더 이름
        String folderName = sqlSession.selectOne("folder.getFolderName", folderId);

        model.addAttribute("list", list);
        model.addAttribute("folderName", folderName);
        model.addAttribute("folderId", folderId); // JSP에서 쓰기 위해 추가

        return "folder_view";
    }


    // 6. 폴더 이름 변경
    @PostMapping("/rename")
    @ResponseBody
    public String renameFolder(@RequestParam("folder_id") int folderId,
                               @RequestParam("folder_name") String folderName) {
        FolderVO vo = new FolderVO();
        vo.setFolder_id(folderId);
        vo.setFolder_name(folderName);

        int result = sqlSession.update("folder.renameFolder", vo);
        return result > 0 ? "success" : "fail";
    }

    // 7. 폴더 삭제 (내부 스냅 먼저 비우고 폴더 삭제)
    @PostMapping("/delete")
    @ResponseBody
    public String deleteFolder(@RequestParam("folder_id") int folderId) {
        sqlSession.delete("folder.deleteSnapsByFolderId", folderId);

        int result = sqlSession.delete("folder.deleteFolder", folderId);
        return result > 0 ? "success" : "fail";
    }

    // 8. 폴더에서 스냅 하나 제거 (X 버튼)
    @PostMapping("/remove")
    @ResponseBody
    public String removeSnap(@RequestParam("folder_id") int folderId,
                             @RequestParam("snap_id") int snapId) {
        Map<String, Object> map = new HashMap<>();
        map.put("folder_id", folderId);
        map.put("snap_id", snapId);

        int result = sqlSession.delete("folder.removeSnap", map);
        return result > 0 ? "success" : "fail";
    }
}