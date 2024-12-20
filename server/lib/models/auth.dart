class CachedAuthTokenData {
  final DateTime tokenExpiration;
  final int accountID;
  final String cachedAccountUsername;

  const CachedAuthTokenData({
    required this.tokenExpiration,
    required this.accountID,
    required this.cachedAccountUsername,
  });
}
