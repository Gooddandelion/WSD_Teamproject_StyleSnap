package com.example.dao;

import com.example.bean.UserVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDAO {

    @Autowired
    private SqlSession sqlSession;

    public int insertUser(UserVO userVO) {
        return sqlSession.insert("user.insertUser", userVO);
    }

    public UserVO login(UserVO userVO) {
        return sqlSession.selectOne("user.login", userVO);
    }

    public int checkEmail(String email) {
        return sqlSession.selectOne("user.checkEmail", email);
    }

    public int checkNickname(String nickname) {
        return sqlSession.selectOne("user.checkNickname", nickname);
    }
}