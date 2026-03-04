# FAPopView

A customizable SwiftUI popover component for macOS with precise arrow alignment.

![macOS 14.0+](https://img.shields.io/badge/macOS-14.0%2B-blue)
![Swift 5.9+](https://img.shields.io/badge/Swift-5.9%2B-orange)
![License MIT](https://img.shields.io/badge/License-MIT-green)

## Features

- 🎯 **Smart Positioning** - Automatic direction selection based on available screen space
- 📍 **Precise Arrow** - Arrow always points exactly to the trigger button center
- 📋 **List Mode** - Built-in support for selectable item lists
- 🎨 **Customizable** - Fully configurable via `FAPopViewConfiguration`
- 🌙 **Themes** - Dark and light theme presets included
- 🔧 **Builder Pattern** - Easy chaining for configuration

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Charles2016/FAPopView.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** → paste the URL.

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'FAPopView', '~> 1.0'
```

Then run `pod install`.

## Quick Start

### 1. Enable PopView Support

Add `.withPopViewSupport()` to your root view:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withPopViewSupport()  // ← Required!
        }
    }
}
```

### 2. Use FAPopView

#### List-based Popover

```swift
let items = [
    PopViewItem(title: "Edit", icon: "pencil"),
    PopViewItem(title: "Share", icon: "square.and.arrow.up"),
    PopViewItem(title: "Delete", subtitle: "Remove permanently", icon: "trash")
]

FAPopView(items: items, onSelect: { item in
    print("Selected: \(item.title)")
}) {
    Button("Options") {}
}
```

#### Custom Content Popover

```swift
FAPopView {
    Button("Show Info") {}
} content: {
    VStack(alignment: .leading, spacing: 8) {
        Text("Custom Popover")
            .font(.headline)
        Text("Any SwiftUI content works here!")
            .foregroundColor(.secondary)
    }
    .padding()
}
```

#### Using the Modifier

```swift
@State private var showPopover = false

Button("Click Me") {
    showPopover.toggle()
}
.faPopover(isPresented: $showPopover) {
    Text("Hello from popover!")
        .padding()
}
```

## Configuration

### Using Presets

```swift
// Dark theme (default)
FAPopView(items: items, config: .dark) { ... }

// Light theme
FAPopView(items: items, config: .light) { ... }
```

### Custom Configuration

```swift
let config = FAPopViewConfiguration.dark
    .width(300)
    .cornerRadius(16)
    .direction(.bottom)
    .itemHeight(56)

FAPopView(items: items, config: config) { ... }
```

### Full Customization

```swift
let config = FAPopViewConfiguration(
    backgroundColor: .blue.opacity(0.9),
    hoverColor: .blue.opacity(0.7),
    borderColor: .white.opacity(0.2),
    titleFont: .system(size: 16, weight: .bold),
    titleColor: .white,
    popViewWidth: 280,
    cornerRadius: 16,
    preferredDirection: .right
)
```

## API Reference

### PopViewItem

```swift
PopViewItem(
    title: String,
    subtitle: String? = nil,
    icon: String? = nil  // SF Symbol name
)
```

### FAPopViewConfiguration Properties

| Property | Type | Default |
|----------|------|---------|
| `backgroundColor` | `Color` | Dark gray |
| `hoverColor` | `Color` | Darker gray |
| `borderColor` | `Color` | White 10% |
| `titleFont` | `Font` | System 14 medium |
| `titleColor` | `Color` | White |
| `subtitleFont` | `Font` | System 12 |
| `subtitleColor` | `Color` | White 70% |
| `itemHeight` | `CGFloat` | 48 |
| `popViewWidth` | `CGFloat` | 250 |
| `cornerRadius` | `CGFloat` | 12 |
| `preferredDirection` | `PopViewDirection?` | nil (auto) |

### PopViewDirection

- `.top` - Popover appears above, arrow points down
- `.bottom` - Popover appears below, arrow points up
- `.left` - Popover appears left, arrow points right
- `.right` - Popover appears right, arrow points left

## Requirements

- macOS 14.0+
- Swift 5.9+
- Xcode 15.0+

## License

MIT License. See [LICENSE](LICENSE) for details.

## Author

Charles - [@Charles2016](https://github.com/Charles2016)
