import XCTest
@testable import Klinker

@MainActor
final class KaartMoodTests: XCTestCase {
    private var amsterdam: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!
        return calendar
    }

    private func date(_ month: Int, _ day: Int, _ hour: Int, _ minute: Int = 0) -> Date {
        amsterdam.date(from: DateComponents(year: 2026, month: month, day: day, hour: hour, minute: minute))!
    }

    func testSunTimesFollowTheSeasons() {
        let june = KaartSun.times(on: date(6, 21, 12), calendar: amsterdam)
        XCTAssertEqual(june.rise, 5.3, accuracy: 0.3)
        XCTAssertEqual(june.set, 22.0, accuracy: 0.3)
        let december = KaartSun.times(on: date(12, 21, 12), calendar: amsterdam)
        XCTAssertEqual(december.rise, 8.8, accuracy: 0.3)
        XCTAssertEqual(december.set, 16.5, accuracy: 0.3)
    }

    func testLightPhasesThroughASummerDay() {
        XCTAssertEqual(KaartSun.phase(at: date(6, 21, 4, 0), calendar: amsterdam), .night)
        XCTAssertEqual(KaartSun.phase(at: date(6, 21, 5, 30), calendar: amsterdam), .dawn)
        XCTAssertEqual(KaartSun.phase(at: date(6, 21, 13), calendar: amsterdam), .day)
        XCTAssertEqual(KaartSun.phase(at: date(6, 21, 21), calendar: amsterdam), .golden)
        XCTAssertEqual(KaartSun.phase(at: date(6, 21, 23), calendar: amsterdam), .night)
        // A December afternoon is already dark at six.
        XCTAssertEqual(KaartSun.phase(at: date(12, 21, 18), calendar: amsterdam), .night)
    }

    func testFixedLightKeepsSeasonAndWeather() {
        let winterEvening = date(1, 10, 21)
        let day = KaartMood.at(winterEvening, light: .day, calendar: amsterdam)
        XCTAssertEqual(day.phase, .day)
        XCTAssertEqual(day.season, .winter)
        XCTAssertTrue(KaartMood.at(winterEvening, light: .auto, calendar: amsterdam).night)
        // The weather is the same for every moment in one three-hour block.
        XCTAssertEqual(
            KaartMood.drizzles(at: date(10, 3, 9), season: .herfst, calendar: amsterdam),
            KaartMood.drizzles(at: date(10, 3, 11, 59), season: .herfst, calendar: amsterdam)
        )
    }
}
