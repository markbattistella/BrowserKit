<!-- markdownlint-disable MD033 MD041 MD052 -->
<div align="center">

# BrowserKit

[![Swift Version][Shield1]](https://swiftpackageindex.com/markbattistella/BrowserKit)

[![OS Platforms][Shield2]](https://swiftpackageindex.com/markbattistella/BrowserKit)

[![Licence][Shield3]](https://github.com/markbattistella/BrowserKit/blob/main/LICENSE)

</div>

`BrowserKit` is a Swift package that provides a simple and flexible way to integrate web views into your iOS, macOS, Mac Catalyst, and visionOS applications. It supports both `SFSafariViewController` for seamless browsing on iOS, Mac Catalyst, and visionOS, and `WKWebView` for custom web content across all supported platforms.

---

## Important Notice: `WebView` Renamed to `BrowserView`

With OS 26, Apple introduced native SwiftUI web view types that can collide with packages that also expose a `WebView` symbol. To avoid namespace collisions:

- The BrowserKit view type is now named **`BrowserView`**
- You should **update all usage of `WebView` → `BrowserView`**

### Migration Example

```swift
// Old
WebView(url: URL(string: "https://example.com")!)

// New
BrowserView(url: URL(string: "https://example.com")!)
```

## Features

- **Cross-Platform Support:** Works with iOS, macOS, Mac Catalyst, and visionOS.
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

Or add it to your package manifest:

```swift
dependencies: [
    .package(url: "https://github.com/markbattistella/BrowserKit", from: "26.0.0")
]
```

## Requirements

- Swift 6.0+
- iOS 13+
- macOS 10.15+
- Mac Catalyst 13.1+
- visionOS 1+

## Usage

### Basic Example

#### Loading a URL

You can load a URL using the platform default. On iOS, Mac Catalyst, and visionOS this uses `SFSafariViewController`; on macOS this uses `WKWebView`.

```swift
import BrowserKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        BrowserView(url: URL(string: "https://markbattistella.com")!)
    }
}
```

#### Loading a URL with WebKit

For custom web content handling, you can use `WKWebView` on any platform:

```swift
import BrowserKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        BrowserView(
            url: URL(string: "https://markbattistella.com")!,
            webKitConfiguration: { configuration in
                configuration.websiteDataStore = .default()
            },
            webViewConfiguration: { webView in
                webView.customUserAgent = "MyApp/1.0"
            }
        )
    }
}
```

#### Loading HTML Content

You can also load raw HTML content into a `WKWebView`:

```swift
import BrowserKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        BrowserView(htmlString: "<html><body><h1>Hello, World!</h1></body></html>")
    }
}
```

## Customisation

### Safari Configuration

You can customise the Safari view controller's configuration with the `safariConfiguration` closure on iOS, Mac Catalyst, and visionOS:

```swift
BrowserView(url: URL(string: "https://markbattistella.com")!) { sfConfiguration in
    sfConfiguration.entersReaderIfAvailable = true
}
```

### WebKit Configuration

You can also customise the `WKWebViewConfiguration` or the `WKWebView` itself:

```swift
BrowserView(
    url: URL(string: "https://markbattistella.com")!,
    webKitConfiguration: { configuration in
        configuration.websiteDataStore = .default()
    },
    webViewConfiguration: { webView in
        webView.customUserAgent = "MyApp/1.0"
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
