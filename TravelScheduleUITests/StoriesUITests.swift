import XCTest

/// Проверяет сценарии из чек-листа: открытие историй из панели,
/// листание, закрытие и переходы на экране настроек.
final class StoriesUITests: XCTestCase {
    private var app: XCUIApplication!

    /// Крестик виден только на экране историй, поэтому по нему
    /// и проверяется, открыт экран или уже закрылся
    private var storiesScreen: XCUIElement { app.buttons["stories-close"] }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        // Заставка держится две секунды
        XCTAssertTrue(app.buttons["story-1"].waitForExistence(timeout: 15))
    }

    func testStoryOpensFromPanelAndClosesByCross() {
        app.buttons["story-3"].tap()
        XCTAssertTrue(storiesScreen.waitForExistence(timeout: 5))

        storiesScreen.tap()
        XCTAssertTrue(waitForDisappearance(of: storiesScreen))
        XCTAssertTrue(app.buttons["story-3"].waitForExistence(timeout: 5))
    }

    func testStoriesSwitchBySwipeAndTap() {
        app.buttons["story-1"].tap()
        XCTAssertTrue(storiesScreen.waitForExistence(timeout: 5))

        let page = app.images.firstMatch
        page.swipeLeft()
        page.tap()
        page.swipeRight()

        XCTAssertTrue(storiesScreen.exists)
        storiesScreen.tap()
        XCTAssertTrue(waitForDisappearance(of: storiesScreen))
    }

    func testStoriesCloseBySwipeDown() {
        app.buttons["story-1"].tap()
        XCTAssertTrue(storiesScreen.waitForExistence(timeout: 5))

        app.images.firstMatch.swipeDown(velocity: .fast)
        XCTAssertTrue(waitForDisappearance(of: storiesScreen))
    }

    func testSettingsTogglesThemeAndOpensAgreement() {
        app.tabBars.buttons.element(boundBy: 1).tap()

        let toggle = app.switches["theme-toggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 5))

        let initialValue = toggle.value as? String
        toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()
        XCTAssertNotEqual(toggle.value as? String, initialValue)

        app.buttons["agreement-row"].tap()

        let agreement = app.webViews.firstMatch
        XCTAssertTrue(agreement.waitForExistence(timeout: 10))

        // Соглашение показывается поверх таббара: до него не дотянуться,
        // а сама страница уходит ниже, чем начинается таббар
        XCTAssertFalse(app.tabBars.firstMatch.isHittable)
        XCTAssertGreaterThan(agreement.frame.maxY, app.tabBars.firstMatch.frame.minY)
    }

    private func waitForDisappearance(of element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
}
