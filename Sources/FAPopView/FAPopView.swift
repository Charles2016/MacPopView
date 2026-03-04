//
//  FAPopView.swift
//  FAPopView
//
//  Main FAPopView component with simplified API
//

import SwiftUI

// MARK: - FAPopView

/// A customizable popover component with precise arrow alignment
///
/// Features:
/// - Automatic direction selection based on available screen space
/// - Precise arrow alignment to button center
/// - Supports both list-based and custom content modes
/// - Configurable via FAPopViewConfiguration
///
/// Usage:
/// ```swift
/// // List-based popover
/// FAPopView(
///     items: [PopViewItem(title: "Option 1"), PopViewItem(title: "Option 2")],
///     onSelect: { item in print(item.title) }
/// ) {
///     Text("Click Me")
/// }
///
/// // Custom content popover
/// FAPopView {
///     Text("Trigger Button")
/// } content: {
///     VStack {
///         Text("Custom Content")
///     }
/// }
/// ```
public struct FAPopView<ButtonLabel: View, Content: View>: View {
    // MARK: - State

    @State private var showPopView = false
    @State private var buttonFrame = CGRect.zero
    @State private var screenSize = CGSize.zero
    @State private var popViewDirection: PopViewDirection = .bottom
    @State private var popViewHeight: CGFloat = 56
    @State private var arrowOffset: CGFloat = 0
    @State private var hoveringItemIndex: Int?
    @State private var measuredContentWidth: CGFloat?
    
    private var popViewManager = FAPopViewManager.shared
    @Environment(\.faPopViewContext) private var context

    // MARK: - Configuration

    private let button: () -> ButtonLabel
    private let content: () -> Content
    private let items: [PopViewItem]?
    private let config: FAPopViewConfiguration
    private let onItemSelect: (PopViewItem) -> Void

    // MARK: - Computed Properties

    private var effectiveDirection: PopViewDirection {
        context?.direction ?? popViewDirection
    }

    private var effectiveArrowOffset: CGFloat {
        context?.arrowOffset ?? arrowOffset
    }

    // MARK: - Initializers

    /// Creates a list-based popover
    /// - Parameters:
    ///   - items: Array of items to display
    ///   - config: Configuration for styling (default: .dark)
    ///   - onSelect: Callback when an item is selected
    ///   - button: View builder for the trigger button
    public init(
        items: [PopViewItem],
        config: FAPopViewConfiguration = .default,
        onSelect: @escaping (PopViewItem) -> Void = { _ in },
        @ViewBuilder button: @escaping () -> ButtonLabel
    ) where Content == EmptyView {
        self.items = items
        self.config = config
        self.onItemSelect = onSelect
        self.button = button
        self.content = { EmptyView() }
    }

