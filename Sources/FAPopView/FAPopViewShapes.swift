//
//  FAPopViewShapes.swift
//  FAPopView
//
//  Shape definitions for FAPopView arrows and backgrounds
//

import SwiftUI

// MARK: - FAArrow Shape

/// Simple triangle arrow shape
public struct FAArrow: Shape {
    let direction: ArrowDirection

    public init(direction: ArrowDirection) {
        self.direction = direction
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        switch direction {
        case .up:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        case .down:
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        case .left:
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        case .right:
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - FAPopoverWithArrowShape

/// Combined arrow and content box shape using bezier paths
public struct FAPopoverWithArrowShape: Shape {
    let arrowDirection: ArrowDirection
    let arrowOffset: CGFloat
    let arrowWidth: CGFloat
    let arrowHeight: CGFloat
    let cornerRadius: CGFloat
    
    public init(
        arrowDirection: ArrowDirection,
        arrowOffset: CGFloat,
        arrowWidth: CGFloat = 16,
        arrowHeight: CGFloat = 10,
        cornerRadius: CGFloat = 12
    ) {
        self.arrowDirection = arrowDirection
        self.arrowOffset = arrowOffset
        self.arrowWidth = arrowWidth
        self.arrowHeight = arrowHeight
        self.cornerRadius = cornerRadius
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        switch arrowDirection {
        case .up:
            path = drawUpArrow(in: rect)
        case .down:
            path = drawDownArrow(in: rect)
        case .left:
            path = drawLeftArrow(in: rect)
        case .right:
            path = drawRightArrow(in: rect)
        }
        
        return path
    }
    
    private func drawUpArrow(in rect: CGRect) -> Path {
        var path = Path()
        let contentTop = arrowHeight
        let arrowTipX = arrowOffset
        let arrowLeftX = arrowTipX - arrowWidth / 2
        let arrowRightX = arrowTipX + arrowWidth / 2
        
        let topEdgeStart = cornerRadius
        let topEdgeEnd = rect.width - cornerRadius
        
        let clampedLeft = max(topEdgeStart, min(topEdgeEnd, arrowLeftX))
        let clampedRight = max(topEdgeStart, min(topEdgeEnd, arrowRightX))
        
        path.move(to: CGPoint(x: 0, y: contentTop + cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: contentTop + cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        
        path.addLine(to: CGPoint(x: clampedLeft, y: contentTop))
        path.addLine(to: CGPoint(x: arrowTipX, y: 0))
        path.addLine(to: CGPoint(x: clampedRight, y: contentTop))
        
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: contentTop))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: contentTop + cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        
        path.closeSubpath()
        return path
    }
    
    private func drawDownArrow(in rect: CGRect) -> Path {
        var path = Path()
        let contentBottom = rect.height - arrowHeight
        let arrowTipX = arrowOffset
        let arrowLeftX = arrowTipX - arrowWidth / 2
        let arrowRightX = arrowTipX + arrowWidth / 2
        
        let bottomEdgeStart = rect.width - cornerRadius
        let bottomEdgeEnd = cornerRadius
        
        let clampedRight = min(bottomEdgeStart, max(bottomEdgeEnd, arrowRightX))
        let clampedLeft = min(bottomEdgeStart, max(bottomEdgeEnd, arrowLeftX))
        
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.width, y: contentBottom - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: contentBottom - cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        
        path.addLine(to: CGPoint(x: clampedRight, y: contentBottom))
        path.addLine(to: CGPoint(x: arrowTipX, y: rect.height))
        path.addLine(to: CGPoint(x: clampedLeft, y: contentBottom))
        
        path.addLine(to: CGPoint(x: cornerRadius, y: contentBottom))
        path.addArc(center: CGPoint(x: cornerRadius, y: contentBottom - cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        
        path.closeSubpath()
        return path
    }
    
    private func drawLeftArrow(in rect: CGRect) -> Path {
        var path = Path()
        let contentLeft = arrowHeight
        let arrowTipY = arrowOffset
        let arrowTopY = arrowTipY - arrowWidth / 2
        let arrowBottomY = arrowTipY + arrowWidth / 2
        
        let leftEdgeStart = rect.height - cornerRadius
        let leftEdgeEnd = cornerRadius
        
        let clampedBottom = min(leftEdgeStart, max(leftEdgeEnd, arrowBottomY))
        let clampedTop = min(leftEdgeStart, max(leftEdgeEnd, arrowTopY))
        
        path.move(to: CGPoint(x: contentLeft, y: cornerRadius))
        path.addArc(center: CGPoint(x: contentLeft + cornerRadius, y: cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        
        path.addLine(to: CGPoint(x: contentLeft + cornerRadius, y: rect.height))
        path.addArc(center: CGPoint(x: contentLeft + cornerRadius, y: rect.height - cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        
        path.addLine(to: CGPoint(x: contentLeft, y: clampedBottom))
        path.addLine(to: CGPoint(x: 0, y: arrowTipY))
        path.addLine(to: CGPoint(x: contentLeft, y: clampedTop))
        
        path.closeSubpath()
        return path
    }
    
    private func drawRightArrow(in rect: CGRect) -> Path {
        var path = Path()
        let contentRight = rect.width - arrowHeight
        let arrowTipY = arrowOffset
        let arrowTopY = arrowTipY - arrowWidth / 2
        let arrowBottomY = arrowTipY + arrowWidth / 2
        
        let rightEdgeStart = cornerRadius
        let rightEdgeEnd = rect.height - cornerRadius
        
        let clampedTop = max(rightEdgeStart, min(rightEdgeEnd, arrowTopY))
        let clampedBottom = max(rightEdgeStart, min(rightEdgeEnd, arrowBottomY))
        
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        
        path.addLine(to: CGPoint(x: contentRight - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: contentRight - cornerRadius, y: cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        
        path.addLine(to: CGPoint(x: contentRight, y: clampedTop))
        path.addLine(to: CGPoint(x: rect.width, y: arrowTipY))
        path.addLine(to: CGPoint(x: contentRight, y: clampedBottom))
        
        path.addLine(to: CGPoint(x: contentRight, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: contentRight - cornerRadius, y: rect.height - cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                   radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        
        path.closeSubpath()
        return path
    }
}

// MARK: - FACustomRoundedRectangle

/// Custom rounded rectangle with independent corner radii
public struct FACustomRoundedRectangle: Shape {
    public var topLeft: CGFloat
    public var topRight: CGFloat
    public var bottomLeft: CGFloat
    public var bottomRight: CGFloat
    
    public init(
        topLeft: CGFloat = 0,
        topRight: CGFloat = 0,
        bottomLeft: CGFloat = 0,
        bottomRight: CGFloat = 0
    ) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.width
        let h = rect.height
        
        let tr = min(min(topRight, h/2), w/2)
        let br = min(min(bottomRight, h/2), w/2)
        let bl = min(min(bottomLeft, h/2), w/2)
        let tl = min(min(topLeft, h/2), w/2)
        
        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        path.closeSubpath()
        return path
    }
}
