package com.example.controller;

import com.example.bean.SnapVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class IndexController {

    @Autowired
    private SqlSession sqlSession;

    @GetMapping("/")
    public String index(Model model) {

        // 최신 스냅 6개 (최근 등록순)
        List<SnapVO> recentSnaps = sqlSession.selectList("snap.getRecentSnaps");
        model.addAttribute("recentSnaps", recentSnaps);

        // 인기 스냅 4개 (좋아요 순)
        List<SnapVO> popularSnaps = sqlSession.selectList("snap.getPopularSnaps");
        model.addAttribute("popularSnaps", popularSnaps);

        return "index";
    }
}