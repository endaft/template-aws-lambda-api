import 'dart:convert';

final _defaultDateTime = DateTime(1970, 01, 01, 0, 0, 0, 0, 0);
const _emptyString = '';

/// Represent the address for a user from the IdP
class UserDataAddress {
  UserDataAddress({
    required this.formatted,
    required this.streetAddress,
    required this.locality,
    required this.region,
    required this.postalCode,
    required this.country,
  });

  /// Full mailing address, formatted for display or use on a mailing label.
  /// This field MAY contain multiple lines, separated by newlines. Newlines can
  /// be represented either as a carriage return/line feed pair ("\r\n") or as a
  /// single line feed character ("\n").
  final String? formatted;

  /// Full street address component, which MAY include house number, street
  /// name, Post Office Box, and multi-line extended street address information.
  /// This field MAY contain multiple lines, separated by newlines. Newlines
  /// can be represented either as a carriage return/line feed pair ("\r\n") or
  /// as a single line feed character ("\n").
  final String? streetAddress;

  /// City or locality component.
  final String? locality;

  /// State, province, prefecture, or region component.
  final String? region;

  /// Zip code or postal code component.
  final String? postalCode;

  /// Country name component.
  final String? country;

  /// Indicates if this instance is empty or not.
  bool get isEmpty => [
        formatted,
        streetAddress,
        locality,
        region,
        postalCode,
        country
      ].every((v) => v == null || v.isEmpty);

  /// Creates a new [UserDataAddress] from expected an header value
  factory UserDataAddress.fromHeader(String? value) {
    final safeValue = value == null || value.isEmpty ? '{}' : value;
    final Map<String, dynamic> address = jsonDecode(safeValue);
    return UserDataAddress(
        formatted: address["formatted"],
        streetAddress: address["street_address"],
        locality: address["locality"],
        region: address["region"],
        postalCode: address["postal_code"],
        country: address["country"]);
  }

  factory UserDataAddress.empty() {
    return UserDataAddress(
        formatted: _emptyString,
        streetAddress: _emptyString,
        locality: _emptyString,
        region: _emptyString,
        postalCode: _emptyString,
        country: _emptyString);
  }
}

/// Represents the user data available from the IdP
class UserData {
  UserData({
    required this.id,
    required this.username,
    required this.nickname,
    required this.givenName,
    required this.familyName,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.zoneInfo,
    required this.locale,
    required this.picture,
    required this.address,
    required this.lastUpdated,
  });

  /// Exposes the `X-User-Id` header value mapped from `$context.authorizer.claims.sub`
  ///
  /// Subject - Identifier for the End-User at the Issuer.
  final String id;

  /// Exposes the `X-User-Username` header value mapped from
  /// `$context.authorizer.preferred_username`
  ///
  /// Shorthand name by which the End-User wishes to be referred to at the RP,
  /// such as `janedoe` or `j.doe`. This value MAY be any valid JSON string
  /// including special characters such as `@`, `/`, or whitespace. The RP MUST
  /// NOT rely upon this value being unique, as discussed in
  /// [OpenID Connect Core 1.0 Section 5.7](https://openid.net/specs/openid-connect-core-1_0.html#ClaimStability).
  final String username;

  /// Exposes the `X-User-Nickname` header value mapped from
  /// `$context.authorizer.nickname`
  ///
  /// Casual name of the End-User that may or may not be the same as the
  /// `given_name`. For instance, a `nickname` value of `Mike` might be returned
  /// alongside a `given_name` value of `Michael`.
  final String nickname;

  /// Exposes the `X-User-GivenName` header value mapped from `
  /// $context.authorizer.given_name`
  ///
  /// Given name(s) or first name(s) of the End-User. Note that in some
  /// cultures, people can have multiple given names; all can be present, with
  /// the names being separated by space characters.
  final String givenName;

  /// Exposes the `X-User-FamilyName` header value mapped from
  /// `$context.authorizer.family_name`
  ///
  /// Surname(s) or last name(s) of the End-User. Note that in some cultures,
  /// people can have multiple family names or no family name; all can be
  /// present, with the names being separated by space characters.
  final String familyName;

  /// Exposes the `X-User-Email` header value mapped from
  /// `$context.authorizer.email`
  ///
  /// End-User's preferred e-mail address. Its value MUST conform to the
  /// [RFC 5322](https://openid.net/specs/openid-connect-core-1_0.html#RFC5322)
  /// addr-spec syntax. The RP MUST NOT rely upon this value being unique, as
  /// discussed in [
  /// OpenID Connect Core 1.0 Section 5.7](https://openid.net/specs/openid-connect-core-1_0.html#ClaimStability).
  final String email;

  /// Exposes the `X-User-PhoneNumber` header value mapped from
  /// `$context.authorizer.phone_number`
  ///
  /// End-User's preferred telephone number.
  /// [E.164](https://openid.net/specs/openid-connect-core-1_0.html#E.164) is
  /// RECOMMENDED as the format of this Claim, for example, `+1 (425) 555-1212`
  /// or `+56 (2) 687 2400`. If the phone number contains an extension, it is
  /// RECOMMENDED that the extension be represented using the
  /// [RFC 3966](https://openid.net/specs/openid-connect-core-1_0.html#RFC3966)
  /// extension syntax, for example, `+1 (604) 555-1234;ext=5678`.
  final String phoneNumber;

