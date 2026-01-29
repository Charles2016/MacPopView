//
//  FAPopViewEnvironment.swift
//  FAPopView
//
//  Environment values and support modifiers
//

import SwiftUI

// MARK: - Public View Extension

public extension View {
    /// Adds PopView support to the view hierarchy.
    ///
    /// Call this once at your app's root view to enable FAPopView throughout your app.
    ///
    /// Usage:
    /// ```swift
    /// WindowGroup {
    ///     ContentView()
    ///         .withPopViewSupport()
    /// }
    /// ```
    func withPopViewSupport() -> some View {
        modifier(FAPopViewSupportModifier())
    }
}

// MARK: - Support Modifier

private struct FAPopViewSupportModifier: ViewModifier {
    @Environment(\.faPopViewSupportEnabled) var isEnabled

    func body(content: Content) -> some View {
        if isEnabled {
            content
        } else {
            ZStack {
                content
                FAGlobalPopViewBackground()
            }
            .background(GeometryReader { geo in
                Color.clear.preference(key: FAPopViewWindowSizeKey.self, value: geo.size)
            })
            .onPreferenceChange(FAPopViewWindowSizeKey.self) { _ in }
            .modifier(FAPopViewScreenTrackerModifier())
            .coordinateSpace(name: "global")
            .environment(\.faPopViewSupportEnabled, true)
        }
    }
}

// MARK: - Screen Tracker Modifier

private struct FAPopViewScreenTrackerModifier: ViewModifier {
    @State private var screenSize: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(FAPopViewWindowSizeKey.self) { size in
                screenSize = size
            }
            .environment(\.faPopViewScreenSize, screenSize)
            .background(GeometryReader { geo in
                Color.clear.onChange(of: geo.size, initial: true) { _, newSize in
                    screenSize = newSize
                }
            })
    }
}

// MARK: - Preference Keys

struct FAPopViewWindowSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

/// PreferenceKey to pass preferredDirection from FAPopView to FAPopViewModifier
public struct PopViewDirectionPreferenceKey: PreferenceKey {
    public static var defaultValue: PopViewDirection?

    public static func reduce(value: inout PopViewDirection?, nextValue: () -> PopViewDirection?) {
        value = nextValue() ?? value
    }
}

/// PreferenceKey to pass popViewWidth from FAPopView to FAPopViewModifier
public struct PopViewSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize?

    public static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = nextValue() ?? value
    }
}

// MARK: - Environment Keys

struct FAPopViewScreenSizeEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

struct FAPopViewSupportEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

// MARK: - Environment Values

public extension EnvironmentValues {
    var faPopViewScreenSize: CGSize {
        get { self[FAPopViewScreenSizeEnvironmentKey.self] }
        set { self[FAPopViewScreenSizeEnvironmentKey.self] = newValue }
    }

    var faPopViewSupportEnabled: Bool {
        get { self[FAPopViewSupportEnabledKey.self] }
        set { self[FAPopViewSupportEnabledKey.self] = newValue }
    }
    
    var faPopViewContext: FAPopViewContext? {
        get { self[FAPopViewContextKey.self] }
        set { self[FAPopViewContextKey.self] = newValue }
    }
}

// MARK: - PopView Context

/// Context passed from the modifier to the popview content
public struct FAPopViewContext {
    public let direction: PopViewDirection
    public let arrowOffset: CGFloat
    
    public init(direction: PopViewDirection, arrowOffset: CGFloat) {
        self.direction = direction
        self.arrowOffset = arrowOffset
    }
}

struct FAPopViewContextKey: EnvironmentKey {
    static let defaultValue: FAPopViewContext? = nil
}
