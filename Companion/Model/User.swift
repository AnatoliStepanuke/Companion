import UIKit

// MARK: - Constructs
struct User {
    let name: String?
    let email: String?
    let profileImageURL: String?
    init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageURL = dictionary["profileImageURL"] as? String
    }
}
