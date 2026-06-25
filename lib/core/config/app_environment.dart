enum AppEnvironment {
  development,
  staging,
  production;

  static AppEnvironment fromName(String name) {
    switch (name.trim().toLowerCase()) {
      case 'prod':
      case 'production':
        return AppEnvironment.production;
      case 'stage':
      case 'staging':
        return AppEnvironment.staging;
      case 'dev':
      case 'development':
      default:
        return AppEnvironment.development;
    }
  }
}