    /// Creates a custom content popover
    /// - Parameters:
    ///   - config: Configuration for styling (default: .dark)
    ///   - button: View builder for the trigger button
    ///   - content: View builder for custom popover content
    public init(
        config: FAPopViewConfiguration = .default,
        @ViewBuilder button: @escaping () -> ButtonLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.items = nil
        self.config = config
        self.onItemSelect = { _ in }
        self.button = button
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if context != nil {
                // Content Mode: render visual popover only
                popViewForDirection()
                    .frame(width: config.popViewWidth)
            } else {
                // Wrapper Mode: handle button and popover management
                wrapperBody
            }
        }
    }

    // MARK: - Wrapper Body

    private var wrapperBody: some View {
        GeometryReader { screenGeo in
            VStack(spacing: 0) {
                Button(action: togglePopView) {
                    button()
                }
                .buttonStyle(PlainButtonStyle())
                .background(buttonFrameReader)

                Spacer()
            }
            .onAppear {
                screenSize = screenGeo.size
            }
            .onChange(of: screenGeo.size, initial: false) { _, newSize in
                screenSize = newSize
            }
            .onChange(of: popViewHeight, initial: false) { _, _ in
                updatePopViewIfShowing()
            }
            .onChange(of: hoveringItemIndex, initial: false) { _, _ in
                updatePopViewIfShowing()
            }
            .onReceive(NotificationCenter.default.publisher(for: .dismissAllPopViews)) { _ in
                showPopView = false
                popViewManager.hideBackground()
            }
        }
    }

    // MARK: - Button Frame Reader

    private var buttonFrameReader: some View {
        GeometryReader { buttonGeo in
            Color.clear
                .onAppear {
                    let frame = buttonGeo.frame(in: .named("global"))
                    guard frame != .zero else { return }
                    buttonFrame = frame
                }
                .onChange(of: buttonGeo.frame(in: .named("global"))) { _, newFrame in
                    guard newFrame != .zero else { return }
                    buttonFrame = newFrame
                    updatePopViewIfShowing()
                }
        }
    }

    // MARK: - Actions

    private func togglePopView() {
        withAnimation(.spring()) {
            showPopView.toggle()

            if showPopView {
                if popViewHeight > 0 {
                    popViewDirection = calculateBestDirection()
                    let position = calculatePopViewGlobalPosition()
                    let popoverView = popViewForDirection()
                        .frame(width: config.popViewWidth)
                    popViewManager.showPopView(
                        content: popoverView,
                        offset: position,
                        direction: popViewDirection
                    )
                }
            } else {
                popViewManager.hideBackground()
            }
        }
    }

    private func updatePopViewIfShowing() {
        guard showPopView else { return }
        
        let newDirection = calculateBestDirection()
        if newDirection != popViewDirection {
            popViewDirection = newDirection
        }
        
        let position = calculatePopViewGlobalPosition()
        let popoverView = popViewForDirection()
            .frame(width: config.popViewWidth)
        
        popViewManager.showPopView(
            content: popoverView,
            offset: position,
            direction: popViewDirection
        )
    }

    // MARK: - Direction Calculation

    private func calculateBestDirection() -> PopViewDirection {
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: buttonFrame,
            screenSize: screenSize,
            config: config,
            contentSize: CGSize(width: measuredContentWidth ?? config.popViewWidth, height: popViewHeight)
        )
        return calculator.bestDirection()
    }

    // MARK: - Position Calculation

    private func calculatePopViewGlobalPosition() -> CGPoint {
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: buttonFrame,
            screenSize: screenSize,
            config: config,
            contentSize: CGSize(width: measuredContentWidth ?? config.popViewWidth, height: popViewHeight)
        )
        let result = calculator.position(for: popViewDirection)
        arrowOffset = result.arrowOffset
        return result.position
    }

    // MARK: - PopView Content

    @ViewBuilder
    private func popViewForDirection() -> some View {
        let totalHeight = popViewHeight + config.arrowHeight
        let totalWidth = (measuredContentWidth ?? config.popViewWidth) + (effectiveDirection.isVertical ? 0 : config.arrowHeight)

        ZStack(alignment: effectiveDirection == .bottom ? .top : (effectiveDirection == .top ? .bottom : .topLeading)) {
            // Background shape with arrow
            FAPopoverWithArrowShape(
                arrowDirection: arrowDirectionFor(effectiveDirection),
                arrowOffset: effectiveArrowOffset,
                arrowWidth: config.arrowWidth,
                arrowHeight: config.arrowHeight,
                cornerRadius: config.cornerRadius
            )
            .fill(config.backgroundColor)
            .frame(
                width: effectiveDirection.isVertical ? (measuredContentWidth ?? config.popViewWidth) : totalWidth,
                height: effectiveDirection.isVertical ? totalHeight : popViewHeight
            )
            .shadow(color: config.shadowColor1, radius: config.shadowRadius1, x: 0, y: 0)
            .shadow(color: config.shadowColor2, radius: config.shadowRadius2, x: 0, y: config.shadowOffsetY2)

            // Content
            popViewContent()
                .frame(width: measuredContentWidth ?? config.popViewWidth, height: popViewHeight)
                .offset(
                    x: effectiveDirection == .right ? config.arrowHeight : 0,
                    y: effectiveDirection == .bottom ? config.arrowHeight : 0
                )
        }
        .overlay(
            FAPopoverWithArrowShape(
                arrowDirection: arrowDirectionFor(effectiveDirection),
                arrowOffset: effectiveArrowOffset,
                arrowWidth: config.arrowWidth,
                arrowHeight: config.arrowHeight,
                cornerRadius: config.cornerRadius
            )
            .stroke(Color.white.opacity(0.2), lineWidth: config.borderWidth)
            .allowsHitTesting(false)
        )
        .frame(
            width: effectiveDirection.isVertical ? (measuredContentWidth ?? config.popViewWidth) : totalWidth,
            height: effectiveDirection.isVertical ? totalHeight : popViewHeight
        )
    }

    @ViewBuilder
    private func popViewContent() -> some View {
        if let items = items {
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    FAPopViewItemRow(
                        item: item,
                        config: config,
                        itemIndex: index,
                        totalItemCount: items.count,
                        direction: effectiveDirection,
                        arrowOffset: effectiveArrowOffset,
                        onSelect: {
                            onItemSelect(item)
                            DispatchQueue.main.async {
                                showPopView = false
                                FAPopViewManager.shared.hideBackground()
                            }
                        },
                        onHoverChange: { isHovering in
                            hoveringItemIndex = isHovering ? index : nil
                        }
                    )
                }
            }
            .modifier(SizeReaderModifier(size: $popViewHeight))
        } else {
            content()
                .padding(8)
                .modifier(SizeReaderModifier(size: $popViewHeight))
                .background(
                    GeometryReader { geo in
                        Color.clear.onChange(of: geo.size.width, initial: true) { _, newWidth in
                            measuredContentWidth = newWidth
                        }
                    }
                )
        }
    }

    private func arrowDirectionFor(_ direction: PopViewDirection) -> ArrowDirection {
        switch direction {
        case .bottom: return .up
        case .top: return .down
        case .left: return .right
        case .right: return .left
        }
    }
}

// MARK: - Convenience Initializers

public extension FAPopView where ButtonLabel == EmptyView {
    /// Creates a content-only popover (for use with .faPopover modifier)
    init(
        items: [PopViewItem],
        config: FAPopViewConfiguration = .default,
        onSelect: @escaping (PopViewItem) -> Void = { _ in }
    ) where Content == EmptyView {
        self.items = items
        self.config = config
        self.onItemSelect = onSelect
        self.button = { EmptyView() }
        self.content = { EmptyView() }
    }
}
