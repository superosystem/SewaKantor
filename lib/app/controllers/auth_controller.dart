import 'package:chatto/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var skipIntroduction = false.obs;
  var authenticate = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentAccount;
  UserCredential? userCredential;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> bootInitialized() async {
    await _autoLogin().then((value) {
      if (value) {
        authenticate.value = true;
      }
    });
    await _doSkipIntroduction().then((value) {
      if (value) {
        skipIntroduction.value = true;
      }
    });
  }

  // Login with Google Account [check current user, get account credential, save on firebase and local]
  Future<void> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentAccount = value);

      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        final googleAccount = await _currentAccount!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAccount.idToken,
          accessToken: googleAccount.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        // save credential on memory storage
        final box = GetStorage();
        if (box.read('skipIntroduction') != null) {
          box.remove('skipIntroduction');
        }
        box.write('skipIntroduction', true);

        // write to firestore
        CollectionReference user = fireStore.collection('users');
        user.doc(_currentAccount!.email).set({
          'uid': userCredential!.user!.uid,
          'name': _currentAccount!.displayName,
          'email': _currentAccount!.email,
          'image_profile': _currentAccount!.photoUrl,
          'status': '',
          'creationTime': userCredential!.user!.metadata.creationTime!.toIso8601String(),
          'lastSignInTime': userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
          'updatedTime': DateTime.now().toIso8601String(),
        });

        authenticate = true.obs;
        Get.offAllNamed(Routes.HOME);
      } else {
        authenticate = false.obs;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<bool> _autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> _doSkipIntroduction() async {
    final box = GetStorage();
    if (box.read('skipIntroduction') != null ||
        box.read('skipIntroduction') == true) {
      return true;
    }
    return false;
  }
}
