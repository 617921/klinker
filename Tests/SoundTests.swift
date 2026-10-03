import XCTest
@testable import Klinker

final class SoundTests: XCTestCase {
    func testEverySoundIsCleanAndNotTooLoud() {
        for sound in KlinkerSound.allCases {
            let samples = SoundBank.render(sound)
            XCTAssertGreaterThan(samples.count, 1000, "\(sound) is empty")
            XCTAssertFalse(samples.contains { !$0.isFinite }, "\(sound) has NaN")
            let peak = samples.reduce(0) { max($0, abs($1)) }
            XCTAssertLessThanOrEqual(peak, 0.75, "\(sound) is too loud")
            XCTAssertGreaterThan(peak, 0.05, "\(sound) is silent")
            if !sound.isBed {
                // One-shots start and end in silence, so they never click.
                XCTAssertLessThan(abs(samples.first!), 0.01, "\(sound) starts with a click")
                XCTAssertLessThan(abs(samples.last!), 0.01, "\(sound) ends with a click")
            }
        }
    }

    func testBedsLoopWithoutASeam() {
        for bed in KlinkerSound.allCases where bed.isBed {
            let samples = SoundBank.render(bed)
            // The seam may be no bigger a step than the sound already takes between neighbours.
            var biggest: Float = 0
            for i in 1..<samples.count { biggest = max(biggest, abs(samples[i] - samples[i - 1])) }
            XCTAssertLessThanOrEqual(abs(samples.last! - samples.first!), biggest, "\(bed) jumps at the loop point")
            XCTAssertGreaterThan(Double(samples.count) / Synth.rate, 8, "\(bed) loop is too short")
        }
    }

    func testChurchBellsStrikeTheHour() {
        XCTAssertGreaterThan(SoundBank.strike(12).count, SoundBank.strike(3).count)
        XCTAssertEqual(Synth.note("A4"), 440, accuracy: 0.01)
        XCTAssertEqual(Synth.note("C5"), 523.25, accuracy: 0.01)
    }
}
