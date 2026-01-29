//
//  FAPopViewItemRow.swift
//  FAPopView
//
//  Single item row component for FAPopView list mode
//

import SwiftUI

// MARK: - PopView Item Row

/// A single row in a list-style FAPopView
public struct FAPopViewItemRow: View {
    @State private var isHovering = false

    let item: PopViewItem
    let config: FAPopViewConfiguration
    let itemIndex: Int
    let totalItemCount: Int
    let onSelect: () -> Void
    let direction: PopViewDirection
    let arrowOffset: CGFloat
    let onHoverChange: (Bool) -> Void

    public init(
        item: PopViewItem,
        config: FAPopViewConfiguration,
        itemIndex: Int,
        totalItemCount: Int,
        direction: PopViewDirection,
        arrowOffset: CGFloat,
        onSelect: @escaping () -> Void,
        onHoverChange: @escaping (Bool) -> Void
    ) {
        self.item = item
        self.config = config
        self.itemIndex = itemIndex
        self.totalItemCount = totalItemCount
        self.direction = direction
        self.arrowOffset = arrowOffset
        self.onSelect = onSelect
        self.onHoverChange = onHoverChange
    }

    private var isFirstItem: Bool { itemIndex == 0 }
    private var isLastItem: Bool { itemIndex == totalItemCount - 1 }
    private var isSecondToLastItem: Bool { itemIndex == totalItemCount - 2 }

    public var body: some View {
        VStack(spacing: 0) {
            Button(action: onSelect) {
                HStack(spacing: 12) {
                    if let icon = item.icon {
                        Image(systemName: icon)
                            .font(.system(size: 14))
                            .foregroundColor(config.titleColor)
                    }

                    VStack(
                        alignment: alignmentToLeadingTrailing(config.itemAlignment),
                        spacing: 2
                    ) {
                        Text(item.title)
                            .font(config.titleFont)
                            .foregroundColor(config.titleColor)
                            .lineLimit(1)
                            .truncationMode(.tail)

                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .font(config.subtitleFont)
                                .foregroundColor(config.subtitleColor)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
                .frame(height: config.itemHeight)
                .frame(maxWidth: .infinity, alignment: alignmentToAlignment(config.itemAlignment))
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .background(hoverBackground)
            .buttonStyle(PlainButtonStyle())
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovering = hovering
                }
                onHoverChange(hovering)
            }

            // Divider
            if shouldShowDivider {
                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.horizontal, config.dividerPadding)
            }
        }
    }

    // MARK: - Private Helpers

    private var shouldShowDivider: Bool {
        if config.dividerOnlyBeforeLastItem {
            return isSecondToLastItem
        } else {
            return !isLastItem
        }
    }

    @ViewBuilder
    private var hoverBackground: some View {
        if isHovering {
            if isFirstItem {
                FACustomRoundedRectangle(
                    topLeft: config.cornerRadius,
                    topRight: config.cornerRadius,
                    bottomLeft: 0,
                    bottomRight: 0
                )
                .fill(config.hoverColor)
            } else if isLastItem {
                FACustomRoundedRectangle(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: config.cornerRadius,
                    bottomRight: config.cornerRadius
                )
                .fill(config.hoverColor)
            } else {
                Rectangle()
                    .fill(config.hoverColor)
            }
        } else {
            Color.clear
        }
    }

    private func alignmentToLeadingTrailing(_ alignment: HorizontalAlignment) -> HorizontalAlignment {
        alignment
    }

    private func alignmentToAlignment(_ alignment: HorizontalAlignment) -> Alignment {
        switch alignment {
        case .leading: return .leading
        case .trailing: return .trailing
        default: return .center
        }
    }
}
