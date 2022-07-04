import Foundation

final class UserManager {
    // MARK: - Constants
    // MARK: Private
    private let defaults = UserDefaults.standard

    // MARK: Public
    static let instance = UserManager()

    // MARK: - Init
    private init() { }

    // MARK: - Helpers
    private func encode(schedules: [Schedule], key: String) {
        if let encodedData = try? JSONEncoder().encode(schedules) {
            return defaults.setValue(encodedData, forKey: key)
        }
    }

    private func decode(key: String) -> [Schedule] {
        if let decodedData = defaults.data(forKey: key) {
            let schedules = try? JSONDecoder().decode([Schedule].self, from: decodedData)
            if let resultSchedules = schedules {
                return resultSchedules
            }
        }
        return []
    }

    // MARK: - API
    func saveScheduleToUserDefaults(schedule: Schedule) {
        var schedules = getScheduleFromUserDefaults()
        schedules.append(schedule)
        encode(schedules: schedules, key: ConstantsUserDefaults.scheduleList)
    }

    func saveScheduleToUserDefaults2(updatedSchedules: [Schedule]) {
        var schedules = getScheduleFromUserDefaults()
        schedules.removeAll()
        schedules = updatedSchedules
        encode(schedules: schedules, key: ConstantsUserDefaults.scheduleList)
    }

    func getScheduleFromUserDefaults() -> [Schedule] {
        decode(key: ConstantsUserDefaults.scheduleList)
    }

    func updateSchedulesFromUserDefaults(updatedSchedules: [Schedule]) {
        var schedules = getScheduleFromUserDefaults()
        schedules = updatedSchedules
        encode(schedules: schedules, key: ConstantsUserDefaults.scheduleList)
    }
}
