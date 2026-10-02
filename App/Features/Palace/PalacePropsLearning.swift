import SwiftUI

/// Dispatch for the props of the learning places (library, GP, school).
enum PalaceLearningProps {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .card: PalaceLibraryProps.card(pen, p)
        case .dueSlip: PalaceLibraryProps.dueSlip(pen, p)
        case .book: PalaceLibraryProps.book(pen, p)
        case .magazines: PalaceLibraryProps.magazines(pen, p)
        case .returnSlot: PalaceLibraryDeskProps.returnSlot(pen, p)
        case .clipboard: PalaceLibraryDeskProps.clipboard(pen, p)
        case .catalog: PalaceLibraryDeskProps.catalog(pen, p)
        case .tablet: PalaceLibraryDeskProps.tablet(pen, p)
        case .doctor: PalaceCarePeople.doctor(pen, p)
        case .patient: PalaceCarePeople.patient(pen, p)
        case .thermometer: PalaceDoctorProps.thermometer(pen, p)
        case .letter: PalaceDoctorProps.letter(pen, p)
        case .writingPad: PalaceDoctorProps.writingPad(pen, p)
        case .examCouch: PalaceDoctorProps.examCouch(pen, p)
        case .meeting: PalaceSchoolProps.meeting(pen, p)
        case .reportCard: PalaceSchoolProps.reportCard(pen, p)
        case .testPaper: PalaceSchoolProps.testPaper(pen, p)
        case .certificate: PalaceSchoolProps.certificate(pen, p)
        case .classTimetable: PalaceSchoolProps.timetable(pen, p)
        case .pupil: PalacePupils.pupil(pen, p)
        case .teacher: PalacePupils.teacher(pen, p)
        default: break
        }
    }
}
