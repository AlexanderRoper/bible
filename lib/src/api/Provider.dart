import 'package:bible/src/model/PassageQuery.dart';
import 'package:reference_parser/reference_parser.dart';
import 'Bible.dart';
import 'ESVAPI.dart';

abstract class Provider {
  final bool _requiresKey;
  final Set<String> _versions;
  final String name;

  static final List<Provider> _providers = [
    ESVAPI(),
  ];

  static final Map<String, Provider> _namedProviders = {};

  static final Map<String, Provider> _defaultProviders = {"esv": _providers[0]};

  static final Map<String, List<Provider>> _availableProviders = {};

  Provider(this.name, this._requiresKey, this._versions) {
    _versions.forEach((version) => {
          Provider._availableProviders.putIfAbsent(version, () => <Provider>[]),
          Provider._availableProviders[version].add(this)
        });
    Provider._namedProviders.putIfAbsent(name, () => this);
  }

  bool containsVersion(String version) => _versions.contains(version);
  bool get requiresKey => _requiresKey;

  static Provider getDefaultProvider(String version) =>
      _defaultProviders[version] ?? _availableProviders[version][0];

  static Provider getProvider(String provider) =>
      _namedProviders[provider.toLowerCase];

  static List<Provider> getProviders() => _providers;

  Future<PassageQuery> getPassage(BibleReference query,
      {Map<String, String> parameters});
}
