//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

#if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)

/// A type alias for the platform-specific view representable protocol in UIKit or Catalyst.
///
/// This alias is used to conform to `UIViewRepresentable`, which allows integration of `UIView`
/// objects with SwiftUI in iOS, visionOS, or Catalyst applications.
internal typealias AgnosticViewRepresentable = UIViewRepresentable

#elseif os(macOS)

/// A type alias for the platform-specific view representable protocol in AppKit.
///
/// This alias is used to conform to `NSViewRepresentable`, which allows integration of `NSView`
/// objects with SwiftUI in macOS applications.
internal typealias AgnosticViewRepresentable = NSViewRepresentable

#endif
