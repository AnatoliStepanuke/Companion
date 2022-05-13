import UIKit

extension UIImageView {
    func loadImageUsingCache(_ urlString: String) {
        image = nil
        if let cachedImage = UIImageView.Constants.imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)
        if let url = url {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        if let downloadedImage = UIImage(data: data!) {
                            UIImageView.Constants.imageCache.setObject(
                                downloadedImage as UIImage,
                                forKey: urlString as NSString
                            )
                            self.image = downloadedImage
                        }
                    })
                } else {
                    print(error ?? "")
                }
            }).resume()
        }
    }
}
