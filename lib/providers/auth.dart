import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  DateTime? _expiryDate;
  late String _userId;
  Timer ? _authTimer ;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(  
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyC0Ry1od84S2-UUnd9mF-059EBiXbKfKfk');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {  // json datar modde error keyword ase seta jonno if condition a er modde error key word dara check kora hoicay. 
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId':_userId,
        'expiryDate':_expiryDate!.toIso8601String(),
      },
      );
      prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData').toString()) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }


  Future<void> logout() async {
    _token = null.toString();
    _userId = null.toString();
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
  void _autoLogout(){
    if(_authTimer!= null){
       _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}


  // Future<void> signup(String email, String password) async {
  //   final url =
  //       Uri.parse(
  //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC0Ry1od84S2-UUnd9mF-059EBiXbKfKfk');
  //   final response = await http.post(
  //     url,
  //     body: json.encode(
  //       {
  //         'email': email,
  //         'password': password,
  //         'returnSecureToken': true,
  //       },
  //     ),
  //   );
  //   print(json.decode(response.body));
  // }

  //  Future<void> login(String email, String password) async {
  //   final url =
  //       Uri.parse(
  //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC0Ry1od84S2-UUnd9mF-059EBiXbKfKfk');
  //   final response = await http.post(
  //     url,
  //     body: json.encode(
  //       {
  //         'email': email,
  //         'password': password,
  //         'returnSecureToken': true,
  //       },
  //     ),
  //   );
  //   print(json.decode(response.body));

//   }




// }
