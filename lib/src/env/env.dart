final class Env {
  static String get apiKey =>
      String.fromEnvironment("API_KEY", defaultValue: "");
  static String get baseUrl =>
      String.fromEnvironment("BASE_URL", defaultValue: "");
}
