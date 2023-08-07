import 'package:http/http.dart';

const baseUrl = 'http://192.168.0.5:8080';

const habits = '$baseUrl/habits/';

Uri retrieveUrl = Uri.parse(habits);
