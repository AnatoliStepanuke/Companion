import UIKit

// MARK: - Constructs
struct Schedule: Codable {
    let nameSubject: String
    let typeSubject: String
    let subjectStartTime: Date
    let subjectEndTime: Date
    let audienceNumber: Int
    let teacherName: String
}
