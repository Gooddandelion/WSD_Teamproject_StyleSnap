package com.example.controller;

import com.example.bean.FolderVO;
import com.example.bean.UserVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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

    // 1. 내 폴더 리스트 가져오기
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
}