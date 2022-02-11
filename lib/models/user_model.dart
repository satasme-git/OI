class UserModel {
  late String uid;
  late String? name;
  late String phone;
  late String? email;
  late String otp;
  late int? status;
  UserModel({
    required this.uid,
    this.name,
    required this.phone,
    this.email,
    required this.otp,
    this.status,
  });
  UserModel.fromJson(Map map) {
    uid = map['uid'];
    name = map['name'];
    phone = map['phone'];
    email = map['email'];
    otp = map['otp'];
    status = map['status'];
  }
}
