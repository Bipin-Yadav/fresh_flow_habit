import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current Firebase User
  User? get currentUser => _auth.currentUser;

  // Collection Reference for users
  CollectionReference get usersRef => _db.collection('users');

  // Sign In with email & password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Sign Up with email & password and store user metadata in Firestore
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    // Create authentication credential
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = userCredential.user;
    if (user != null) {
      // Set display name in Firebase Auth profile
      await user.updateDisplayName(fullName);

      // Save additional profile metadata inside cloud firestore
      final newUser = UserModel(
        uid: user.uid,
        email: email,
        fullName: fullName,
        phone: phone,
        avatarUrl: '',
        createdAt: DateTime.now(),
      );

      await usersRef.doc(user.uid).set(newUser.toMap());
    }

    return userCredential;
  }

  // Sign In Anonymously (Guest Mode)
  Future<UserCredential> signInAnonymously() async {
    final UserCredential userCredential = await _auth.signInAnonymously();
    final User? user = userCredential.user;

    if (user != null) {
      // Check if user already has a document (to prevent overwriting if anonymous session persists)
      final doc = await usersRef.doc(user.uid).get();
      if (!doc.exists) {
        final guestUser = UserModel(
          uid: user.uid,
          email: '',
          fullName: 'Guest User',
          phone: '',
          avatarUrl: '',
          createdAt: DateTime.now(),
        );
        await usersRef.doc(user.uid).set(guestUser.toMap());
      }
    }

    return userCredential;
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get User profile document stream from Firestore
  Stream<UserModel?> streamUserData() {
    final user = currentUser;
    if (user == null) {
      return Stream.value(null);
    }
    return usersRef.doc(user.uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    });
  }

  // Fetch single-time profile metadata from Firestore
  Future<UserModel?> getUserData() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await usersRef.doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromDocument(doc);
    }
    return null;
  }

  // Update profile details
  Future<void> updateProfile({
    required String fullName,
    required String phone,
    String? avatarUrl,
  }) async {
    final user = currentUser;
    if (user == null) return;

    // Update Display Name in Firebase Auth profile
    await user.updateDisplayName(fullName);

    final updates = {
      'fullName': fullName,
      'phone': phone,
    };

    if (avatarUrl != null) {
      updates['avatarUrl'] = avatarUrl;
    }

    await usersRef.doc(user.uid).update(updates);
  }
}
