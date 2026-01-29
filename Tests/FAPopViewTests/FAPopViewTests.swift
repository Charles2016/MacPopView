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
}
