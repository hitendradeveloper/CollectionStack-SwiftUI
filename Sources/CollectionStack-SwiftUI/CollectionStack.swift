//
//  CollectionStack.swift
//  CollectionStack-SwiftUI
//
//  Created by Hitendra Solanki on 02/02/2023.
//  Twitter: @hitendrahckr - Medium: @hitendrahckr
//  Copyright © 2023 by Hitendra Solanki. All rights reserved.
//

import SwiftUI

public struct CollectionStack<Data, ID, Content>: View
where Data : RandomAccessCollection, Data.Element : Identifiable, ID : Hashable, ID == Data.Element.ID, Content : View
{
	
	/// The collection of underlying identified data that CollectionStack uses to create
	/// views dynamically.
	private var data: Data

	/// A function to create content on demand using the underlying data.
	private var content: (Data.Element) -> Content
	
	@State
	private var totalHeight = CGFloat.zero
	
	public var body: some View { bodyWithoutModifiers() }
	
	
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
	
}

fileprivate extension CollectionStack {
	func isLast(element: Data.Element) -> Bool {
		self.data.last?.id == element.id
	}
}

fileprivate extension CollectionStack {
	@ViewBuilder
	func bodyWithoutModifiers() -> some View {
		VStack {
			GeometryReader { geometry in
				self.generateContent(in: geometry)
			}
		}
		.frame(height: totalHeight)
	}
	
	@ViewBuilder
	func generateContent(in proxy: GeometryProxy) -> some View {
		var width = CGFloat.zero
		var height = CGFloat.zero
		ZStack(alignment: .topLeading) {
			ForEach(self.data) { elementValue in
				content(elementValue)
					.alignmentGuide(.leading, computeValue: { dimention in
						if (abs(width - dimention.width) > proxy.size.width) {
							width = 0
							height -= dimention.height
						}
						let result = width
						if self.isLast(element: elementValue) {
							width = 0
						} else {
							width -= dimention.width
						}
						return result
					})
					.alignmentGuide(.top, computeValue: { _ in
						let result = height
						if self.isLast(element: elementValue) {
							height = 0
						}
						return result
					})
			}
		}.background(viewHeightUpdatingClearBackground($totalHeight))
	}

	@ViewBuilder
	func viewHeightUpdatingClearBackground(_ binding: Binding<CGFloat>) -> some View {
		GeometryReader { geometry -> Color in
			let rect = geometry.frame(in: .local)
			DispatchQueue.main.async {
				binding.wrappedValue = rect.size.height
			}
			return .clear
		}
	}
}
