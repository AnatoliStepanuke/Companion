import UIKit
import FirebaseAuth

// MARK: - Constructs
struct Chat {
    let text: String?
    let fromUserID: String?
    let toUserID: String?
    let timeInterval: NSNumber?
    private let dateFormatter: DateFormatter = DateFormatter()

    init(dictionary: [String: AnyObject]) {
        self.text = dictionary["text"] as? String
        self.fromUserID = dictionary["fromUserID"] as? String
        self.toUserID = dictionary["toUserID"] as? String
        self.timeInterval = dictionary["timeInterval"] as? NSNumber
    }
}

// MARK: - Construct extensions
extension Chat {
    var timeDescription: String {
        guard let timeInterval = timeInterval else {
            fatalError("can't return timeInterval")
        }

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval.doubleValue))
    }

    func chatPartnerId() -> String? {
        return fromUserID == Auth.auth().currentUser?.uid ? toUserID : fromUserID
    }
}
