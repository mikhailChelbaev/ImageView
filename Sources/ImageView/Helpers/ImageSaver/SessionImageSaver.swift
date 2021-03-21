import UIKit

public class SessionImageSaver: ImageSaverProtocol {
    
    private static var cache: [String: UIImage] = [:]
    
    public func saveImage(image: UIImage, name: String) {
        SessionImageSaver.cache[name] = image
    }
    
    public func getImage(name: String) -> UIImage? {
        if let image = SessionImageSaver.cache[name] {
            return image
        }
        return nil
    }
    
}
