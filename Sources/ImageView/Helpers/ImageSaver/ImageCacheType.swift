import UIKit

public enum ImageCacheType {
    case session, folder, combined
    
    func getImageSaver() -> ImageSaverProtocol {
        switch self {
        case .session:
            return SessionImageSaver()
        case .folder:
            return AppFolderImageSaver()
        case .combined:
            return CombinedImageSaver()
        }
    }
}
