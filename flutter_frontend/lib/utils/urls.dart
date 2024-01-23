// urls.dart

const String baseUrl =
    "http://192.168.0.23:8085"; // Replace with your base API URL

// Habit API paths
const String habitPath = "/habits/";
const String habitRecordPath = "/habitRecords/";


// HabitService
Uri retrieveUrl() => Uri.parse("$baseUrl$habitPath");
Uri createUrl() => Uri.parse("${baseUrl}${habitPath}create/");
Uri updateUrl(int id) => Uri.parse("${baseUrl}${habitPath}$id/update/");
Uri deleteUrl(int id) => Uri.parse("${baseUrl}${habitPath}$id/delete/");
Uri executeHabitUrl() => Uri.parse("${baseUrl}${habitRecordPath}create/");

Uri loginUrl() => Uri.parse("$baseUrl/login/");
Uri signupUrl() => Uri.parse("$baseUrl/signup/");
Uri testTokenUrl() => Uri.parse("$baseUrl/test-token/");
