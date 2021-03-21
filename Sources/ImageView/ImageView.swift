import UIKit

open class ImageView: UIImageView {
    
    static var imageCacheType: ImageCacheType = .session

    // MARK: - Placeholder
    public struct Placeholder {
        private var _image: UIImage?
        var color: UIColor?
        var image: UIImage? {
            set {
                _image = newValue
            }
            get {
                if let color = color {
                    return _image?.withTintColor(color, renderingMode: .alwaysOriginal)
                } else {
                    return _image
                }
            }
        }
    }

    // MARK: - properties
    private var tapAction: Action?
    
    public var placeholder: Placeholder
    
    private var imageLoader: ImageLoaderProtocol

    // MARK: - init
    override public init(frame: CGRect) {
        self.imageLoader = ImageLoader(imageSaver: ImageView.imageCacheType.getImageSaver())
        self.placeholder = Placeholder()
        super.init(frame: frame)
    }
    
    public convenience init(imageSaver: ImageSaverProtocol) {
        self.init(frame: .zero)
        self.imageLoader = ImageLoader(imageSaver: imageSaver)
    }

    required public init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - load image
    public func loadImage(_ link: String?, completion: ((Bool) -> ())? = nil) {
        imageLoader.loadImage(link) { [weak self] (img) in
            guard let `self` = self else { return }
            self.image = self.placeholder.image
            if let img = img {
                self.image = img
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }

    // MARK: - tap
    open func setTapAction(_ action: @escaping Action) {
        self.isUserInteractionEnabled = true
        self.tapAction = action
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapAction?()
    }

}

