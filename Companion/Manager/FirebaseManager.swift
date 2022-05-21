import UIKit
import Firebase
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

    // MARK: - API
    func fetchUserNameToUILabel(dictionaryKey: String, toUserID: String, label: UILabel, databaseRef: DatabaseReference) {
        databaseRef.child(toUserID).observe(.value, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                label.text = dictionary[dictionaryKey] as? String
            }
        }, withCancel: nil)
    }

    func fetchProfileImageView(imageView: UIImageView, databaseRef: DatabaseReference) {
        if let userID = Auth.auth().currentUser?.uid {
            databaseRef.child(userID).observeSingleEvent(of: .value) { snapshot in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    if let userIconURL = user.profileImageURL {
                        imageView.loadImageUsingCache(userIconURL)
                    }
                }
            }
        }
    }
}
