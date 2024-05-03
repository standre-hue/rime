// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:mysql1/mysql1.dart';
import 'package:rime/data/models/User.dart';
import 'package:rime/presentation/utils/errors.dart';
import 'package:rime/presentation/utils/funcs.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';

class UserRepository {
  MySqlConnection? connection;
  UserRepository() {
    //_connectDB();
  }

  Future<void> _connectDB() async {
    try {
      if (connection != null) return;
      connection = await connectDB();
      print("CONNECTED FROM USER REPO");
    } catch (e) {
      print(e);
    }
  }

  Future<User?> findUserByUsernameAndPassword(
      String username, String password) async {
    try {
      await _connectDB();
      bool _userExists = await this.userExists(username);
      if (!_userExists) {
        throw UserDoesNotExistException('user does not exist');
      }
      String hashedPassword = hashPasswordWithMd5(password);
      var results = await connection!.query(
        'select id, username, password, role, createdAt from  user  where username = ?',
        [username],
      );
      for (var row in results) {
        if (row[2] != hashedPassword) {
          throw IncorrectPasswordException("Incorrect password");
        }
        return User(
            id: row[0], username: row[1], role: row[2], createdAt: row[4]);
      }
    } catch (e) {
      print(e);
      //if (e is LateInitializationError) _connectDB();
      rethrow;
    }
  }

/////
  Future<bool> userExists(String username) async {
    try {
      await _connectDB();
      var results = await connection!
          .query('select username from user where username = ?', [username]);
      return results.isEmpty ? false : true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User?> createUser(String username, String password) async {
    try {
      await _connectDB();
      String hashedPassword = hashPasswordWithMd5(password);
      var result = await connection!.query(
          'insert into user (username, password) values (?, ?)',
          [username, hashedPassword]);
      User? user = await this.findUserbyId(result.insertId);
      return user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User?> findUserbyId(int? id) async {
    try {
      await _connectDB();
      var results = await connection!.query(
          'select id,username, role, createdAt from user where id = ?', [id]);
      if (results.isEmpty) return null;
      late User user;
      for (var row in results) {
        user =
            User(id: row[0], username: row[1], role: row[2], createdAt: row[3]);
      }
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<List<User>> getAllUser() async {
    try {
      await _connectDB();
      List<User> users = [];
      var results = await connection!
          .query('select id,username, role, createdAt from user ');
      if (results.isEmpty) return users;

      for (var row in results) {
        User user =
            User(id: row[0], username: row[1], role: row[2], createdAt: row[3]);
        users.add(user);
      }
      return users;
    } catch (e) {
      print('ERRRRRRRRRRRRRRRRRRR');
      print(e);
      rethrow;
    }
  }

  Future<List<User>> getUserByUsername(String username) async {
    try {
      await _connectDB();
      List<User> users = [];
      var results = await connection!.query(
          "select id,username, role, createdAt from user where username like '%${username}%' ");
      if (results.isEmpty) return users;

      for (var row in results) {
        User user =
            User(id: row[0], username: row[1], role: row[2], createdAt: row[3]);
        users.add(user);
      }
      return users;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String?> getUserPassword(int userId) async {
    try {
      await _connectDB();
      var results = await connection!
          .query("select password from user where id = ?  ", [userId]);
      for (var row in results) {
        return row[0];
      }
    } catch (e) {
      rethrow;
    }
  }
}
