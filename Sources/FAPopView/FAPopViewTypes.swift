//
//  FAPopViewTypes.swift
//  FAPopView
//
//  Core types and models for FAPopView
//

import SwiftUI

// MARK: - Direction

/// Direction for popview arrow and content placement
public enum PopViewDirection: Sendable {
    case top, bottom, left, right

    /// Whether this direction is vertical (top or bottom)
    public var isVertical: Bool {
        self == .top || self == .bottom
    }

    /// Returns the opposite direction
    public var opposite: PopViewDirection {
        switch self {
        case .top: return .bottom
        case .bottom: return .top
        case .left: return .right
        case .right: return .left
        }
    }
}

// MARK: - Arrow Direction

/// Arrow pointing direction for shapes
public enum ArrowDirection: Sendable {
    case up, down, left, right
}

// MARK: - PopView Item

/// Model representing a selectable item in a list-style popview
public struct PopViewItem: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let subtitle: String?
    public let icon: String?

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        icon: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}

// MARK: - Notification Names

public extension Notification.Name {
    /// Notification sent when all popviews should be dismissed
    static let dismissAllPopViews = Notification.Name("FAPopView.dismissAll")
}
