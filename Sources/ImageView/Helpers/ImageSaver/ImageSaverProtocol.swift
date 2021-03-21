import UIKit

public protocol ImageSaverProtocol {
    func saveImage(image: UIImage, name: String)
    func getImage(name: String) -> UIImage?
}
