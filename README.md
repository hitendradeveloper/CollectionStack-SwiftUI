# CollectionStack-SwiftUI

**CollectionStack is designed to solve limitation of HStack and VStack in SwiftU, it grows horizontally first, then vertically if next element could not fit horizontally.** 

## CollectionStack
> is generic SwiftUI View over data and content

## Data
> The collection of underlying identified data that CollectionStack uses to create views dynamically.

## Content
> A function to create content on demand using the underlying data. It's a mapper function which maps Data to some View.

##Public API is consistent same as ForEach of SwiftUI
```swift
/// Creates an instance that uniquely identifies and creates views across
/// updates based on the identity of the underlying data.
///
/// It's important that the `id` of a data element doesn't change unless you
/// replace the data element with a new data element that has a new
/// identity. If the `id` of a data element changes, the content view
/// generated from that data element loses any current state and animations.
///
/// - Parameters:
///   - data: The identified data that the ``CollectionStack`` instance uses to
///     create views dynamically.
///   - content: The view builder that creates views dynamically.

public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
	self.data = data
	self.content = content
}
```


```swift
	struct App: Identifiable {
		var name: String
		var id: String { return name }
	}
	
	let apps: [App] = [
		"youtube", "podcast", "twitter",
		"facebook", "instagram",
		"free form", "github desktop", "source tree"
	].map(App.init(name: ))
					
	//you can wrap this CollectionStack into ScrollView as well if you want scrolling				
	CollectionStack(apps) { app in
		Button {
			print("Selected tag := \(app.name)")
		} label: {
			Text(app.name)
				.font(.system(.callout, design: .rounded, weight: .regular))
		}
		.buttonStyle(.bordered)
		.padding(.trailing, 8)
		.padding(.bottom, 8)
	}
```

## Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 13.0+ | 5.0 | [Swift Package Manager](#swift-package-manager), [Manual](#manually) | Fully Tested |
| macOS 10.15+ | 5.0 | [Swift Package Manager](#swift-package-manager), [Manual](#manually) | Fully Tested |
| tvOS 13.0+ | 5.0 | [Swift Package Manager](#swift-package-manager), [Manual](#manually) | Fully Tested |
| watchOS 6.0+ | 5.0 | [Swift Package Manager](#swift-package-manager), [Manual](#manually) | Fully Tested |

### Swift Package Manager

The  [Swift Package Manager](https://swift.org/package-manager/)  is a tool for automating the distribution of Swift code and is integrated into the  `swift`  compiler.

Once you have your Swift package set up, adding CollectionStack-SwiftUI as a dependency is as easy as adding it to the  `dependencies`  value of your  `Package.swift`.

```
dependencies: [
    .package(url: "https://github.com/hitendradeveloper/CollectionStack-SwiftUI.git", .upToNextMajor(from: "1.0.0"))
]
```

## License

CollectionStack-SwiftUI is released under the MIT license.
