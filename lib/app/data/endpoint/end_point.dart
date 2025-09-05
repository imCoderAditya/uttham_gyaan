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
  static const paymentsOrder = "$baseurl/payments/order";
  static const paymentStatusUpdate = "$baseurl/payments/updatestatus";
  static const Addbank = "$baseurl/bankdetails/addorupdate";
  static const getbank = "$baseurl/bankdetails/get";
  static const getCommissions = "$baseurl/affiliate/commissions";
  static const courseProgressSummary = "$baseurl/courseprogress/summary";
}
