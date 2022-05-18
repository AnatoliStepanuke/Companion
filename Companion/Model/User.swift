import UIKit

// MARK: - Constructs
struct User {
    var id: String?
    let name: String?
    let email: String?
    let profileImageURL: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageURL = dictionary["profileImageURL"] as? String
    }
}
