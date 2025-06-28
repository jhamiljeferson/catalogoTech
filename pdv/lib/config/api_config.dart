class ApiConfig {
  static const String baseUrl = 'http://192.168.0.8:9191';
  static const Duration timeout = Duration(seconds: 30);

  // Endpoints
  static const String authEndpoint = '$baseUrl/auth';
  static const String categoriasEndpoint = '$baseUrl/categorias';
  static const String fornecedoresEndpoint = '$baseUrl/fornecedores';
  static const String coresEndpoint = '$baseUrl/cores';
  static const String tamanhosEndpoint = '$baseUrl/tamanhos';
  static const String produtosEndpoint = '$baseUrl/produtos';
}
