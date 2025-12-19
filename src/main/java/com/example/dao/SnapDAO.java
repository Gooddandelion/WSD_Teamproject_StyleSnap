package com.example.dao;
import java.util.List;
import java.util.Map;

import com.example.bean.SnapVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SnapDAO {

    @Autowired
    SqlSession sqlSession;

    public List<SnapVO> getSnapList(Map<String, Object> params) {
        return sqlSession.selectList("snap.getSnapList", params);
    }

    public int insertSnap(SnapVO snapVO) {
        return sqlSession.insert("snap.insertSnap", snapVO);
    }

    public List<SnapVO> getSnapList() {
        return sqlSession.selectList("snap.getSnapList");
    }

    public SnapVO getSnap(int snap_id) {
        return sqlSession.selectOne("snap.getSnap", snap_id);
    }

    public int updateSnap(SnapVO snapVO) {
        return sqlSession.update("snap.updateSnap", snapVO);
    }

    public int deleteSnap(int snap_id) {
        return sqlSession.delete("snap.deleteSnap", snap_id);
    }

    public int countSnap(int snap_id) {return sqlSession.update("snap.countSnap", snap_id); }

    // [추가] 좋아요 카운트 증가
    public void likeSnap(int snap_id) {
        sqlSession.update("snap.likeSnap", snap_id);
    }
}
