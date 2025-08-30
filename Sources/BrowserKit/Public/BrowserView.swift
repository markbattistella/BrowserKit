//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if os(iOS) || os(visionOS) || os(macOS) || targetEnvironment(macCatalyst)

import SwiftUI
import SafariServices
import WebKit

/// Apple v26 released `WebView` and now causes namespace clashing.
@available(iOS, introduced: 13.0, obsoleted: 26.0, deprecated: 18.6, message: "Use `BrowserView` instead of `WebView`.")
public typealias WebView = BrowserView

/// A SwiftUI view that displays web content using either `SFSafariViewController` or `WKWebView`,
/// depending on the platform and configuration.
///
/// - On iOS, visionOS, and Catalyst, this view can present a Safari-based web view using
/// `SFSafariViewController`.
/// - On all platforms, it can also present a `WKWebView` for more customizable web viewing.
///
/// You can configure the web view to load either a URL or an HTML string.
@available(iOS, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on iOS 26 and later.")
@available(macOS, introduced: 10.15, obsoleted: 26.0, message: "BrowserKit is not supported on macOS 26 and later.")
@available(macCatalyst, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on Mac Catalyst 26 and later.")
@available(visionOS, introduced: 1.0, obsoleted: 26.0, message: "BrowserKit is not supported on visionOS 26 and later.")
public struct BrowserView {

    /// The URL to be loaded in the web view.
    private let url: URL?

    /// The type of web view to be presented, either Safari or WebKit.
    private let webViewType: WebViewType

    /// A closure used to configure the Safari view controller's configuration.
    private let configureSafari: ((inout SFSafariViewController.Configuration) -> Void)?

    /// A closure used to configure the `SFSafariViewController` instance directly.
    private let configureSafariView: ((SFSafariViewController) -> Void)?

    /// A closure used to configure the `WKWebViewConfiguration` object.
    private let configureWebKit: ((inout WKWebViewConfiguration) -> Void)?

    /// A closure used to configure the `WKWebView` instance directly.
    private let configureWebView: ((WKWebView) -> Void)?

    /// An optional HTML string to be loaded in the `WKWebView`.
    private let htmlString: String?

    /// The base URL to be used for loading relative resources in the HTML string.
    private let htmlBaseUrl: URL?

    /// Initializes a `BrowserView` with a URL to be loaded.
    ///
    /// - Parameter url: The URL to load in the web view.
    public init(url: URL) {

        #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
        self.init(url: url, safariConfiguration: nil, safariViewConfiguration: nil)

        #elseif os(macOS)

        self.init(url: url, webKitConfiguration: nil, webViewConfiguration: nil)

        #endif
    }

    #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)

    /// Initializes a `BrowserView` with a URL and optional Safari view configurations.
    ///
    /// - Parameters:
    ///   - url: The URL to load in the Safari view.
    ///   - safariConfiguration: An optional closure to configure the `SFSafariViewController.Configuration`.
    ///   - safariViewConfiguration: An optional closure to configure the `SFSafariViewController`.
    public init(
        url: URL,
        safariConfiguration: ((inout SFSafariViewController.Configuration) -> Void)? = nil,
        safariViewConfiguration: ((SFSafariViewController) -> Void)? = nil
    ) {
        self.url = url
        self.htmlString = nil
        self.htmlBaseUrl = nil
        self.webViewType = .safari
        self.configureSafari = safariConfiguration
        self.configureSafariView = safariViewConfiguration
        self.configureWebKit = nil
        self.configureWebView = nil
    }

    #endif

    /// Initializes a `BrowserView` with a URL and optional WKWebView configurations.
    ///
    /// - Parameters:
    ///   - url: The URL to load in the WebKit view.
    ///   - webKitConfiguration: An optional closure to configure the `WKWebViewConfiguration`.
    ///   - webViewConfiguration: An optional closure to configure the `WKWebView`.
    public init(
        url: URL,
        webKitConfiguration: ((inout WKWebViewConfiguration) -> Void)? = nil,
        webViewConfiguration: ((WKWebView) -> Void)? = nil
    ) {
        self.url = url
        self.htmlString = nil
        self.htmlBaseUrl = nil
        self.webViewType = .webkit
        self.configureSafari = nil
        self.configureSafariView = nil
        self.configureWebKit = webKitConfiguration
        self.configureWebView = webViewConfiguration
    }

    /// Initializes a `BrowserView` with a string URL and optional WKWebView configurations.
    ///
    /// - Parameters:
    ///   - urlString: A string representing the URL to load in the WebKit view.
    ///   - webKitConfiguration: An optional closure to configure the `WKWebViewConfiguration`.
    ///   - webViewConfiguration: An optional closure to configure the `WKWebView`.
    public init(
        urlString: String,
        webKitConfiguration: ((inout WKWebViewConfiguration) -> Void)? = nil,
        webViewConfiguration: ((WKWebView) -> Void)? = nil
    ) {
        self.url = URL(string: urlString)
        self.htmlString = nil
        self.htmlBaseUrl = nil
        self.webViewType = .webkit
        self.configureSafari = nil
        self.configureSafariView = nil
        self.configureWebKit = webKitConfiguration
        self.configureWebView = webViewConfiguration
    }

    /// Initializes a `BrowserView` with an HTML string and optional WKWebView configurations.
    ///
    /// - Parameters:
    ///   - htmlString: The HTML content to load in the WebKit view.
    ///   - htmlBaseUrl: The base URL for the HTML content.
    ///   - webKitConfiguration: An optional closure to configure the `WKWebViewConfiguration`.
    ///   - webViewConfiguration: An optional closure to configure the `WKWebView`.
    public init(
        htmlString: String,
        htmlBaseUrl: URL? = nil,
        webKitConfiguration: ((inout WKWebViewConfiguration) -> Void)? = nil,
        webViewConfiguration: ((WKWebView) -> Void)? = nil
    ) {
        self.url = nil
        self.htmlString = htmlString
        self.htmlBaseUrl = htmlBaseUrl
        self.webViewType = .webkit
        self.configureSafari = nil
        self.configureSafariView = nil
        self.configureWebKit = webKitConfiguration
        self.configureWebView = webViewConfiguration
    }
}

@available(iOS, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on iOS 26 and later.")
@available(macOS, introduced: 10.15, obsoleted: 26.0, message: "BrowserKit is not supported on macOS 26 and later.")
@available(macCatalyst, introduced: 13.0, obsoleted: 26.0, message: "BrowserKit is not supported on Mac Catalyst 26 and later.")
@available(visionOS, introduced: 1.0, obsoleted: 26.0, message: "BrowserKit is not supported on visionOS 26 and later.")
extension BrowserView: View {

    /// The body of the `BrowserView`, which renders the appropriate view based on the platform and
    /// configuration.
    ///
    /// - For iOS, visionOS, and Catalyst, this will render a `SafariWebView` if the `webViewType`
    /// is `.safari`.
    /// - On all platforms, it will render a `WebKitWebView` if the `webViewType` is `.webkit`.
    @ViewBuilder
    public var body: some View {
        switch webViewType {

            #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)

            case .safari:
                if let url = url {
                    SafariWebView(
                        url: url,
                        configureSafari: configureSafari,
                        configureSafariView: configureSafariView
                    )
                }

            #endif

            case .webkit:
                WebKitWebView(
                    url: url,
                    htmlString: htmlString,
                    htmlBaseUrl: htmlBaseUrl,
                    configureWebKit: configureWebKit,
                    configureWebView: configureWebView
                )
        }
    }
}

#endif
