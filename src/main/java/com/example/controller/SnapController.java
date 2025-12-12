package com.example.controller;

import com.example.bean.SnapVO;
import com.example.dao.SnapDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller

@RequestMapping("/snaps")
public class SnapController {

    @Autowired
    public SnapDAO snapDAO;

    @RequestMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/write")
    public String writeSnap() {
        return "write";
    }

    @PostMapping("/write")
    public String writeSnapOk(SnapVO snapVO) {
        snapVO.setUser_id(1);  // 임시로 user_id 고정 (로그인 구현 전)
        snapDAO.insertSnap(snapVO);
        return "redirect:/snaps";
    }
}
