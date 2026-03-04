import XCTest
@testable import FAPopView

final class FAPopViewTests: XCTestCase {
    
    func testPopViewItemCreation() {
        let item = PopViewItem(title: "Test", subtitle: "Subtitle", icon: "star")
        XCTAssertEqual(item.title, "Test")
        XCTAssertEqual(item.subtitle, "Subtitle")
        XCTAssertEqual(item.icon, "star")
    }
    
    func testConfigurationPresets() {
        let dark = FAPopViewConfiguration.dark
        let light = FAPopViewConfiguration.light
        
        XCTAssertEqual(dark.cornerRadius, 12)
        XCTAssertEqual(light.cornerRadius, 12)
        XCTAssertEqual(dark.popViewWidth, 250)
    }
    
    func testConfigurationBuilder() {
        let config = FAPopViewConfiguration.dark
            .width(300)
            .cornerRadius(16)
            .direction(.top)
        
        XCTAssertEqual(config.popViewWidth, 300)
        XCTAssertEqual(config.cornerRadius, 16)
        XCTAssertEqual(config.preferredDirection, .top)
    }
    
    func testPopViewDirectionOpposite() {
        XCTAssertEqual(PopViewDirection.top.opposite, .bottom)
        XCTAssertEqual(PopViewDirection.bottom.opposite, .top)
        XCTAssertEqual(PopViewDirection.left.opposite, .right)
        XCTAssertEqual(PopViewDirection.right.opposite, .left)
    }
    
    func testPopViewDirectionIsVertical() {
        XCTAssertTrue(PopViewDirection.top.isVertical)
        XCTAssertTrue(PopViewDirection.bottom.isVertical)
        XCTAssertFalse(PopViewDirection.left.isVertical)
        XCTAssertFalse(PopViewDirection.right.isVertical)
    }
    
    func testLayoutCalculatorBottomDirection() {
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: CGRect(x: 200, y: 100, width: 100, height: 40),
            screenSize: CGSize(width: 800, height: 600),
            config: .dark,
            contentSize: CGSize(width: 250, height: 200)
        )
        let direction = calculator.bestDirection()
        XCTAssertEqual(direction, .bottom)
    }

    func testLayoutCalculatorTopDirection() {
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: CGRect(x: 200, y: 500, width: 100, height: 40),
            screenSize: CGSize(width: 800, height: 600),
            config: .dark,
            contentSize: CGSize(width: 250, height: 200)
        )
        let direction = calculator.bestDirection()
        XCTAssertEqual(direction, .top)
    }

    func testLayoutCalculatorPositionArrowOffset() {
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: CGRect(x: 200, y: 100, width: 100, height: 40),
            screenSize: CGSize(width: 800, height: 600),
            config: .dark,
            contentSize: CGSize(width: 250, height: 200)
        )
        let result = calculator.position(for: .bottom)
        XCTAssertGreaterThan(result.arrowOffset, 0)
        XCTAssertEqual(result.position.y, 140 + FAPopViewConfiguration.dark.arrowSpacing)
    }

    func testLayoutCalculatorPreferredDirection() {
        let config = FAPopViewConfiguration.dark.direction(.left)
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: CGRect(x: 400, y: 300, width: 100, height: 40),
            screenSize: CGSize(width: 800, height: 600),
            config: config,
            contentSize: CGSize(width: 250, height: 200)
        )
        XCTAssertEqual(calculator.bestDirection(), .left)
    }

    func testLayoutCalculatorEdgeCase() {
        let calculator = FAPopViewLayoutCalculator(
            buttonFrame: CGRect(x: 0, y: 0, width: 50, height: 30),
            screenSize: CGSize(width: 800, height: 600),
            config: .dark,
            contentSize: CGSize(width: 250, height: 200)
        )
        let direction = calculator.bestDirection()
        // Should pick bottom or right since button is at top-left corner
        XCTAssertTrue(direction == .bottom || direction == .right)
    }
}
