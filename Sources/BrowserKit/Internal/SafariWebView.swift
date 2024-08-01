//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)

import SwiftUI
import SafariServices

/// A SwiftUI view that wraps `SFSafariViewController` for presenting web content.
///
/// This struct allows you to present a web view using `SFSafariViewController` in iOS, visionOS,
/// or Catalyst applications. It provides a way to configure the `SFSafariViewController` and
/// its view using closures for customized settings.
internal struct SafariWebView: UIViewControllerRepresentable {

    /// The URL to load in the `SFSafariViewController`.
    internal let url: URL

    /// A closure to configure the `SFSafariViewController.Configuration` before creating the
    /// view controller.
    internal let configurationClosure: ((inout SFSafariViewController.Configuration) -> Void)?

    /// A closure to configure the `SFSafariViewController` after it has been created.
    internal let viewConfiguration: ((SFSafariViewController) -> Void)?

    /// Creates and returns an `SFSafariViewController` with the specified configuration.
    ///
    /// - Parameter context: The context in which the view controller is created.
    /// - Returns: An `SFSafariViewController` configured with the provided URL and settings.
    internal func makeUIViewController(context: Context) -> SFSafariViewController {
        var configuration = SFSafariViewController.Configuration()
        configurationClosure?(&configuration)
        let controller = SFSafariViewController(url: url, configuration: configuration)
        viewConfiguration?(controller)
        return controller
    }

    /// Updates the `SFSafariViewController` with the current configuration.
    ///
    /// This method is called whenever the SwiftUI view's state changes, allowing you to update
    /// the view controller if needed.
    /// - Parameters:
    ///   - uiViewController: The `SFSafariViewController` to update.
    ///   - context: The context in which the update occurs.
    internal func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#endif
