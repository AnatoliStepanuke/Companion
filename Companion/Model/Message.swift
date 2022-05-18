import UIKit

// MARK: - Constructs
struct Message {
    let text: String?
    let fromUserID: String?
    let toUserID: String?
    let timeInterval: NSNumber?

    init(dictionary: [String: AnyObject]) {
        self.text = dictionary["text"] as? String
        self.fromUserID = dictionary["fromUserID"] as? String
        self.toUserID = dictionary["toUserID"] as? String
        self.timeInterval = dictionary["timeInterval"] as? NSNumber
    }
}
