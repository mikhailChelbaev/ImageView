import UIKit

public class SessionImageSaver: ImageSaverProtocol {
    
    let queue = DispatchQueue(label: "SessionImageSaver")
    
    private static var cache: [String: UIImage] = [:]
    
    public func saveImage(image: UIImage, name: String) {
        queue.async {
            SessionImageSaver.cache[name] = image
        }
    }
    
    public func getImage(name: String) -> UIImage? {
        queue.sync {
            if let image = SessionImageSaver.cache[name] {
                return image
            }
            return nil
        }
    }
    
}
