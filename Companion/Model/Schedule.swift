import UIKit

// MARK: - Constructs
struct Schedule: Codable {
    let nameSubject: String
    let typeSubject: String
    let subjectStartTime: Date
    let subjectEndTime: Date
    let buildingNumber: String
    let audienceNumber: String
    let teacherName: String
    var id: String = UUID().uuidString
    let scheduleDateType: ScheduleWeekType
    private let dateFormatter: DateFormatter = DateFormatter()
    private enum CodingKeys: String, CodingKey {
        case nameSubject,
             typeSubject,
             subjectStartTime,
             subjectEndTime,
             buildingNumber,
             audienceNumber,
             teacherName,
             id,
             scheduleDateType
    }
}

enum ScheduleWeekType: Codable, Equatable {
    case upper(ScheduleDayType)
    case bottom(ScheduleDayType)
}

enum ScheduleDayType: Int, Codable, Equatable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

// MARK: - Construct extensions
extension Schedule: CustomStringConvertible {
    var description: String {
        let message = """
        subjectStartTime - \(dateFormatter.string(from: subjectStartTime))
        subjectEndTime - \(dateFormatter.string(from: subjectEndTime))
        """
        return message
    }

    var subjectStartTimeDescription: String {
        handleSubjectsTimeLogic(picker: subjectStartTime)
    }

    var subjectEndTimeDescription: String {
        handleSubjectsTimeLogic(picker: subjectEndTime)
    }

    // MARK: - Helpers
    private func handleSubjectsTimeLogic(picker: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: picker)
    }
}
