//
//  FAPopViewLayoutCalculator.swift
//  FAPopView
//
//  Shared layout calculation logic for popview positioning
//

import SwiftUI

/// Calculates optimal direction and position for popview placement
struct FAPopViewLayoutCalculator {
    let buttonFrame: CGRect
    let screenSize: CGSize
    let config: FAPopViewConfiguration
    let contentSize: CGSize
    
    /// Calculate the best direction for the popview
    func bestDirection() -> PopViewDirection {
        if let preferred = config.preferredDirection {
            return preferred
        }
        
        let spaceAbove = buttonFrame.minY - FAPopViewLayout.screenMargin
        let spaceBelow = screenSize.height - buttonFrame.maxY - FAPopViewLayout.screenMargin
        let spaceLeft = buttonFrame.minX - FAPopViewLayout.screenMargin
        let spaceRight = screenSize.width - buttonFrame.maxX - FAPopViewLayout.screenMargin
        
        let width = contentSize.width > 0 ? contentSize.width : config.popViewWidth
        let height = contentSize.height > 0 ? contentSize.height : 100
        
        let bottomFits = (buttonFrame.maxY + config.arrowHeight + config.arrowSpacing + height + FAPopViewLayout.screenMargin) <= screenSize.height
            && buttonFrame.midX - width / 2 >= FAPopViewLayout.screenMargin
            && buttonFrame.midX + width / 2 <= screenSize.width - FAPopViewLayout.screenMargin
        
        let topFits = (buttonFrame.minY - config.arrowHeight - config.arrowSpacing - height) >= FAPopViewLayout.screenMargin
            && buttonFrame.midX - width / 2 >= FAPopViewLayout.screenMargin
            && buttonFrame.midX + width / 2 <= screenSize.width - FAPopViewLayout.screenMargin
        
        let rightFits = (buttonFrame.maxX + config.arrowHeight + config.arrowSpacing + width + FAPopViewLayout.screenMargin) <= screenSize.width
            && buttonFrame.midY - height / 2 >= FAPopViewLayout.screenMargin
            && buttonFrame.midY + height / 2 <= screenSize.height - FAPopViewLayout.screenMargin
        
        let leftFits = (buttonFrame.minX - config.arrowHeight - config.arrowSpacing - width) >= FAPopViewLayout.screenMargin
            && buttonFrame.midY - height / 2 >= FAPopViewLayout.screenMargin
            && buttonFrame.midY + height / 2 <= screenSize.height - FAPopViewLayout.screenMargin
        
        var viableDirections: [(direction: PopViewDirection, space: CGFloat)] = []
        if bottomFits { viableDirections.append((.bottom, spaceBelow)) }
        if topFits { viableDirections.append((.top, spaceAbove)) }
        if rightFits { viableDirections.append((.right, spaceRight)) }
        if leftFits { viableDirections.append((.left, spaceLeft)) }
        
        if let best = viableDirections.max(by: { $0.space < $1.space }) {
            return best.direction
        }
        
        let allSpaces: [(PopViewDirection, CGFloat)] = [
            (.bottom, spaceBelow), (.top, spaceAbove),
            (.left, spaceLeft), (.right, spaceRight)
        ]
        return allSpaces.max(by: { $0.1 < $1.1 })?.0 ?? .bottom
    }
    
    /// Calculate the global position and arrow offset for the popview
    func position(for direction: PopViewDirection) -> (position: CGPoint, arrowOffset: CGFloat) {
        let width = contentSize.width > 0 ? contentSize.width : config.popViewWidth
        let height = contentSize.height > 0 ? contentSize.height : 100
        
        switch direction {
        case .bottom, .top:
            let buttonCenterX = buttonFrame.midX
            let idealContentX = buttonCenterX - width / 2
            let actualContentX = max(FAPopViewLayout.screenPadding,
                                     min(idealContentX, screenSize.width - width - FAPopViewLayout.screenPadding))
            let arrowOffset = buttonCenterX - actualContentX
            
            if direction == .bottom {
                return (CGPoint(x: actualContentX, y: buttonFrame.maxY + config.arrowSpacing), arrowOffset)
            } else {
                let totalHeight = height + config.arrowHeight
                let contentY = buttonFrame.minY - totalHeight - config.arrowSpacing
                return (CGPoint(x: actualContentX, y: max(FAPopViewLayout.screenPadding, contentY)), arrowOffset)
            }
            
        case .right, .left:
            let buttonCenterY = buttonFrame.midY
            let idealContentY = buttonCenterY - height / 2
            let actualContentY = max(FAPopViewLayout.screenPadding,
                                     min(idealContentY, screenSize.height - height - FAPopViewLayout.screenPadding))
            let arrowOffset = buttonCenterY - actualContentY
            
            if direction == .right {
                return (CGPoint(x: buttonFrame.maxX + config.arrowSpacing, y: actualContentY), arrowOffset)
            } else {
                let totalWidth = width + config.arrowHeight
                let contentX = buttonFrame.minX - totalWidth - config.arrowSpacing
                return (CGPoint(x: max(FAPopViewLayout.screenPadding, contentX), y: actualContentY), arrowOffset)
            }
        }
    }
}
