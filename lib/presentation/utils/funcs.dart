// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstTime() async {
  final preferences = await SharedPreferences.getInstance();
  return preferences.getBool('isFirstTime') == null;
}

Future<MySqlConnection> connectDB() async {
  try {
    var settings = ConnectionSettings(
        host: 'localhost', port: 3306, user: 'root', db: 'rime');
    MySqlConnection connection = await MySqlConnection.connect(settings);
    return connection;
  } catch (e) {
    print(e);
    rethrow;
  }
}

String hashPasswordWithMd5(String password) {
  var bytes = utf8.encode(password); // data being hashed
  var digest = md5.convert(bytes);
  return digest.toString();
}

void initServer() async {}

void updateUI(BuildContext context) {}

String formatTogoPhoneNumber(String phoneNumber) {
  // Remove any non-digit characters from the input phone number
  String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D+'), '');

  // Check if the phone number starts with "00228" or "+228"
  if (digitsOnly.startsWith('00228')) {
    // If it starts with "00228", replace it with "+228"
    return '+228 ' +
        digitsOnly
            .substring(5)
            .replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ');
  } else if (digitsOnly.startsWith('+228')) {
    // If it starts with "+228", keep it as is
    return digitsOnly.replaceFirstMapped(
        RegExp(r'^(\+228)'), (match) => '${match.group(0)} ');
  } else {
    // If it doesn't start with "00228" or "+228", assume it's a local number and add "+228" as prefix
    return '+228 ' +
        digitsOnly.replaceAllMapped(
            RegExp(r'.{2}'), (match) => '${match.group(0)} ');
  }
}

String formatDate(DateTime date) {
  String ftDate = "";
  String day = "";
  String month = "";
  String year = "";
  if (date.day < 10) {
    day = '0${date.day}';
  } else {
    day = '${date.day}';
  }

  if (date.month < 10) {
    month = '0${date.month}';
  } else {
    month = '${date.month}';
  }

  ftDate = "$day/${month}/${date.year}";
  return ftDate;
}

String formatDateUs(DateTime date) {
  String ftDate = "";
  String day = "";
  String month = "";
  String year = "";
  if (date.day < 10) {
    day = '0${date.day}';
  } else {
    day = '${date.day}';
  }

  if (date.month < 10) {
    month = '0${date.month}';
  } else {
    month = '${date.month}';
  }

  ftDate = "${date.year}/${month}/$day";
  return ftDate;
}

String formatTime(DateTime date) {
  String ftTime = "";
  String hour = "";
  String minute = "";
  String second = "";
  if (date.hour < 10) {
    hour = '0${date.hour}';
  } else {
    hour = '${date.hour}';
  }

  if (date.minute < 10) {
    minute = '0${date.minute}';
  } else {
    minute = '${date.minute}';
  }
  if (date.second < 10) {
    second = '0${date.second}';
  } else {
    second = '${date.second}';
  }

  ftTime = "$hour:${minute}:${second}";
  return ftTime;
}

final frenchFormat =
    NumberFormat.currency(locale: 'fr_FR', symbol: '', decimalDigits: 0);

String getCodeStr(String type) {
  switch (type) {
    case 'TMONEY_DEPOT':
      return 'Code Tmoney Dépot';
    default:
      return '';
  }
}
