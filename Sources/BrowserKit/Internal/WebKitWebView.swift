//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if os(iOS) || os(macOS) || os(visionOS) || targetEnvironment(macCatalyst)

import SwiftUI
import WebKit

/// A SwiftUI view that wraps a `WKWebView` for displaying web content.
///
/// This struct provides a way to present a web view using `WKWebView` in iOS, macOS, visionOS,
/// or Catalyst applications. It supports loading web pages from URLs or HTML strings and allows
/// for customization of the `WKWebView` through configuration and view setup closures.
internal struct WebKitWebView: AgnosticViewRepresentable {

    /// The URL to load in the `WKWebView`.
    internal let url: URL?

    /// The HTML string to load in the `WKWebView`.
    internal let htmlString: String?

    /// The base URL for resolving relative URLs in the HTML string.
    internal let htmlBaseUrl: URL?

    /// A closure to configure the `WKWebViewConfiguration` before creating the web view.
    internal let configurationClosure: ((inout WKWebViewConfiguration) -> Void)?

    /// A closure to configure the `WKWebView` after it has been created.
    internal let viewConfiguration: ((WKWebView) -> Void)?

    #if os(macOS)

    /// Creates and returns a `WKWebView` for macOS.
    ///
    /// - Parameter context: The context in which the view is created.
    /// - Returns: A configured `WKWebView` instance.
    internal func makeNSView(context: Context) -> WKWebView { makeView() }

    /// Updates the `WKWebView` for macOS.
    ///
    /// - Parameters:
    ///   - nsView: The `WKWebView` to update.
    ///   - context: The context in which the update occurs.
    internal func updateNSView(_ nsView: WKWebView, context: Context) {}

    #else

    /// Creates and returns a `WKWebView` for iOS, visionOS, or Catalyst.
    ///
    /// - Parameter context: The context in which the view is created.
    /// - Returns: A configured `WKWebView` instance.
    internal func makeUIView(context: Context) -> WKWebView { makeView() }

    /// Updates the `WKWebView` for iOS, visionOS, or Catalyst.
    ///
    /// - Parameters:
    ///   - uiView: The `WKWebView` to update.
    ///   - context: The context in which the update occurs.
    internal func updateUIView(_ uiView: WKWebView, context: Context) {}

    #endif
}

@MainActor
fileprivate extension WebKitWebView {

    /// Creates and configures a `WKWebView` instance.
    ///
    /// - Returns: A `WKWebView` instance with the applied configuration.
    private func makeWebView() -> WKWebView {
        var configuration = WKWebViewConfiguration()
        configurationClosure?(&configuration)
        return WKWebView(frame: .zero, configuration: configuration)
    }

    /// Creates a `WKWebView`, applies view configuration, and loads content.
    ///
    /// - Returns: A configured `WKWebView` instance.
    private func makeView() -> WKWebView {
        let view = makeWebView()
        viewConfiguration?(view)
        tryLoadUrl(into: view)
        tryLoadHtml(into: view)
        return view
    }

    /// Loads the URL into the `WKWebView` if a URL is provided.
    ///
    /// - Parameter view: The `WKWebView` instance to load the URL into.
    private func tryLoadUrl(into view: WKWebView) {
        if let url = url { view.load(URLRequest(url: url)) }
    }

    /// Loads the HTML string into the `WKWebView` if an HTML string is provided.
    ///
    /// - Parameter view: The `WKWebView` instance to load the HTML string into.
    private func tryLoadHtml(into view: WKWebView) {
        if let htmlString = htmlString { view.loadHTMLString(htmlString, baseURL: htmlBaseUrl) }
    }
}

#endif
