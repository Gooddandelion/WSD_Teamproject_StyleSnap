package com.example.controller;

import com.example.bean.SnapVO;
import com.example.dao.SnapDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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
        return "redirect:/snaps/list";
    }

    @GetMapping("/list")
    public String snapList(Model model) {
        model.addAttribute("list", snapDAO.getSnapList());
        return "list";
    }

    // 1. 수정 페이지로 이동 (기존 데이터 들고 감)
    @GetMapping("/edit/{id}")
    public String editSnap(@PathVariable("id") int id, Model model) {
        SnapVO snapVO = snapDAO.getSnap(id);
        model.addAttribute("u", snapVO);
        return "edit";
    }

    // 2. 수정 완료 (DB 업데이트 후 목록으로 이동)
    @PostMapping("/edit/ok")
    public String editSnapOk(SnapVO snapVO) {
        snapDAO.updateSnap(snapVO);
        return "redirect:/snaps/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteSnap(@PathVariable("id") int id) {
        snapDAO.deleteSnap(id);
        return "redirect:/snaps/list";
    }
}
