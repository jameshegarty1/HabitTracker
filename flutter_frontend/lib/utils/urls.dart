// urls.dart

const String baseUrl =
    "http://192.168.0.5:8080"; // Replace with your base API URL

// Habit API paths
const String habitPath = "/habits/";

Uri retrieveUrl() => Uri.parse("$baseUrl$habitPath");
Uri createUrl() => Uri.parse("$baseUrl$habitPath" + "create/");
Uri updateUrl(int id) => Uri.parse("$baseUrl$habitPath" + "$id" + "/update/");
Uri deleteUrl(int id) => Uri.parse("$baseUrl$habitPath" + "$id" + "/delete/");

// You can expand upon this structure by adding other paths as needed.