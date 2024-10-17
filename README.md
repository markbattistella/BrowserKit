<!-- markdownlint-disable MD033 MD041 MD052 -->
<div align="center">

# BrowserKit

[![Swift Version][Shield1]](https://swiftpackageindex.com/markbattistella/BrowserKit)

[![OS Platforms][Shield2]](https://swiftpackageindex.com/markbattistella/BrowserKit)

[![Licence][Shield3]](https://github.com/markbattistella/BrowserKit/blob/main/LICENSE)

</div>

`BrowserKit` is a Swift package that provides a simple and flexible way to integrate web views into your iOS, macOS, and visionOS applications. It supports both `SFSafariViewController` for seamless web browsing on iOS and `WKWebView` for custom web content handling across platforms.

## Features

- **Cross-Platform Support:** Works with iOS, macOS, visionOS, and Catalyst.
- **Safari and WebKit Integration:** Choose between `SFSafariViewController` for a native browsing experience or `WKWebView` for custom web content.
- **Customisable Configurations:** Easily configure both Safari and WebKit views with flexible closures.
- **HTML String Loading:** Load HTML content directly into a WKWebView with optional base URLs.

## Installation

### Swift Package Manager

To add `BrowserKit` to your project, use the Swift Package Manager.

1. Open your project in Xcode.
1. Go to `File > Add Packages`.
1. In the search bar, enter the URL of the `BrowserKit` repository:
  
    ```url
    https://github.com/markbattistella/BrowserKit
    ```

1. Click `Add Package`.

## Usage

### Basic Example

#### Loading a URL with Safari

You can load a URL using `SFSafariViewController` on iOS, visionOS, and Catalyst platforms:

```swift
import BrowserKit

struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://markbattistella.com")!)
    }
}
```

#### Loading a URL with WebKit

For custom web content handling, you can use `WKWebView` on any platform:

```swift
import BrowserKit

struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://markbattistella.com")!, webKitConfiguration: { config in
            config.preferences.javaScriptEnabled = true
        }, webViewConfiguration: { webView in
            webView.navigationDelegate = self // Set your custom navigation delegate
        })
    }
}
```

#### Loading HTML Content

You can also load raw HTML content into a `WKWebView`:

```swift
import BrowserKit

struct ContentView: View {
    var body: some View {
        WebView(htmlString: "<html><body><h1>Hello, World!</h1></body></html>")
    }
}
```

## Customisation

### Safari Configuration

You can customise the Safari view controller's configuration with the `safariConfiguration` closure:

```swift
WebView(url: URL(string: "https://www.example.com")!) { sfConfiguration in
    sfConfiguration.entersReaderIfAvailable = true
}
```

### WebKit Configuration

You can also customise the `WKWebViewConfiguration` or the `WKWebView` itself:

```swift
WebView(
    url: URL(string: "https://www.example.com")!,
    webKitConfiguration: { wkConfig in
        wkConfig.allowsInlineMediaPlayback = true
    },
    webViewConfiguration: { webView in
        webView.customUserAgent = "MyCustomUserAgent"
    }
)
```

## Contributing

Contributions are welcome! If you have suggestions or improvements, please fork the repository and submit a pull request.

## License

`BrowserKit` is released under the MIT license. See LICENSE for details.

[Shield1]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FBrowserKit%2Fbadge%3Ftype%3Dswift-versions

[Shield2]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FBrowserKit%2Fbadge%3Ftype%3Dplatforms

[Shield3]: https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat
