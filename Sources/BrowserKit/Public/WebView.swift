//
// Project: BrowserKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if os(iOS) || os(visionOS) || os(macOS) || targetEnvironment(macCatalyst)

import SwiftUI
import SafariServices
import WebKit

// MARK: - Setup
public struct WebView {

    /// The URL to load in the web view.
    private let url: URL?

    /// The type of web view to use (`SFSafariViewController` or `WKWebView`).
    private let type: WebViewType

    #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)

    /// A closure to configure the `SFSafariViewController.Configuration` when using
    /// `SFSafariViewController`.
    private let sfConfigurationClosure: ((inout SFSafariViewController.Configuration) -> Void)?

    /// A closure to configure the `SFSafariViewController` instance when using
    /// `SFSafariViewController`.
    private let sfViewConfiguration: ((SFSafariViewController) -> Void)?

    #endif

    /// A closure to configure the `WKWebViewConfiguration` when using `WKWebView`.
    private let wkConfigurationClosure: ((inout WKWebViewConfiguration) -> Void)?

    /// A closure to configure the `WKWebView` instance when using `WKWebView`.
    private let wkViewConfiguration: ((WKWebView) -> Void)?

    /// The HTML content to load in the web view when using `WKWebView`.
    private let htmlString: String?

    /// The base URL for resolving relative paths in the HTML string when using `WKWebView`.
    private let htmlBaseUrl: URL?
}

// MARK: - Initialisers
extension WebView {

    /// Initializes a `WebView` with a URL, defaulting to using `SFSafariViewController` on 
    /// supported platforms.
    ///
    /// - Parameter url: The URL to load in the web view.
    ///
    /// - Warning: On iOS, the webpage is presented using `SFSafariViewController`. However, on
    /// visionOS and Catalyst, the URL will open in the Safari browser app directly, rather than
    /// in-app. This is a platform-specific behavior intended to provide a consistent user
    /// experience across different Apple environments.
    public init(url: URL) {

        #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
        self.init(url: url, sfConfiguration: nil, sfViewConfiguration: nil)
        #elseif os(macOS)
        self.init(url: url, wkConfiguration: nil, wkViewConfiguration: nil)
        #endif
    }

    /// Initializes a `WebView` with a URL, using `SFSafariViewController` and optional
    /// configurations.
    ///
    /// - Parameters:
    ///   - url: The URL to load in the web view.
    ///   - sfConfiguration: A closure to configure the `SFSafariViewController.Configuration`.
    ///   - sfViewConfiguration: A closure to configure the `SFSafariViewController`.
    ///
    /// - Warning: On iOS, the webpage is presented using `SFSafariViewController`. However, on
    /// visionOS and Catalyst, the URL will open in the Safari browser app directly, rather than
    /// in-app. This is a platform-specific behavior intended to provide a consistent user
    /// experience across different Apple environments.
    #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
    public init(
        url: URL,
        sfConfiguration: ((inout SFSafariViewController.Configuration) -> Void)? = nil,
        sfViewConfiguration: ((SFSafariViewController) -> Void)? = nil
    ) {
        self.url = url
        self.htmlString = nil
        self.htmlBaseUrl = nil
        self.type = .simple
        self.sfConfigurationClosure = sfConfiguration
        self.sfViewConfiguration = sfViewConfiguration
        self.wkConfigurationClosure = nil
        self.wkViewConfiguration = nil
    }
    #endif

    /// Initializes a `WebView` with a URL, using `WKWebView` and optional configurations.
    ///
    /// - Parameters:
    ///   - url: The URL to load in the web view.
    ///   - wkConfiguration: A closure to configure the `WKWebViewConfiguration`.
    ///   - wkViewConfiguration: A closure to configure the `WKWebView`.
    public init(
        url: URL,
        wkConfiguration: ((inout WKWebViewConfiguration) -> Void)? = nil,
        wkViewConfiguration: ((WKWebView) -> Void)? = nil
    ) {
        self.url = url
        self.htmlString = nil
        self.htmlBaseUrl = nil
        self.type = .advanced

        #if os(iOS) || os(visionOS) || os(watchOS) || targetEnvironment(macCatalyst)
        self.sfConfigurationClosure = nil
        self.sfViewConfiguration = nil
        #endif

        self.wkConfigurationClosure = wkConfiguration
        self.wkViewConfiguration = wkViewConfiguration
    }

    /// Initializes a `WebView` with a URL string, using `WKWebView` and optional configurations.
    ///
    /// - Parameters:
    ///   - urlString: The URL string to load in the web view.
    ///   - wkConfiguration: A closure to configure the `WKWebViewConfiguration`.
    ///   - wkViewConfiguration: A closure to configure the `WKWebView`.
    public init(
        urlString: String,
        wkConfiguration: ((inout WKWebViewConfiguration) -> Void)? = nil,
        wkViewConfiguration: ((WKWebView) -> Void)? = nil
    ) {
        self.url = URL(string: urlString)
        self.htmlString = nil
        self.htmlBaseUrl = nil
        self.type = .advanced

        #if os(iOS) || os(visionOS) || os(watchOS) || targetEnvironment(macCatalyst)
        self.sfConfigurationClosure = nil
        self.sfViewConfiguration = nil
        #endif

        self.wkConfigurationClosure = wkConfiguration
        self.wkViewConfiguration = wkViewConfiguration
    }

    /// Initializes a `WebView` with HTML content, using `WKWebView` and optional configurations.
    ///
    /// - Parameters:
    ///   - htmlString: The HTML string to load in the web view.
    ///   - htmlBaseUrl: The base URL for resolving relative paths in the HTML string.
    ///   - wkConfiguration: A closure to configure the `WKWebViewConfiguration`.
    ///   - wkViewConfiguration: A closure to configure the `WKWebView`.
    public init(
        htmlString: String,
        htmlBaseUrl: URL? = nil,
        wkConfiguration: ((inout WKWebViewConfiguration) -> Void)? = nil,
        wkViewConfiguration: ((WKWebView) -> Void)? = nil
    ) {
        self.url = nil
        self.htmlString = htmlString
        self.htmlBaseUrl = htmlBaseUrl
        self.type = .advanced

        #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
        self.sfConfigurationClosure = nil
        self.sfViewConfiguration = nil
        #endif

        self.wkConfigurationClosure = wkConfiguration
        self.wkViewConfiguration = wkViewConfiguration
    }
}

// MARK: - Body view
extension WebView: View {

    /// A view that presents a web view based on the type of `WebView`.
    ///
    /// This computed property returns a `Group` containing either:
    /// - A `SafariWebView` if the `type` is `.simple`, and a `url` is provided.
    /// - A `WebKitWebView` if the `type` is `.advanced`, with options to load either a URL or
    /// HTML content.
    ///
    /// - Returns: A `View` that displays web content based on the `WebViewType` and provided
    /// configurations.
    public var body: some View {
        Group {
            switch type {

                #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
                case .simple:
                    if let url = url {
                        SafariWebView(
                            url: url,
                            configurationClosure: sfConfigurationClosure,
                            viewConfiguration: sfViewConfiguration
                        )
                    }
                #endif

                case .advanced:
                    WebKitWebView(
                        url: url,
                        htmlString: htmlString,
                        htmlBaseUrl: htmlBaseUrl,
                        configurationClosure: wkConfigurationClosure,
                        viewConfiguration: wkViewConfiguration
                    )
            }
        }
    }
}

#endif
