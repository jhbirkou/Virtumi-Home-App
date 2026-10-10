/// Supabase connection settings loaded from `--dart-define` at build time.
class SupabaseConfig {
  SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vaornyvqpipgzrgbfyre.supabase.co',
  );

  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => anonKey.isNotEmpty;
}
