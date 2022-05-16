import Foundation
import FirebaseStorage
import FirebaseDatabase

final class FirebaseManager {
    // MARK: - Constants
    // MARK: Public
    static let instance = FirebaseManager()
    let databaseReference = Database.database().reference()
    let databaseReferenceToStudents = Database.database().reference().child("students")
    let databaseReferenceToTeachers = Database.database().reference().child("teachers")
    let databaseReferenceToMessages = Database.database().reference().child("messages")
    let storageReference = Storage.storage().reference()
    let storageReferenceToStudentsImages = Storage.storage().reference().child("students_images").child("\(UUID().uuidString).jpg")
    let storageReferenceToTeachersImages = Storage.storage().reference().child("teachers_images").child("\(UUID().uuidString).jpg")

    // MARK: - Init
    private init() { }
}
