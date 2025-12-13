package com.example.bean;

public class UserVO {

    private int user_id;
    private String email;
    private String password;
    private String nickname;
    private String profile_image;
    private String craeted_at;

    public UserVO() {}

    public UserVO(int user_id , String email , String password , String nickname , String profile_image , String craeted_at) {
        this.user_id = user_id;
        this.email = email;
        this.password = password;
        this.nickname = nickname;
        this.profile_image = profile_image;
        this.craeted_at = craeted_at;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getProfile_image() {
        return profile_image;
    }

    public void setProfile_image(String profile_image) {
        this.profile_image = profile_image;
    }

    public String getCraeted_at() {
        return craeted_at;
    }

    public void setCraeted_at(String craeted_at) {
        this.craeted_at = craeted_at;
    }
}
