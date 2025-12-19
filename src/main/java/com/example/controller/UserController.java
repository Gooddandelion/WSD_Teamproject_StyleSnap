package com.example.controller;

import com.example.bean.UserVO;
import com.example.dao.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.UUID;

@Controller
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private ServletContext servletContext; // 파일 경로 확인용

    // 1. 프로필 수정 페이지 이동
    @GetMapping("/edit")
    public String editProfile(HttpSession session) {
        if (session.getAttribute("loginUser") == null) {
            return "redirect:/users/login";
        }
        return "users/edit";
    }

    // 2. 프로필 수정 처리
    @PostMapping("/edit")
    public String editProfileOk(UserVO userVO,
                                @RequestParam("file") MultipartFile file,
                                HttpSession session) throws Exception {

        UserVO loginUser = (UserVO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/users/login";

        // 세션의 ID 사용 (보안)
        userVO.setUser_id(loginUser.getUser_id());

        // 파일 업로드 처리
        if (!file.isEmpty()) {
            String uploadPath = servletContext.getRealPath("/resources/img/uploads/profile/");
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();

            String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
            file.transferTo(new File(uploadPath + fileName));

            userVO.setProfile_image("/resources/img/uploads/profile/" + fileName);
        }

        // DB 업데이트
        userDAO.updateUser(userVO);

        // 세션 정보 갱신 (중요: 변경된 닉네임/사진 즉시 반영)
        UserVO updatedUser = userDAO.getUser(loginUser.getUser_id());
        session.setAttribute("loginUser", updatedUser);

        return "redirect:/folder/my";
    }

    @GetMapping("/signup")
    public String signup() {
        return "users/signup";
    }

    @PostMapping("/signup")
    public String signup_ok(UserVO userVO) {
        userDAO.insertUser(userVO);
        return "users/login";
    }

    @GetMapping("/login")
    public String login() {
        return "users/login";
    }

    @PostMapping("/login")
    public String login(UserVO userVO, HttpSession session) {
        UserVO loginUser = userDAO.login(userVO);

        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser);
            return "redirect:/snaps/list";
        } else {
            return "redirect:/users/login?error=true";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/snaps/list";
    }
}
