//
//  FAPopViewHelpers.swift
//  FAPopView
//
//  Helper modifiers and extensions
//

import SwiftUI

// MARK: - Size Reader Modifier

/// ViewModifier to read and bind the height of a view
public struct SizeReaderModifier: ViewModifier {
    @Binding var size: CGFloat

    public init(size: Binding<CGFloat>) {
        self._size = size
    }

    public func body(content: Content) -> some View {
        content
            .background(GeometryReader { geo in
                Color.clear
                    .onAppear {
                        size = geo.size.height
                    }
                    .onChange(of: geo.size.height, initial: false) { _, newHeight in
                        size = newHeight
                    }
            })
    }
}

// MARK: - Conditional Modifier

public extension View {
    /// Applies a transformation if the condition is true
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
