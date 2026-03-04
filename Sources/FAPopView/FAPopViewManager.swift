//
//  FAPopViewManager.swift
//  FAPopView
//
//  Global state manager for popview display coordination
//

import SwiftUI

// MARK: - PopView Manager

/// Manages global popview state and coordinates between multiple popview instances
@Observable
@MainActor
public final class FAPopViewManager {
    // MARK: - Properties

    /// Whether the background overlay is currently visible
    public var isShowingBackground = false

    /// The current popview content to display
    public var popViewContent: AnyView?

    /// The absolute position of the popview in global coordinates
    public var popViewOffset: CGPoint = .zero

    /// The direction the popview arrow is pointing
    public var popViewDirection: PopViewDirection = .bottom

    // MARK: - Singleton

    /// Shared instance of the popover manager
    public static let shared = FAPopViewManager()

    private init() {}

    // MARK: - Public Methods

    /// Shows the background overlay
    public func showBackground() {
        isShowingBackground = true
    }

    /// Hides the background overlay and dismisses all popviews
    public func hideBackground() {
        guard isShowingBackground else { return }

        isShowingBackground = false
        popViewContent = nil

        NotificationCenter.default.post(name: .dismissAllPopViews, object: nil)
    }

    /// Shows a popview with the specified content, position, and direction
    /// - Parameters:
    ///   - content: The view content to display in the popview
    ///   - offset: The absolute position in global coordinates
    ///   - direction: The direction the arrow should point
    public func showPopView<Content: View>(
        content: Content,
        offset: CGPoint,
        direction: PopViewDirection
    ) {
        showBackground()
        self.popViewContent = AnyView(content)
        self.popViewOffset = offset
        self.popViewDirection = direction
    }
    
    /// Dismiss the current popview
    public func dismiss() {
        hideBackground()
    }
}
