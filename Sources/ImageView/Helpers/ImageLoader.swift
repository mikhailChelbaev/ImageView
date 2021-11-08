import UIKit

fileprivate extension String {
    func getContentName() -> String? {
        URL(string: self)?.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
}

public protocol ImageLoaderProtocol {
    func loadImage(_ link: String?, completion: @escaping (UIImage?) -> ())
}

public class ImageLoader: ImageLoaderProtocol {
    public var imageSaver: ImageSaverProtocol
    
    private var lastURLUsedToLoadImage: String?
    
    public init(imageSaver: ImageSaverProtocol) {
        self.imageSaver = imageSaver
    }
    
    public func loadImage(_ link: String?, completion: @escaping (UIImage?) -> ()) {
        self.lastURLUsedToLoadImage = link

        guard let link = link, let name = link.getContentName() else {
            completion(nil)
            return
        }
        
        if let cacheImage = imageSaver.getImage(name: name) {
            completion(cacheImage)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            if let url = URL(string: link) {
                URLSession.shared.dataTask(with: url) { (data, _, _) in
                    guard self.lastURLUsedToLoadImage == link else { return }
                    if let data = data, let img = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageSaver.saveImage(image: img, name: name)
                            completion(img)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }.resume()
            }
        }
    }
    
}
