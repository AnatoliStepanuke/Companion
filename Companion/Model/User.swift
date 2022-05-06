import UIKit

// MARK: - Constructs
struct User {
    var name: String?
    var email: String?
    init(dictionary: [String: AnyObject]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
    }
}
