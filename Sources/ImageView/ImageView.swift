import UIKit

// MARK: - ImageCreation
public typealias ImageCreation = () -> UIImage?
public typealias ResultCompletion = (Bool) -> Void


// MARK: - ImageView
open class ImageView: UIImageView {
    
    // MARK: - Placeholder
    public enum Placeholder {
        
        @available(iOS 13.0, *) case symbol(name: String, tintColor: UIColor? = nil)
        case image(UIImage)
        case `func`(ImageCreation)
        case none

        public var image: UIImage? {
            switch self {
            case .symbol(let name, let tintColor):
                if #available(iOS 13.0, *) {
                    let image = UIImage(systemName: name)
                    if let tintColor = tintColor {
                        return image?.withTintColor(tintColor).withTintColor(tintColor, renderingMode: .alwaysOriginal)
                    }
                    return image
                }
                return nil
            case .image(let img):
                return img
            case .func(let creation):
                return creation()
            case .none:
                return nil
            }
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
        self.placeholder = .none
        self.tapGesture = UITapGestureRecognizer()
        
        super.init(frame: frame)
        
        self.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(handleTap))
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
    public func loadImage(_ link: String?, completion: ResultCompletion? = nil) {
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

