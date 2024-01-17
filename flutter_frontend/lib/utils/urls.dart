// urls.dart

const String baseUrl =
    "http://192.168.0.24:8085"; // Replace with your base API URL

// Habit API paths
const String habitPath = "/habits/";
const String habitRecordPath = "/habitRecords/";

Uri retrieveUrl() => Uri.parse("$baseUrl$habitPath");
Uri createUrl() => Uri.parse("$baseUrl$habitPath" + "create/");
Uri updateUrl(int id) => Uri.parse("$baseUrl$habitPath" + "$id" + "/update/");
Uri deleteUrl(int id) => Uri.parse("$baseUrl$habitPath" + "$id" + "/delete/");
Uri executeHabitUrl() => Uri.parse("$baseUrl$habitRecordPath" + "create/");

// You can expand upon this structure by adding other paths as needed.
