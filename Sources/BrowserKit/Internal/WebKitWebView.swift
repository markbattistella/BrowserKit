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

    /// Stores the last loaded content so SwiftUI updates only reload the web view when the requested
    /// content actually changes.
    internal final class Coordinator {

      fileprivate var loadedContent: WebContent?
    }

    /// Creates the coordinator used to track loaded content across representable updates.
    ///
    /// - Returns: A coordinator scoped to this representable instance.
    internal func makeCoordinator() -> Coordinator {
      Coordinator()
    }

    #if os(macOS)

      /// Creates the WebKit-based view for macOS (`NSView`).
      ///
      /// - Parameter context: The context in which the view is created.
      /// - Returns: A fully configured `WKWebView` ready to present content.
      internal func makeNSView(context: Context) -> WKWebView {
        let webView = makeWebView()
        loadContentIfNeeded(into: webView, coordinator: context.coordinator)
        return webView
      }

      /// Updates the WebKit view on macOS when the SwiftUI view's state changes.
      ///
      /// This function reloads the macOS WebKit view when the requested URL or HTML content changes.
      ///
      /// - Parameters:
      ///   - nsView: The WebKit view (`WKWebView`) to update.
      ///   - context: The context in which the update occurs.
      internal func updateNSView(_ nsView: WKWebView, context: Context) {
        loadContentIfNeeded(into: nsView, coordinator: context.coordinator)
      }

    #else

      /// Creates the WebKit-based view for iOS, visionOS, or Catalyst (`UIView`).
      ///
      /// - Parameter context: The context in which the view is created.
      /// - Returns: A fully configured `WKWebView` ready to present content.
      internal func makeUIView(context: Context) -> WKWebView {
        let webView = makeWebView()
        loadContentIfNeeded(into: webView, coordinator: context.coordinator)
        return webView
      }

      /// Updates the WebKit view on iOS, visionOS, or Catalyst when the SwiftUI view's state changes.
      ///
      /// This function allows for updates to the iOS, visionOS, or Catalyst WebKit view when the
      /// requested URL or HTML content changes.
      ///
      /// - Parameters:
      ///   - uiView: The WebKit view (`WKWebView`) to update.
      ///   - context: The context in which the update occurs.
      internal func updateUIView(_ uiView: WKWebView, context: Context) {
        loadContentIfNeeded(into: uiView, coordinator: context.coordinator)
      }

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
      return webView
    }

    /// Loads changed content into the provided `WKWebView`, either from a URL or an HTML string.
    ///
    /// If a URL is available, it loads the web page. If an HTML string is provided, it loads the HTML
    /// content. Repeated SwiftUI updates with the same content are ignored to avoid needless reloads.
    ///
    /// - Parameter webView: The `WKWebView` instance to load content into.
    /// - Parameter coordinator: The coordinator tracking the last loaded content.
    private func loadContentIfNeeded(into webView: WKWebView, coordinator: Coordinator) {
      guard let content else {
        return
      }

      guard content != coordinator.loadedContent else {
        return
      }

      switch content {
      case .url(let url):
        webView.load(URLRequest(url: url))

      case .html(let htmlString, let baseURL):
        webView.loadHTMLString(htmlString, baseURL: baseURL)
      }

      coordinator.loadedContent = content
    }

    /// The current content requested by this SwiftUI value.
    private var content: WebContent? {
      if let url {
        .url(url)
      } else if let htmlString {
        .html(htmlString, baseURL: htmlBaseUrl)
      } else {
        nil
      }
    }

    /// Comparable web content requests used to avoid reloads when SwiftUI updates without changing
    /// the requested content.
    fileprivate enum WebContent: Equatable {

      case url(URL)
      case html(String, baseURL: URL?)
    }
  }

#endif
