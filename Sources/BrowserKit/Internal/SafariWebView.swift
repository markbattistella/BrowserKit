//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)

import SwiftUI
import SafariServices

/// A SwiftUI wrapper for `SFSafariViewController`, providing a way to present web content
/// using Safari on iOS, visionOS, and Catalyst platforms.
///
/// This view allows you to load and present web content in a secure and isolated
/// `SFSafariViewController`, and it supports custom configurations both for the Safari view
/// controller and its view.
///
/// - Parameters:
///   - url: The URL to load and display in the Safari view.
///   - configureSafari: A closure that allows custom configuration of the
///   `SFSafariViewController.Configuration`.
///   - configureSafariView: A closure for configuring the `SFSafariViewController` after it has
///   been initialized.
@available(iOS, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on iOS 26 and later.")
@available(macOS, introduced: 10.15, obsoleted: 26.0, message: "BrowserKit is not supported on macOS 26 and later.")
@available(macCatalyst, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on Mac Catalyst 26 and later.")
@available(visionOS, introduced: 1.0, obsoleted: 26.0, message: "BrowserKit is not supported on visionOS 26 and later.")
internal struct SafariWebView: UIViewControllerRepresentable {
    
    /// The URL to load in the Safari web view.
    internal let url: URL
    
    /// A closure for configuring the Safari view controller's configuration before it's presented.
    /// This allows customization of features such as reader mode, bar tint, and more.
    internal let configureSafari: ((inout SFSafariViewController.Configuration) -> Void)?
    
    /// A closure for further configuring the `SFSafariViewController` after creation, such as
    /// setting specific view properties or handling delegate methods.
    internal let configureSafariView: ((SFSafariViewController) -> Void)?
    
    /// Creates the `SFSafariViewController` and configures it with the provided URL and settings.
    ///
    /// - Parameter context: The context in which the view controller is created.
    /// - Returns: A fully configured `SFSafariViewController` ready to present.
    internal func makeUIViewController(context: Context) -> SFSafariViewController {
        var configuration = SFSafariViewController.Configuration()
        configureSafari?(&configuration)
        let controller = SFSafariViewController(url: url, configuration: configuration)
        configureSafariView?(controller)
        return controller
    }
    
    /// Updates the Safari view controller when the SwiftUI view's state changes.
    ///
    /// This method is called whenever the parent view updates its state, allowing for dynamic
    /// updates to the Safari view. However, this particular implementation does not perform any
    /// updates as the Safari view's state remains static.
    ///
    /// - Parameters:
    ///   - uiViewController: The Safari view controller to update.
    ///   - context: The context in which the update occurs.
    internal func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#endif
