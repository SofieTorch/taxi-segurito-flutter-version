import 'dart:developer';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:taxi_segurito_app/models/client_user.dart';
import 'package:taxi_segurito_app/models/user.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/services/server.dart';

class LoginFacebookUtils {
  FacebookAuth facebookAuth = FacebookAuth.i;

  //LoginWithFacebook
  Future<Clientuser?> LoginWithFacebook() async {
    // Authentication is executed request the required permissions
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      ).catchError((e) {
        log(e.toString());
        return null;
      });
      if (result.status == LoginStatus.failed) {
        return null;
      }
      if (result.status == LoginStatus.cancelled) {
        return null;
      } else if (result.status == LoginStatus.success) {
        //The data is captured in userData
        var userData = await FacebookAuth.instance
            .getUserData(fields: "name,email,picture.width(200)")
            .catchError((e) {
          log(e.toString());
          return null;
        });
        if (userData != null) {
          String fullName = userData.entries.first.value;
          String email = userData["email"].toString();
          String cellphone = "";
          Clientuser client = Clientuser.insert(
              fullname: fullName,
              cellphone: cellphone,
              email: email,
              password: "Facebook",
              signUpType: Server.SignUpType['FACEBOOK']!);
          //CheckExits retorna numero si existe
          //retorna Error si no existe
          User? userExist = await AuthService().logIn(client);
          if (userExist != null) {
            Clientuser clientExits = Clientuser.insert(
                fullname: userExist.fullName,
                cellphone: userExist.cellphone,
                email: email,
                password: "Facebook",
                signUpType: Server.SignUpType['FACEBOOK']!);
            return clientExits;
          }
          //Cuando No exista el usuario en la BD se le debera pedir el numero de telefono
          return client;
        }
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
