//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

#if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)

/// A typealias for `UIViewRepresentable` on iOS, visionOS, and Catalyst platforms.
///
/// This alias ensures that the same code can be used across multiple platforms that rely on
/// `UIViewRepresentable` for integrating UIKit views within SwiftUI. On these platforms, this
/// type represents a view that can wrap a `UIView` for use in a SwiftUI view hierarchy.
@available(iOS, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on iOS 26 and later.")
@available(macCatalyst, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on Mac Catalyst 26 and later.")
@available(visionOS, introduced: 1.0, obsoleted: 26.0, message: "BrowserKit is not supported on visionOS 26 and later.")
internal typealias AgnosticViewRepresentable = UIViewRepresentable

#elseif os(macOS)

/// A typealias for `NSViewRepresentable` on macOS.
///
/// This alias is used on macOS to integrate AppKit views (`NSView`) within SwiftUI using the
/// `NSViewRepresentable` protocol, allowing platform-agnostic code across macOS and other Apple
/// platforms.
@available(macOS, introduced: 10.15, obsoleted: 26.0, message: "BrowserKit is not supported on macOS 26 and later.")
internal typealias AgnosticViewRepresentable = NSViewRepresentable

#endif
