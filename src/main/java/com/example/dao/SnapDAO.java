package com.example.dao;
import java.util.List;
import com.example.bean.SnapVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SnapDAO {

    @Autowired
    SqlSession sqlSession;

    public int insertSnap(SnapVO snapVO) {
        return sqlSession.insert("snap.insertSnap", snapVO);
    }

    public List<SnapVO> getSnapList() {
        return sqlSession.selectList("snap.getSnapList");
    }
}
