/// 环境配置 (对标 desktop common/config：dev/test/prod 的 baseUrl、wsUrl)
enum Env { dev, test, prod }

class EnvConfig {
  final String baseUrl;
  final String wsUrl;

  const EnvConfig({required this.baseUrl, required this.wsUrl});
}

const _configs = <Env, EnvConfig>{
  Env.dev: EnvConfig(
    baseUrl: 'https://server.wsrh8888.com/beaver',
    wsUrl: 'wss://server.wsrh8888.com/beaver/api/ws/ws',
  ),
  Env.test: EnvConfig(
    baseUrl: 'https://server.wsrh8888.com/beaver',
    wsUrl: 'wss://server.wsrh8888.com/beaver/api/ws/ws',
  ),
  Env.prod: EnvConfig(
    baseUrl: 'https://server.wsrh8888.com/beaver',
    wsUrl: 'wss://server.wsrh8888.com/beaver/api/ws/ws',
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
