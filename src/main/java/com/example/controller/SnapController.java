package com.example.controller;

import com.example.bean.SnapVO;
import com.example.bean.UserVO;
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
import javax.servlet.http.HttpSession;
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
        return "/snaps/index";
    }

    @GetMapping("/write")
    public String writeSnap() {
        return "/snaps/write";
    }

    @PostMapping("/write")
    public String writeSnapOK(SnapVO snapVO,
                              @RequestParam("coordFile") MultipartFile coordFile,
                              @RequestParam("productFile") MultipartFile productFile,
                              HttpSession httpSession) throws IOException {

        UserVO loginUser = (UserVO) httpSession.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/users/login";
        }

        // 로그인한 유저의 id 사용
        snapVO.setUser_id(loginUser.getUser_id());

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

        snapDAO.insertSnap(snapVO);

        return "redirect:/snaps/";
    }

    @GetMapping("/list")
    public String snapList(Model model) {
        model.addAttribute("list", snapDAO.getSnapList());
        return "/snaps/list";
    }

    @GetMapping("/view/{id}")
    public String viewSnap(@PathVariable("id") int id, Model model) {
        snapDAO.countSnap(id);
        model.addAttribute("snap", snapDAO.getSnap(id));
        return "/snaps/view";
    }

    // 1. 수정 페이지로 이동 (기존 데이터 들고 감)
    @GetMapping("/edit/{id}")
    public String editSnap(@PathVariable("id") int id, Model model) {
        SnapVO snapVO = snapDAO.getSnap(id);
        model.addAttribute("u", snapVO);
        return "/snaps/edit";
    }

    // 2. 수정 완료 (DB 업데이트 후 목록으로 이동)
    @PostMapping("/edit/ok")
    public String editSnapOk(SnapVO snapVO,
                             @RequestParam("coordFile") MultipartFile coordFile,
                             @RequestParam("productFile") MultipartFile productFile) throws IOException {

        String uploadPath = servletContext.getRealPath("/resources/img/uploads/");

        // 새 코디 이미지가 있을 때만 교체
        if (!coordFile.isEmpty()) {
            String coordFileName = UUID.randomUUID() + "_" + coordFile.getOriginalFilename();
            coordFile.transferTo(new File(uploadPath + coordFileName));
            snapVO.setCoord_image("/resources/img/uploads/" + coordFileName);
        }

        // 새 상품 이미지가 있을 때만 교체
        if (!productFile.isEmpty()) {
            String productFileName = UUID.randomUUID() + "_" + productFile.getOriginalFilename();
            productFile.transferTo(new File(uploadPath + productFileName));
            snapVO.setProduct_image("/resources/img/uploads/" + productFileName);
        }

        snapDAO.updateSnap(snapVO);
        return "redirect:/snaps/list";
    }
    @GetMapping("/delete/{id}")
    public String deleteSnap(@PathVariable("id") int id) {
        snapDAO.deleteSnap(id);
        return "redirect:/snaps/list";
    }

    // [추가] 좋아요 기능 (+ 폴더 생성 로직 포함)
    @GetMapping("/like/{id}")
    public String likeSnap(@PathVariable("id") int snap_id, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginUser");

        // 1. 로그인 안 했으면 로그인 창으로 튕기기
        if (loginUser == null) {
            return "redirect:/users/login";
        }

        // 2. 좋아요 수 증가 (DB 처리)
        snapDAO.likeSnap(snap_id);

        // 3. [보고서 요구사항] 실제 폴더 생성 (webapp/resources/likes/유저ID)
        String userId = String.valueOf(loginUser.getUser_id());
        String path = session.getServletContext().getRealPath("/resources/likes/" + userId);

        File folder = new File(path);
        if (!folder.exists()) {
            boolean created = folder.mkdirs(); // 실제 폴더 생성
            if(created) {
                System.out.println("폴더 생성 성공: " + path);
            }
        }

        // 4. 다시 원래 보던 상세 페이지로 돌아가기
        return "redirect:/snaps/view/" + snap_id;
    }
}
