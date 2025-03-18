import 'package:dio/dio.dart';
import 'package:my_app/providors/auth.dart';

Dio dio() {
  var options = BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api/', // تأكد من أن هذا هو العنوان الصحيح
    responseType: ResponseType.plain,
    headers: {
      'accept': 'application/json',
      'content-type': 'application/json',
    },
  );

  var dio = Dio(options); // قم بتمرير options هنا

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        requestInterceptor(options);

        return handler.next(options);
      },
    ),
  );

  return dio;
}

dynamic requestInterceptor(RequestOptions options) async {
  if (options.headers.containsKey('auth')) {
    var token = await Auth().getToken();
    options.headers.addAll({'Authorization': 'Bearer $token'}); 
  }
}
