import XCTest

/// Временный smoke-тест: проходит основной сценарий приложения
/// с реальным API «Яндекс Расписаний».
final class NetworkSmokeUITests: XCTestCase {

    func testMainFlowWithRealAPI() {
        let app = XCUIApplication()
        app.launch()

        // Заставка держится две секунды
        let fromField = app.buttons["Откуда"]
        XCTAssertTrue(fromField.waitForExistence(timeout: 10), "Главный экран не появился")
        snapshot(app, name: "01-main")

        // Откуда: Москва, Ленинградский вокзал
        fromField.tap()
        selectCity("Москва", station: "Ленинградский вокзал", in: app, snapshotName: "02-cities")

        // Куда: Санкт-Петербург, Московский вокзал
        let toField = app.buttons["Куда"]
        XCTAssertTrue(toField.waitForExistence(timeout: 10))
        toField.tap()
        selectCity("Санкт-Петербург", station: "Московский вокзал", in: app, snapshotName: "03-stations")

        // Поиск рейсов
        let searchButton = app.buttons["Найти"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 10), "Кнопка «Найти» не появилась")
        searchButton.tap()

        let filterButton = app.buttons["Уточнить время"]
        XCTAssertTrue(filterButton.waitForExistence(timeout: 60), "Список рейсов не загрузился")

        let routeCard = app.scrollViews.buttons.element(boundBy: 0)
        XCTAssertTrue(routeCard.waitForExistence(timeout: 30), "Карточки рейсов не появились")
        snapshot(app, name: "04-routes")

        // Карточка перевозчика
        routeCard.tap()
        let carrierTitle = app.staticTexts["Информация о перевозчике"]
        XCTAssertTrue(carrierTitle.waitForExistence(timeout: 10), "Экран перевозчика не открылся")
        snapshot(app, name: "05-carrier")
    }

    private func selectCity(
        _ city: String,
        station: String,
        in app: XCUIApplication,
        snapshotName: String
    ) {
        // Список городов грузится из stations_list — ответ весит ~35 МБ
        let cityRow = app.buttons[city]
        XCTAssertTrue(cityRow.waitForExistence(timeout: 120), "Город «\(city)» не появился в списке")
        snapshot(app, name: snapshotName)
        scrollTo(cityRow, in: app)
        cityRow.tap()

        let stationRow = app.buttons[station]
        XCTAssertTrue(stationRow.waitForExistence(timeout: 20), "Станция «\(station)» не появилась")
        scrollTo(stationRow, in: app)
        stationRow.tap()
    }

    private func scrollTo(_ element: XCUIElement, in app: XCUIApplication) {
        var attempts = 0
        while !element.isHittable && attempts < 8 {
            app.swipeUp()
            attempts += 1
        }
    }

    private func snapshot(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
