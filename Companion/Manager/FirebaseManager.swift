import Foundation
import FirebaseDatabase

final class FirebaseManager {
    // MARK: - Constants
    // MARK: Public
    static let instance = FirebaseManager()
    let databaseReference = Database.database().reference()
    let databaseReferenceToStudents = Database.database().reference().child("students")
    let databaseReferenceToTeachers = Database.database().reference().child("teachers")

    // MARK: - Init
    private init() { }

}
