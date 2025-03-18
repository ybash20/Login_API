import 'dart:convert';
import 'dart:io'; // لإضافة Platform

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart'; // المكتبة الجديدة
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/models/user.dart';

import '../dio.dart';

class Auth extends ChangeNotifier {
  final storage = new FlutterSecureStorage();

  bool _authenticated = false;
  User? _user;
  bool get authenticated => _authenticated;
  User get user => _user ?? User();

  Future login({Map? credentials}) async {
    String? deviceId = await getDeviceId();
    Dio.Response response = await dio().post(
      'auth/token',
      data: json.encode((credentials ?? {})..addAll({'deviceId': deviceId})),
    );

    String token = json.decode(response.toString())['token'];
    await attempt(token);
    StoreToken(token);
  }

  Future attempt(String token) async {
    try {
      Dio.Response response = await dio().get('user',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      _user = User.fromjson(json.decode(response.toString()));
      _authenticated = true;
    } catch (e) {
      _authenticated = false;
    }

    notifyListeners();
  }

  void logout() async {
    _authenticated = false;

    await dio().delete('/auth/token',
        data: {'deviceId': await getDeviceId()},
        options: Dio.Options(headers: {'auth': true}));

    this.deleteToken();
    notifyListeners();
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // معرف فريد للأندرويد
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // معرف فريد لـ iOS
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId; // معرف فريد لـ Windows
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId; // معرف فريد لـ Linux
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      return macOsInfo.computerName; // معرف فريد لـ macOS
    }
    // else if (Platform.we) {
    //   WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    //   return webInfo.userAgent; // User Agent للويب
    // }

    return null; // إذا لم يتم التعرف على المنصة
  }

  StoreToken(String token) async {
    await storage.write(key: 'auth', value: token);
  }

  Future getToken() async {
    return await storage.read(key: 'auth');
  }

  deleteToken() async {
    await storage.delete(key: 'auth');
  }
}
