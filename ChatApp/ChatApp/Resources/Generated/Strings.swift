// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Change password success
  internal static let changePasswordSuccess = L10n.tr("Localizable", "change_password_success", fallback: "Change password success")
  /// Re-entered password is incorrect
  internal static let compareFailed = L10n.tr("Localizable", "compare_failed", fallback: "Re-entered password is incorrect")
  /// Current password can't be blank
  internal static let enterCurrentPassword = L10n.tr("Localizable", "enter_current_password", fallback: "Current password can't be blank")
  /// Please choose your image
  internal static let enterImage = L10n.tr("Localizable", "enter_image", fallback: "Please choose your image")
  /// Name can't be blank
  internal static let enterName = L10n.tr("Localizable", "enter_name", fallback: "Name can't be blank")
  /// New password can't be blank
  internal static let enterNewPassword = L10n.tr("Localizable", "enter_new_password", fallback: "New password can't be blank")
  /// Password can't be blank
  internal static let enterPassword = L10n.tr("Localizable", "enter_password", fallback: "Password can't be blank")
  /// Password re-enter can't be blank
  internal static let enterReEnterPassword = L10n.tr("Localizable", "enter_re_enter_password", fallback: "Password re-enter can't be blank")
  /// Username can't be blank
  internal static let enterUsername = L10n.tr("Localizable", "enter_username", fallback: "Username can't be blank")
  /// Current password incorrect
  internal static let incorrectCurrentPassword = L10n.tr("Localizable", "incorrect_current_password", fallback: "Current password incorrect")
  /// Invalid new password
  internal static let invalidNewPassword = L10n.tr("Localizable", "invalid_new_password", fallback: "Invalid new password")
  /// Invalid password
  internal static let invalidPassword = L10n.tr("Localizable", "invalid_password", fallback: "Invalid password")
  /// Invalid username
  internal static let invalidUsername = L10n.tr("Localizable", "invalid_username", fallback: "Invalid username")
  /// Login failed
  internal static let loginFailed = L10n.tr("Localizable", "login_failed", fallback: "Login failed")
  /// Login success
  internal static let loginSuccess = L10n.tr("Localizable", "login_success", fallback: "Login success")
  /// Register success
  internal static let registerSuccess = L10n.tr("Localizable", "register_success", fallback: "Register success")
  /// Username already exists
  internal static let usernameIsExist = L10n.tr("Localizable", "username_is_exist", fallback: "Username already exists")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
