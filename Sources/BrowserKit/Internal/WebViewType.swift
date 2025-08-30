//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// An enumeration that defines the types of web views available for displaying web content.
///
/// This enum provides two options:
/// - `safari`: A web view powered by `SFSafariViewController` (available only on iOS, visionOS,
/// and Catalyst).
/// - `webkit`: A web view powered by `WKWebView`, available on all platforms.
@available(iOS, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on iOS 26 and later.")
@available(macOS, introduced: 10.15, obsoleted: 26.0, message: "BrowserKit is not supported on macOS 26 and later.")
@available(macCatalyst, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on Mac Catalyst 26 and later.")
@available(visionOS, introduced: 1.0, obsoleted: 26.0, message: "BrowserKit is not supported on visionOS 26 and later.")
internal enum WebViewType {

    #if !os(macOS)

    /// A web view that uses `SFSafariViewController` to display web content. This is available
    /// only on iOS, visionOS, and Catalyst environments.
    case safari

    #endif

    /// A web view that uses `WKWebView` to display web content. This is available on all platforms.
    case webkit
}
