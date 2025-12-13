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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Controller

@RequestMapping("/snaps")
public class SnapController {

    @Autowired
    public SnapDAO snapDAO;

    @Autowired
    private ServletContext servletContext;

    @RequestMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/write")
    public String writeSnap() {
        return "write";
    }

    @PostMapping("/write")
    public String writeSnapOK(SnapVO snapVO,
                        @RequestParam("coordFile") MultipartFile coordFile,
                        @RequestParam("productFile") MultipartFile productFile) throws IOException {

        // 업로드 경로 설정
        String uploadPath = servletContext.getRealPath("/resources/img/uploads/");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 코디 이미지 저장
        if (!coordFile.isEmpty()) {
            String coordFileName = UUID.randomUUID() + "_" + coordFile.getOriginalFilename();
            coordFile.transferTo(new File(uploadPath + coordFileName));
            snapVO.setCoord_image("/resources/img/uploads/" + coordFileName);
        }

        // 상품 이미지 저장
        if (!productFile.isEmpty()) {
            String productFileName = UUID.randomUUID() + "_" + productFile.getOriginalFilename();
            productFile.transferTo(new File(uploadPath + productFileName));
            snapVO.setProduct_image("/resources/img/uploads/" + productFileName);
        }

        snapVO.setUser_id(1);  // 임시 user_id
        snapDAO.insertSnap(snapVO);

        return "redirect:/snaps/";
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
