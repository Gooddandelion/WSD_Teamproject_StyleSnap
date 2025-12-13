package com.example.bean;

public class SnapVO {
    private int snap_id;
    private int user_id;
    private String snap_title;
    private String coord_image;      // 코디 사진
    private String product_image;    // 상품 사진
    private String category;
    private String style;
    private String color;
    private int price;
    private int view_count;
    private int like_count;
    private String created_at;

    public SnapVO() {}

    public SnapVO(int snap_id , int user_id , String coord_image, String product_image, String image_url , String category , String style , String color , int price , int view_count , int like_count , String created_at) {
        this.snap_id = snap_id;
        this.user_id = user_id;
        this.snap_title = snap_title;
        this.coord_image = coord_image;
        this.product_image = product_image;
        this.category = category;
        this.style = style;
        this.color = color;
        this.price = price;
        this.view_count = view_count;
        this.like_count = like_count;
        this.created_at = created_at;

    }

    public int getSnap_id() {
        return snap_id;
    }

    public void setSnap_id(int snap_id) {
        this.snap_id = snap_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getSnap_title() {
        return snap_title;
    }

    public void setSnap_title(String snap_title) {
        this.snap_title = snap_title;
    }

    public String getCoord_image() {
        return coord_image;
    }

    public void setCoord_image(String coord_image) {
        this.coord_image = coord_image;
    }

    public String getProduct_image() {
        return product_image;
    }

    public void setProduct_image(String product_image) {
        this.product_image = product_image;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStyle() {
        return style;
    }

    public void setStyle(String style) {
        this.style = style;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getView_count() {
        return view_count;
    }

    public void setView_count(int view_count) {
        this.view_count = view_count;
    }

    public int getLike_count() {
        return like_count;
    }

    public void setLike_count(int like_count) {
        this.like_count = like_count;
    }

    public String getcreated_at() {
        return created_at;
    }

    public void setcreated_at(String created_at) {
        this.created_at = created_at;
    }
}
