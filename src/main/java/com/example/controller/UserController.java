package com.example.controller;

import com.example.bean.UserVO;
import com.example.dao.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserDAO userDAO;

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
            return "/snaps/list";
        } else {
            return "/users/login?error=true";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "/snaps/list";
    }
}
