class EndPoint {
  //Base url

  static const baseurl = "https://uttamgyanapi.veteransoftwares.com/api";

  //All Course
  static const allcourse = "$baseurl/Course/getallcourse";
  static const allCourseVideo = "$baseurl/Course/SearchCourseVideos";

  static const myCourse = "$baseurl/Course/GetPurchasedCourses";

  static const myCourseVideos = "$baseurl/CourseVideos/getvideowithprogress";

  static const orderDashBoard = "$baseurl/payments/orderdashboard";

  static const Register = "$baseurl/Registrationnew/Register";
  static const Login = "$baseurl/UserLogin/loginuser";
  static const commissionsAPI = "$baseurl/success/commissions";
  static const profileAPI = "$baseurl/users";
  static const userVideoProgress = "$baseurl/UserVideoProgress/save";
}
