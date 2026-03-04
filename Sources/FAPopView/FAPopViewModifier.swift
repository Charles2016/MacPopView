//
//  FAPopViewModifier.swift
//  FAPopView
//
//  View modifier for attaching popovers to any view
//

import SwiftUI

// MARK: - FAPopViewModifier

/// ViewModifier that attaches a popover to any view
struct FAPopViewModifier<PopViewContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let config: FAPopViewConfiguration
    let popViewContent: () -> PopViewContent

    @State private var buttonFrame: CGRect = .zero
    @State private var localScreenSize: CGSize = .zero
    @State private var popViewDirection: PopViewDirection = .bottom
    @State private var measuredSize: CGSize = .zero
    @State private var arrowOffset: CGFloat = 0

    @Environment(\.faPopViewScreenSize) var envScreenSize
    var popViewManager = FAPopViewManager.shared

    private var screenSize: CGSize {
        if envScreenSize != .zero {
            return envScreenSize
        }
        if let currentScreen = NSScreen.main {
            return currentScreen.visibleFrame.size
        }
        return localScreenSize
    }

    func body(content: Content) -> some View {
        content
            .buttonStyle(PlainButtonStyle())
            .background(
                popViewContent()
                    .hidden()
                    .frame(width: 0, height: 0)
            )
            .background(GeometryReader { buttonGeo in
                Color.clear
                    .onAppear { updateButtonFrame(buttonGeo) }
                    .onChange(of: buttonGeo.frame(in: .named("global"))) { _, _ in
                        updateButtonFrame(buttonGeo)
                    }
            })
            .background(GeometryReader { screenGeo in
                Color.clear.onAppear {
                    localScreenSize = screenGeo.size
                }
                .onChange(of: screenGeo.size, initial: false) { _, newSize in
                    localScreenSize = newSize
                }
            })
            .onChange(of: screenSize, initial: false) { _, _ in
                if isPresented { updatePopView() }
            }
            .onChange(of: isPresented) { _, presented in
                if presented {
                    updatePopView()
                } else {
                    popViewManager.hideBackground()
                }
            }
            .onChange(of: measuredSize) { _, _ in
                if isPresented { updatePopView() }
            }
            .onReceive(NotificationCenter.default.publisher(for: .dismissAllPopViews)) { _ in
                isPresented = false
            }
    }

    private func updateButtonFrame(_ geo: GeometryProxy) {
        let frame = geo.frame(in: .named("global"))
        if frame != .zero {
            buttonFrame = frame
            if isPresented { updatePopView() }
        }
    }

    private func updatePopView() {
        guard isPresented else { return }

        let newDirection = calculateBestDirection()
        if newDirection != popViewDirection {
            popViewDirection = newDirection
        }

        let layout = calculatePopViewLayout()
        if arrowOffset != layout.arrowOffset {
            arrowOffset = layout.arrowOffset
        }

        let contentWithContext = popViewContent()
            .environment(\.faPopViewContext,
                         FAPopViewContext(direction: popViewDirection,
                                          arrowOffset: layout.arrowOffset))
            .background(GeometryReader { geo in
                Color.clear.onChange(of: geo.size, initial: true) { _, newSize in
                    if newSize != .zero {
                        measuredSize = newSize
                    }
                }
            })

        popViewManager.showPopView(
            content: contentWithContext,
            offset: layout.position,
            direction: popViewDirection
        )
    }

    private func calculateBestDirection() -> PopViewDirection {
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: buttonFrame,
            screenSize: screenSize,
            config: config,
            contentSize: measuredSize
        )
        return calculator.bestDirection()
    }

    private func calculatePopViewLayout() -> (position: CGPoint, arrowOffset: CGFloat) {
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: buttonFrame,
            screenSize: screenSize,
            config: config,
            contentSize: measuredSize
        )
        return calculator.position(for: popViewDirection)
    }
}

// MARK: - View Extension

public extension View {
    /// Attaches a popover to the view
    /// - Parameters:
    ///   - isPresented: Binding to control popover visibility
    ///   - config: Configuration for styling (default: .dark)
    ///   - content: View builder for popover content
    func faPopover<Content: View>(
        isPresented: Binding<Bool>,
        config: FAPopViewConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(FAPopViewModifier(
            isPresented: isPresented,
            config: config,
            popViewContent: content
        ))
    }
    
    /// Attaches a list popover to the view
    /// - Parameters:
    ///   - isPresented: Binding to control popover visibility
    ///   - items: Array of items to display
    ///   - config: Configuration for styling (default: .dark)
    ///   - onSelect: Callback when an item is selected
    func faPopover(
        isPresented: Binding<Bool>,
        items: [PopViewItem],
        config: FAPopViewConfiguration = .default,
        onSelect: @escaping (PopViewItem) -> Void = { _ in }
    ) -> some View {
        self.modifier(FAPopViewModifier(
            isPresented: isPresented,
            config: config,
            popViewContent: {
                FAPopView(items: items, config: config, onSelect: { item in
                    onSelect(item)
                    isPresented.wrappedValue = false
                })
            }
        ))
    }
}
