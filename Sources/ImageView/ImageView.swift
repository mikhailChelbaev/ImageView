import UIKit

open class ImageView: UIImageView {
    
    // MARK: - Placeholder
    public struct Placeholder {
        
        private var _image: UIImage?
        
        public var color: UIColor?
        
        public var image: UIImage? {
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
        
        public init(image: UIImage? = nil, color: UIColor? = nil) {
            self.image = image
            self.color = color
        }
    }
    
    static var imageCacheType: ImageCacheType = .session

    // MARK: - properties
    private var tapAction: Action? {
        didSet {
            tapGesture.isEnabled = tapAction != nil
        }
    }
    
    public var placeholder: Placeholder {
        didSet {
            if image == nil {
                image = placeholder.image
            }
        }
    }
    
    public private(set) var isImageLoaded: Bool = false
    
    private var imageLoader: ImageLoaderProtocol
    
    private var tapGesture: UITapGestureRecognizer

    // MARK: - init
    override public init(frame: CGRect) {
        self.imageLoader = ImageLoader(imageSaver: ImageView.imageCacheType.getImageSaver())
        self.placeholder = Placeholder()
        self.tapGesture = UITapGestureRecognizer()
        super.init(frame: frame)
        
        tapGesture.addTarget(self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        tapGesture.isEnabled = false
    }
    
    public convenience init(imageSaver: ImageSaverProtocol) {
        self.init(frame: .zero)
        self.imageLoader = ImageLoader(imageSaver: imageSaver)
    }

    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - life cycle
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !isImageLoaded, let placeholderImage = placeholder.image {
            self.image = placeholderImage
        }
    }

    // MARK: - load image
    public func loadImage(_ link: String?, completion: ((Bool) -> ())? = nil) {
        image = placeholder.image
        imageLoader.loadImage(link) { [weak self] (img) in
            guard let `self` = self else { return }
            if let img = img {
                self.image = img
                self.isImageLoaded = true
                completion?(true)
            } else {
                self.isImageLoaded = false
                completion?(false)
            }
        }
    }

    // MARK: - tap
    open func setTapAction(_ action: @escaping Action) {
        self.isUserInteractionEnabled = true
        self.tapAction = action
    }

    @objc private func handleTap() {
        tapAction?()
    }

}

