import UIKit

public enum ImageItem {
    case image(UIImage)
    case link(String)
}

public protocol ImageDataSource: class {
    func numberOfImages() -> Int
    func imageItem(at index:Int) -> ImageItem
}

public class DefaultImageDataSource: ImageDataSource {
    private var items: [ImageItem]
    
    public init(items: [ImageItem]) {
        self.items = items
    }
    
    public func numberOfImages() -> Int {
        items.count
    }
    
    public func imageItem(at index: Int) -> ImageItem {
        items[index]
    }
}
