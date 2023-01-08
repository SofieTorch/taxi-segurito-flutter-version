import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taxi_segurito_app/models/client_user.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/services/server.dart';
import 'package:taxi_segurito_app/services/sign_up_service.dart';
import 'package:taxi_segurito_app/models/user.dart' as U;

class LoginGoogleUtils {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  //GOOGLE Methods
  //SignInWithGoogle
  Future<Clientuser?> signUpWithGoogle() async {
    try {
      //Log in Start
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn().catchError((e) {
        log(e.toString());
        return null;
      });
      //If the login was correct it will be different from null
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        String fullName = user!.displayName.toString();
        String email = user!.email.toString();
        String cellphone = user!.phoneNumber.toString();
        Clientuser client = Clientuser.insert(
            fullname: fullName,
            cellphone: cellphone,
            email: email,
            password: "Google",
            signUpType: Server.SignUpType['GOOGLE']!);
        bool controlBD;
        U.User? exitsClient = await AuthService().logIn(client);
        //Ya existe
        if (exitsClient != null) {
          log("Entro");
          Clientuser client = Clientuser.insert(
              fullname: exitsClient.fullName,
              cellphone: exitsClient.cellphone,
              email: email,
              password: "Google",
              signUpType: Server.SignUpType['GOOGLE']!);
          log(exitsClient.cellphone + "es t");
          return client;
        }
        //En caso de que haya un numero
        if (client.cellphone != "null") {
          controlBD = await SignUpService().registerClientThroughGoogle(client);
          if (controlBD == true) {
            return client;
          } else if (controlBD == false) {
            return null;
          }
        }
        //In case there is no number, the backend will not be called yet
        else {
          return client;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
