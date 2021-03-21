import UIKit

public class CombinedImageSaver: ImageSaverProtocol {
    
    private let sessionSaver = SessionImageSaver()
    
    private let appFolderSaver = AppFolderImageSaver()
    
    public init() { }
    
    public func saveImage(image: UIImage, name: String) {
        sessionSaver.saveImage(image: image, name: name)
        appFolderSaver.saveImage(image: image, name: name)
    }
    
    public func getImage(name: String) -> UIImage? {
        if let image = sessionSaver.getImage(name: name) {
            return image
        }
        
        if let image = appFolderSaver.getImage(name: name) {
            sessionSaver.saveImage(image: image, name: name)
            return image
        }
        
        return nil
    }
    
}
