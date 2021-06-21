class AppUser {
  String FullName1="", uid="", Profile_Img="", Gender="";
  FriendsInfo Friends;
  UserNotification Notifications;
  Message Messages;
  Posts Post;
  AppUser(
      {this.FullName1,
      this.Friends,
      this.Notifications,
      this.Gender,
      this.Messages,
      this.Post,
      this.Profile_Img,
      this.uid});
  AppUser.fromData(Map<String, dynamic> data)
      : FullName1 = data["FullName1"],
        Notifications = data["Notifications"],
        Messages = data["Messages"],
        Friends = data["Friends"],
        Gender = data["Gender"],
        Post = data["Post"],
        Profile_Img = data["Profile_Img"];

  Map<String, dynamic> toJson() {
    return {
      "FullName1":FullName1,
      "Notifications": Notifications,
      "Messages": Messages,
      "Friends": Friends,
      "Gender":Gender,
      "Post": Post,
      "Profile_Img": Profile_Img,
    };
  }
}

class Posts {
  String post_uid="", headline="", content="";
  int img_count=0;
  String Image_url="";
  String post_users_id="", date="";
  Posts(this.post_users_id, this.content, this.date, this.headline,
      this.Image_url, this.post_uid, this.img_count);

  Map<String, dynamic> toJson() {
    return {
      "post_uid":post_uid,
      "content": content,
      "date": date,
      "headline": headline,
      "Image_url":Image_url,
      "post_users_id":post_users_id,
      "img_count": img_count,
    };
  }

  Posts.toJson(Map<String, dynamic> json)
      : post_uid = json["post_uid"],
        content = json["content"],
        date = json["date"],
        headline = json["headline"],
        Image_url = json["Image_url"],
        img_count = json["img_count"],
        post_users_id = json["post_users_id"];
}

class Message {
  String uidfrom="", uidto="", content="";
  Message(this.content, this.uidfrom, this.uidto);
  Message.fromJson(Map<String, dynamic> json)
      : uidfrom = json["uidfrom"],
        uidto = json["uidto"],
        content = json["content"];

  Map<String, dynamic> toJson() {
    return {
      "uidfrom":uidfrom,
      "uidto": uidto,
      "content": content,
    };
  }
}

class UserNotification {
  String Date="", noti_info="", profile_info="";
  UserNotification(this.Date, this.noti_info, this.profile_info);

  UserNotification.fromJson(Map<String, dynamic> json)
      : Date = json["Date"],
        noti_info = json["noti_info"],
        profile_info = json["profile_info"];

  Map<String, dynamic> toJson() {
    return {
      "Date": Date,
      "noti_info":noti_info,
      "profile_info":profile_info,
    };
  }
}

class FriendsInfo {
  String name="", friend_id="", profile_img="";
  FriendsInfo(this.name, this.friend_id, this.profile_img);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "friend_id":friend_id,
      "profile_img": profile_img,
    };
  }

  FriendsInfo.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        friend_id = json["friend_id"],
        profile_img = json["profile_img"];
}
