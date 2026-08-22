/// 环境配置 (对标 desktop common/config：dev/test/prod 的 baseUrl、wsUrl)
enum Env { dev, test, prod }

class EnvConfig {
  final String baseUrl;
  final String wsUrl;
  final String oauthBaseUrl;

  const EnvConfig({
    required this.baseUrl,
    required this.wsUrl,
    required this.oauthBaseUrl,
  });
}

const _configs = <Env, EnvConfig>{
  Env.dev: EnvConfig(
    baseUrl: 'http://192.168.3.4:20800',
    wsUrl: 'ws://192.168.3.4:20800/api/ws/v1/ws',
    oauthBaseUrl: 'http://192.168.3.4:5173',
  ),
  Env.test: EnvConfig(
    baseUrl: 'https://server.wsrh8888.com/beaver/',
    wsUrl: 'wss://server.wsrh8888.com/beaver/api/ws/v1/ws',
    oauthBaseUrl: 'https://oauth-test.wsrh8888.com',
  ),
  Env.prod: EnvConfig(
    baseUrl: 'https://server.wsrh8888.com/beaver/',
    wsUrl: 'wss://server.wsrh8888.com/beaver/api/ws/v1/ws',
    oauthBaseUrl: 'https://oauth.wsrh8888.com',
  ),
};

Env _currentEnv = Env.prod;

/// 当前环境 (可通过 AppConfig.init 或 --dart-define 设置)
Env get currentEnv => _currentEnv;

/// 设置当前环境 (启动时调用，如从 config.ini/环境变量读)
void setCurrentEnv(Env env) {
  _currentEnv = env;
}

EnvConfig get currentEnvConfig => _configs[_currentEnv] ?? _configs[Env.test]!;

String get baseUrl => currentEnvConfig.baseUrl;
String get wsUrl => currentEnvConfig.wsUrl;
String get oauthBaseUrl => currentEnvConfig.oauthBaseUrl;
