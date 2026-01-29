//
//  FAPopViewConfiguration.swift
//  FAPopView
//
//  Configuration struct for FAPopView styling and behavior
//

import SwiftUI

// MARK: - Configuration

/// Configuration for FAPopView appearance and behavior
public struct FAPopViewConfiguration {
    // MARK: - Colors
    public var backgroundColor: Color
    public var hoverColor: Color
    public var borderColor: Color
    
    // MARK: - Typography
    public var titleFont: Font
    public var titleColor: Color
    public var subtitleFont: Font
    public var subtitleColor: Color
    
    // MARK: - Layout
    public var itemHeight: CGFloat
    public var popViewWidth: CGFloat
    public var itemAlignment: HorizontalAlignment
    public var dividerPadding: CGFloat
    public var dividerOnlyBeforeLastItem: Bool
    
    // MARK: - Shape
    public var cornerRadius: CGFloat
    public var borderWidth: CGFloat
    public var arrowWidth: CGFloat
    public var arrowHeight: CGFloat
    public var arrowSpacing: CGFloat
    
    // MARK: - Shadow
    public var shadowColor1: Color
    public var shadowRadius1: CGFloat
    public var shadowColor2: Color
    public var shadowRadius2: CGFloat
    public var shadowOffsetY2: CGFloat
    
    // MARK: - Behavior
    public var preferredDirection: PopViewDirection?
    
    // MARK: - Presets
    
    /// Default dark theme configuration
    public static let dark = FAPopViewConfiguration(
        backgroundColor: Color(nsColor: NSColor(red: 0.063, green: 0.082, blue: 0.094, alpha: 0.98)),
        hoverColor: Color(nsColor: NSColor(red: 0.051, green: 0.071, blue: 0.082, alpha: 1.0)),
        borderColor: Color.white.opacity(0.1),
        titleFont: .system(size: 14, weight: .medium),
        titleColor: .white,
        subtitleFont: .system(size: 12),
        subtitleColor: Color.white.opacity(0.7),
        itemHeight: 48,
        popViewWidth: 250,
        itemAlignment: .center,
        dividerPadding: 0,
        dividerOnlyBeforeLastItem: false,
        cornerRadius: 12,
        borderWidth: 1,
        arrowWidth: 16,
        arrowHeight: 10,
        arrowSpacing: 2,
        shadowColor1: Color.black.opacity(0.25),
        shadowRadius1: 6,
        shadowColor2: Color.black.opacity(0.5),
        shadowRadius2: 24,
        shadowOffsetY2: 6,
        preferredDirection: nil
    )
    
    /// Light theme configuration
    public static let light = FAPopViewConfiguration(
        backgroundColor: Color(nsColor: NSColor(red: 1, green: 1, blue: 1, alpha: 0.98)),
        hoverColor: Color(nsColor: NSColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)),
        borderColor: Color.black.opacity(0.1),
        titleFont: .system(size: 14, weight: .medium),
        titleColor: .primary,
        subtitleFont: .system(size: 12),
        subtitleColor: Color.primary.opacity(0.7),
        itemHeight: 48,
        popViewWidth: 250,
        itemAlignment: .center,
        dividerPadding: 0,
        dividerOnlyBeforeLastItem: false,
        cornerRadius: 12,
        borderWidth: 1,
        arrowWidth: 16,
        arrowHeight: 10,
        arrowSpacing: 2,
        shadowColor1: Color.black.opacity(0.1),
        shadowRadius1: 6,
        shadowColor2: Color.black.opacity(0.2),
        shadowRadius2: 24,
        shadowOffsetY2: 6,
        preferredDirection: nil
    )
    
    /// Default configuration (dark theme)
    public static let `default` = dark
    
    // MARK: - Initializer
    
    public init(
        backgroundColor: Color = Color(nsColor: NSColor(red: 0.063, green: 0.082, blue: 0.094, alpha: 0.98)),
        hoverColor: Color = Color(nsColor: NSColor(red: 0.051, green: 0.071, blue: 0.082, alpha: 1.0)),
        borderColor: Color = Color.white.opacity(0.1),
        titleFont: Font = .system(size: 14, weight: .medium),
        titleColor: Color = .white,
        subtitleFont: Font = .system(size: 12),
        subtitleColor: Color = Color.white.opacity(0.7),
        itemHeight: CGFloat = 48,
        popViewWidth: CGFloat = 250,
        itemAlignment: HorizontalAlignment = .center,
        dividerPadding: CGFloat = 0,
        dividerOnlyBeforeLastItem: Bool = false,
        cornerRadius: CGFloat = 12,
        borderWidth: CGFloat = 1,
        arrowWidth: CGFloat = 16,
        arrowHeight: CGFloat = 10,
        arrowSpacing: CGFloat = 2,
        shadowColor1: Color = Color.black.opacity(0.25),
        shadowRadius1: CGFloat = 6,
        shadowColor2: Color = Color.black.opacity(0.5),
        shadowRadius2: CGFloat = 24,
        shadowOffsetY2: CGFloat = 6,
        preferredDirection: PopViewDirection? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.hoverColor = hoverColor
        self.borderColor = borderColor
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.subtitleFont = subtitleFont
        self.subtitleColor = subtitleColor
        self.itemHeight = itemHeight
        self.popViewWidth = popViewWidth
        self.itemAlignment = itemAlignment
        self.dividerPadding = dividerPadding
        self.dividerOnlyBeforeLastItem = dividerOnlyBeforeLastItem
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.arrowWidth = arrowWidth
        self.arrowHeight = arrowHeight
        self.arrowSpacing = arrowSpacing
        self.shadowColor1 = shadowColor1
        self.shadowRadius1 = shadowRadius1
        self.shadowColor2 = shadowColor2
        self.shadowRadius2 = shadowRadius2
        self.shadowOffsetY2 = shadowOffsetY2
        self.preferredDirection = preferredDirection
    }
}

// MARK: - Builder Pattern

public extension FAPopViewConfiguration {
    /// Returns a copy with modified background color
    func backgroundColor(_ color: Color) -> FAPopViewConfiguration {
        var config = self
        config.backgroundColor = color
        return config
    }
    
    /// Returns a copy with modified hover color
    func hoverColor(_ color: Color) -> FAPopViewConfiguration {
        var config = self
        config.hoverColor = color
        return config
    }
    
    /// Returns a copy with modified corner radius
    func cornerRadius(_ radius: CGFloat) -> FAPopViewConfiguration {
        var config = self
        config.cornerRadius = radius
        return config
    }
    
    /// Returns a copy with modified pop view width
    func width(_ width: CGFloat) -> FAPopViewConfiguration {
        var config = self
        config.popViewWidth = width
        return config
    }
    
    /// Returns a copy with modified preferred direction
    func direction(_ direction: PopViewDirection?) -> FAPopViewConfiguration {
        var config = self
        config.preferredDirection = direction
        return config
    }
    
    /// Returns a copy with modified item height
    func itemHeight(_ height: CGFloat) -> FAPopViewConfiguration {
        var config = self
        config.itemHeight = height
        return config
    }
    
    /// Returns a copy with modified item alignment
    func itemAlignment(_ alignment: HorizontalAlignment) -> FAPopViewConfiguration {
        var config = self
        config.itemAlignment = alignment
        return config
    }
}

// MARK: - Layout Constants

/// Internal layout constants
public enum FAPopViewLayout {
    public static let screenPadding: CGFloat = 10
    public static let screenMargin: CGFloat = 10
    public static let itemVerticalPadding: CGFloat = 16
}
