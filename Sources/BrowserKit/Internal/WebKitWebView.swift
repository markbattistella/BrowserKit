//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if os(iOS) || os(macOS) || os(visionOS) || targetEnvironment(macCatalyst)

import SwiftUI
import WebKit

/// A SwiftUI wrapper for `WKWebView`, providing a way to display web content using WebKit on iOS,
/// macOS, visionOS, and Catalyst platforms. This view supports loading content from a URL or an
/// HTML string and allows for configuration of both the WebKit configuration and the `WKWebView`
/// itself.
///
/// - Parameters:
///   - url: The URL to load and display in the web view.
///   - htmlString: An optional HTML string to load into the web view.
///   - htmlBaseUrl: The base URL used to resolve relative paths in the HTML string.
///   - configureWebKit: A closure to configure the `WKWebViewConfiguration` before the web view
///   is created.
///   - configureWebView: A closure to configure the `WKWebView` after creation.
internal struct WebKitWebView: AgnosticViewRepresentable {

    /// The URL to load in the web view, if available. If `nil`, the `htmlString` will be
    /// loaded instead.
    internal let url: URL?

    /// The HTML string to load into the web view, if available. If `nil`, the `url` will be
    /// loaded instead.
    internal let htmlString: String?

    /// The base URL for resolving relative paths within the loaded HTML content, if provided.
    internal let htmlBaseUrl: URL?

    /// A closure for configuring the WebKit view's `WKWebViewConfiguration` before the web view
    /// is created.
    internal let configureWebKit: ((inout WKWebViewConfiguration) -> Void)?

    /// A closure for configuring the `WKWebView` after its creation. This can be used for
    /// additional setup.
    internal let configureWebView: ((WKWebView) -> Void)?

#if os(macOS)

    /// Creates the WebKit-based view for macOS (`NSView`).
    ///
    /// - Parameter context: The context in which the view is created.
    /// - Returns: A fully configured `WKWebView` ready to present content.
    internal func makeNSView(context: Context) -> WKWebView {
        makeWebView()
    }

    /// Updates the WebKit view on macOS when the SwiftUI view's state changes.
    ///
    /// This function allows for updates to the macOS WebKit view when the SwiftUI view is updated.
    /// In this implementation, no updates are required after the view is initially created.
    ///
    /// - Parameters:
    ///   - nsView: The WebKit view (`WKWebView`) to update.
    ///   - context: The context in which the update occurs.
    internal func updateNSView(_ nsView: WKWebView, context: Context) {}

#else

    /// Creates the WebKit-based view for iOS, visionOS, or Catalyst (`UIView`).
    ///
    /// - Parameter context: The context in which the view is created.
    /// - Returns: A fully configured `WKWebView` ready to present content.
    internal func makeUIView(context: Context) -> WKWebView {
        makeWebView()
    }

    /// Updates the WebKit view on iOS, visionOS, or Catalyst when the SwiftUI view's state changes.
    ///
    /// This function allows for updates to the iOS, visionOS, or Catalyst WebKit view when the
    /// SwiftUI view is updated. In this implementation, no updates are required after the view is
    /// initially created.
    ///
    /// - Parameters:
    ///   - uiView: The WebKit view (`WKWebView`) to update.
    ///   - context: The context in which the update occurs.
    internal func updateUIView(_ uiView: WKWebView, context: Context) {}

#endif

    /// Creates a `WKWebView` instance, applies configurations, and loads content from a URL or
    /// HTML string.
    ///
    /// - Returns: A fully configured `WKWebView` instance.
    private func makeWebView() -> WKWebView {
        var configuration = WKWebViewConfiguration()
        configureWebKit?(&configuration)
        let webView = WKWebView(frame: .zero, configuration: configuration)
        configureWebView?(webView)
        loadContent(into: webView)
        return webView
    }

    /// Loads the content into the provided `WKWebView`, either from a URL or an HTML string.
    ///
    /// If a URL is available, it loads the web page. If an HTML string is provided, it loads the
    /// HTML content.
    ///
    /// - Parameter webView: The `WKWebView` instance to load content into.
    private func loadContent(into webView: WKWebView) {
        if let url = url {
            webView.load(URLRequest(url: url))
        } else if let htmlString = htmlString {
            webView.loadHTMLString(htmlString, baseURL: htmlBaseUrl)
        }
    }
}

#endif
