import SwiftUI

/// The courtroom's named slots: two spots high on the wall and the crest above the bench, the
/// judge's seat, two spots on the raised bench, the lawyer's place on the left, the dock on the
/// right, a lectern in front of the bench and two spots on the floor.
enum G1Courtroom {
    static let noor = CGPoint(x: 210, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "wallLeft": PalaceSlot(frame: CGRect(x: 8, y: 24, width: 96, height: 72), pin: CGPoint(x: 8, y: 94), tilt: -1.5),
        "crest": PalaceSlot(frame: CGRect(x: 136, y: 18, width: 98, height: 70), pin: CGPoint(x: 185, y: 4), align: .center, tilt: 1),
        "wallRight": PalaceSlot(frame: CGRect(x: 266, y: 24, width: 96, height: 72), pin: CGPoint(x: 364, y: 94), align: .trailing, tilt: 1.5),
        "judge": PalaceSlot(frame: CGRect(x: 148, y: 92, width: 74, height: 106), pin: CGPoint(x: 185, y: 202), align: .center, tilt: -1),
        "benchLeft": PalaceSlot(frame: CGRect(x: 96, y: 146, width: 50, height: 50), pin: CGPoint(x: 94, y: 124), tilt: -2),
        "benchRight": PalaceSlot(frame: CGRect(x: 224, y: 140, width: 52, height: 56), pin: CGPoint(x: 278, y: 120), align: .trailing, tilt: 2),
        "lawyer": PalaceSlot(frame: CGRect(x: 6, y: 150, width: 88, height: 150), pin: CGPoint(x: 4, y: 262), tilt: 1.5),
        "dock": PalaceSlot(frame: CGRect(x: 276, y: 150, width: 90, height: 150), pin: CGPoint(x: 366, y: 262), align: .trailing, tilt: -1.5),
        "lectern": PalaceSlot(frame: CGRect(x: 136, y: 228, width: 98, height: 66), pin: CGPoint(x: 185, y: 288), align: .center, tilt: 1.5),
        "floorLeft": PalaceSlot(frame: CGRect(x: 8, y: 306, width: 100, height: 96), pin: CGPoint(x: 6, y: 376), tilt: -1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 264, y: 306, width: 100, height: 96), pin: CGPoint(x: 366, y: 376), align: .trailing, tilt: 1.5),
    ]
}

/// A Dutch courtroom: cream upper walls over dark wood panelling, the raised bench across the
/// back with a tall red chair, and a parquet floor.
struct G1CourtroomBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + bench + floor

    private nonisolated static let wall: [PalaceMark] = {
        var panels = "", dentils = ""
        for x in stride(from: 6.0, to: 370, by: 46) { panels += "M\(x) 150H\(x + 38)V286H\(x)Z" }
        for x in stride(from: 4, to: 370, by: 10) { dentils += "M\(x) 14h5v4h-5Z" }
        return [
            .f("M0 0H370V300H0Z", 0xE8DDC6),
            .f("M0 0H370V14H0Z", 0x4A3524),
            .f("M0 14H370V18H0Z", 0xD9CDB4),
            .f(dentils, 0x4A3524),
            .f("M0 18H370V21H0Z", 0x1E1E1C, 0.07),
            // Pilasters either side of the bench
            .f("M118 18H130V146H118Z M240 18H252V146H240Z", 0xD9CDB4),
            .f("M114 18H134V26H114Z M236 18H256V26H236Z", 0xC9B892),
            // Dark wood panelling
            .f("M0 140H370V300H0Z", 0x6B4A2E),
            .f("M0 136H370V144H0Z", 0x4A3524),
            .s(panels, 0x5A3D25, 2),
        ]
    }()

    /// The raised bench (x 90–280): a tall red chair behind it, a wide top at y 194, a panelled front.
    private nonisolated static let bench: [PalaceMark] = [
        .f("M156 90Q156 80 166 80H204Q214 80 214 90V196H156Z", 0x7A1E1E),
        .f("M162 92Q162 86 168 86H202Q208 86 208 92V196H162Z", 0x962A2A),
        .s("M172 96V188M185 96V188M198 96V188", 0x7A1E1E, 1.4),
        .f("M86 194H284V204H86Z", 0x8C5E38),
        .f("M86 204H284V208H86Z", 0x1E1E1C, 0.2),
        .f("M90 208H280V300H90Z", 0x7A5230),
        .f("M100 218H180V292H100Z M190 218H270V292H190Z", 0x6B4A2E),
        .s("M104 222H176V288H104Z M194 222H266V288H194Z", 0x9A6A42, 1.2),
        .f("M90 294H280V300H90Z", 0x4A3524),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var boards = ""
        for y in stride(from: 312.0, to: 408, by: 12) { boards += "M0 \(y)H370" }
        var joints = ""
        for (i, y) in stride(from: 300.0, to: 408, by: 12).enumerated() {
            for x in stride(from: Double(i % 2) * 30 + 10, to: 370, by: 60) { joints += "M\(x) \(y)V\(y + 12)" }
        }
        return [
            .f("M0 300H370V408H0Z", 0xC9965F),
            .s(boards, 0xAD7D4E, 1),
            .s(joints, 0xAD7D4E, 1),
            .f("M0 298H370V303H0Z", 0x4A3524),
            .f("M0 303H370V306H0Z", 0x1E1E1C, 0.1),
        ]
    }()
}
