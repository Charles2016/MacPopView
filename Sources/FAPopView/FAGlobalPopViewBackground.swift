//
//  FAGlobalPopViewBackground.swift
//  FAPopView
//
//  Global background overlay and content renderer for all popviews
//

import SwiftUI

// MARK: - Global PopView Background

/// Global background overlay and content renderer for all popviews
///
/// This view provides:
/// - Tap-to-dismiss functionality for the entire popview system
/// - Absolute positioning for popview content
/// - Coordinated animations with the popview manager
///
/// This view is added automatically when using `.withPopViewSupport()`.
struct FAGlobalPopViewBackground: View {
    var popViewManager = FAPopViewManager.shared

    private enum Constants {
        static let backgroundZIndex: CGFloat = 50
        static let contentZIndex: CGFloat = 101
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background overlay - clickable only when showing
            if popViewManager.isShowingBackground {
                Color.clear
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        DispatchQueue.main.async {
                            popViewManager.hideBackground()
                        }
                    }
                    .zIndex(Constants.backgroundZIndex)
            }

            // PopView content - positioned absolutely
            if popViewManager.isShowingBackground,
               let popViewContent = popViewManager.popViewContent {
                popViewContent
                    .offset(x: popViewManager.popViewOffset.x,
                            y: popViewManager.popViewOffset.y)
                    .zIndex(Constants.contentZIndex)
            }
        }
    }
}
