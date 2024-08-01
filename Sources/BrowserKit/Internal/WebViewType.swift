//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Enum representing different types of web views based on platform-specific availability.
///
/// This enum is used to differentiate between various configurations or implementations
/// of web views depending on the operating system or platform in use.
internal enum WebViewType {

    #if os(iOS) || os(visionOS) || os(watchOS) || targetEnvironment(macCatalyst)

    /// Represents a simple web view configuration.
    ///
    /// This case is available for iOS, visionOS, watchOS, and Catalyst environments.
    case simple

    #endif

    #if os(iOS) || os(macOS) || os(visionOS) || targetEnvironment(macCatalyst)

    /// Represents an advanced web view configuration.
    ///
    /// This case is available for iOS, macOS, visionOS, and Catalyst environments.
    case advanced

    #endif
}
