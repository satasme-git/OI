class UserModel {
  late String? uid;
  late String? firstname;
  late String? lastname;
  late String? phone;
  late String? email;
  late String? otp;
  late int? status;
  UserModel({
    this.uid,
    this.firstname,
    this.lastname,
    this.phone,
    this.email,
    this.otp,
    this.status,
  });
  UserModel.fromMap(Map map) {
    uid = map['uid'];
    firstname = map['firstname'];
    lastname = map['lastname'];
    phone = map['phone'];
    email = map['email'];
    otp = map['otp'];
    status = map['status'];
  }
  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'email': email,
      'otp': otp,
      'status': status,
    };
  }
}
