import 'package:farm_tech/backend/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthServices {
  // firebase auth instance
  FirebaseAuth? _firebaseAuth;

  UserAuthServices() {
    // initializing auth instance
    _firebaseAuth = FirebaseAuth.instance;
  }

  // authenticate user
  Future authenticateUser(UserModel userModel) async {
    try {
      UserCredential result = await _firebaseAuth!.signInWithEmailAndPassword(
          email: userModel.email as String,
          password:
              userModel.password as String); // awaiting the sign in user result
      // logged in user object
      User? firebaseUser = result.user;
      print('logged in user: ${firebaseUser.toString()}');
      // return
      return firebaseUser == null
          ? firebaseUser
          : UserModel(uId: firebaseUser.uid);
    } catch (error) {
      // error if user account with email already exists or invalid password for an already registered email
      print("Error in authenticateUser: ${error.toString()}");
      return null;
    }
  }

  // signup user
  Future signUpUser(UserModel userModel) async {
    try {
      // create user auth with email and password
      UserCredential result = await _firebaseAuth!
          .createUserWithEmailAndPassword(
              email: userModel.email as String,
              password: userModel.password
                  as String); // awaiting the create user result

      // user object
      User? firebaseUser = result.user;

      print('signed up user: ${firebaseUser.toString()}');

      return firebaseUser == null
          ? firebaseUser
          : UserModel(uId: firebaseUser.uid);

      // create a brew document with the user uid
      // create a new document for the user with uid
      // await DatabaseService(uid: firebaseUser!.uid)
      //     .updateUserData('0', 'new brew crew user', 100);
      // print(newBrewDoc.toString());
      // return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      // error if user with email already exists
      print('Err in signUpUser: $e');
      return null;
    }
  }

  // get auth changing stream
  Stream<UserModel?>? get authStream {
    return _firebaseAuth
        ?.authStateChanges()
        .map((User? user) => user == null ? null : UserModel(uId: user.uid));
  }

  // sign out
  // future b.c this is going to take sometime to complete and allows calling fyunction to wait for this async function
  Future signOut() async {
    try {
      return await _firebaseAuth?.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

/*
  // check user with email already exists or not
  accountEmailAlreadyExists(UserModel userModel) async {
    try {
      print(userModel.email);
      final result =
          await _firebaseAuth!.fetchSignInMethodsForEmail('test12@gmail.com');
      // if result list is empty means user with the email does not already exists and if list is not empty means user exits
      print('list result: $result');
      return result.isEmpty ? false : true;
    } catch (e) {
      print('Err in signUpUser: $e');
      return null;
    }
  }
  */
}