  /// Exposes the `X-User-BirthDate` header value mapped from
  /// `$context.authorizer.birthdate`
  ///
  /// End-User's birthday, represented as an
  /// [ISO 8601:2004](https://openid.net/specs/openid-connect-core-1_0.html#ISO8601-2004)
  /// `YYYY-MM-DD` format. The year MAY be `0000`, indicating that it is omitted.
  /// To represent only the year, `YYYY` format is allowed. Note that depending
  /// on the underlying platform's date related function, providing just year
  /// can result in varying month and day, so the implementers need to take this
  /// factor into account to correctly process the dates.
  final String birthDate;

  /// Exposes the `X-User-ZoneInfo` header value mapped from
  /// `$context.authorizer.zoneinfo`
  ///
  /// String from
  /// [OpenID Connect Core 1.0 - zoneinfo](https://openid.net/specs/openid-connect-core-1_0.html#zoneinfo)
  /// time zone database representing the End-User's time zone. For example,
  /// `Europe/Paris` or `America/Los_Angeles`.
  final String zoneInfo;

  /// Exposes the `X-User-Locale` header value mapped from
  /// `$context.authorizer.locale`
  ///
  /// End-User's locale, represented as a
  /// [BCP47 (RFC5646)](https://openid.net/specs/openid-connect-core-1_0.html#RFC5646)
  /// language tag. This is typically an
  /// [ISO 639-1 Alpha-2 (ISO639‑1)](https://openid.net/specs/openid-connect-core-1_0.html#ISO639-1)
  /// language code in lowercase and an
  /// [ISO 3166-1 Alpha-2 (ISO3166‑1)](https://openid.net/specs/openid-connect-core-1_0.html#ISO3166-1)
  /// country code in uppercase, separated by a dash. For example, `en-US` or
  /// `fr-CA`. As a compatibility note, some implementations have used an
  /// underscore as the separator rather than a dash, for example, `en_US`;
  /// Relying Parties MAY choose to accept this locale syntax as well.
  final String locale;

  /// Exposes the `X-User-Picture` header value mapped from
  /// `$context.authorizer.picture`
  ///
  /// URL of the End-User's profile picture. This URL MUST refer to an image
  /// file (for example, a PNG, JPEG, or GIF image file), rather than to a Web
  /// page containing an image. Note that this URL SHOULD specifically reference
  /// a profile photo of the End-User suitable for displaying when describing
  /// the End-User, rather than an arbitrary photo taken by the End-User.
  final String picture;

  /// Exposes the `X-User-Address` header value mapped from `$context.authorizer.address`
  ///
  /// End-User's preferred postal address. The value of the `address` member is
  /// a JSON [RFC4627](https://openid.net/specs/openid-connect-core-1_0.html#RFC4627)
  /// structure containing some or all of the members defined in
  /// [OpenID Connect Core 1.0 Section 5.1.1](https://openid.net/specs/openid-connect-core-1_0.html#AddressClaim).
  final UserDataAddress address;

  /// Exposes the `X-User-LastUpdated` header value mapped from
  /// `$context.authorizer.updated_at`
  ///
  /// Time the End-User's information was last updated. Its value is a JSON
  /// number representing the number of seconds from 1970-01-01T0:0:0Z as
  /// measured in UTC until the date/time.
  final DateTime lastUpdated;

  /// Indicates if this instance is empty or not.
  bool get isEmpty =>
      [
        id,
        email,
        username,
        nickname,
        givenName,
        familyName,
        phoneNumber,
        birthDate,
        zoneInfo,
        locale,
        picture
      ].every((v) => v.isEmpty) &&
      address.isEmpty &&
      lastUpdated == _defaultDateTime;

  /// Creates a new [UserData] from expected header data
  factory UserData.fromHeaders(Map<String, dynamic> headers) {
    return UserData(
        id: headers['X-User-Id'] ?? '',
        email: headers['X-User-Email'] ?? '',
        username: headers['X-User-Username'] ?? '',
        nickname: headers['X-User-Nickname'] ?? '',
        givenName: headers['X-User-GivenName'] ?? '',
        familyName: headers['X-User-FamilyName'] ?? '',
        phoneNumber: headers['X-User-PhoneNumber'] ?? '',
        birthDate: headers['X-User-BirthDate'] ?? '',
        zoneInfo: headers['X-User-ZoneInfo'] ?? '',
        locale: headers['X-User-Locale'] ?? '',
        picture: headers['X-User-Picture'] ?? '',
        address: UserDataAddress.fromHeader(headers['X-User-Address']),
        lastUpdated: DateTime.tryParse(headers['X-User-LastUpdated']) ??
            _defaultDateTime);
  }

  /// Create a new empty [UserData] with a new empty [UserDataAddress]
  factory UserData.empty() {
    return UserData(
        id: _emptyString,
        username: _emptyString,
        nickname: _emptyString,
        givenName: _emptyString,
        familyName: _emptyString,
        email: _emptyString,
        phoneNumber: _emptyString,
        birthDate: _emptyString,
        zoneInfo: _emptyString,
        locale: _emptyString,
        picture: _emptyString,
        address: UserDataAddress.empty(),
        lastUpdated: _defaultDateTime);
  }
}
