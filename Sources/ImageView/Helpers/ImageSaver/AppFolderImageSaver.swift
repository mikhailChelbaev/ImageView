import UIKit

public class AppFolderImageSaver: ImageSaverProtocol {
    
    public func saveImage(image: UIImage, name: String) {
        var data: Data?
        if name.contains("jpeg") || name.contains("jpg") {
            data = image.jpegData(compressionQuality: 1)
        } else if name.contains("png") {
            data = image.pngData()
        }
        guard let imgData = data else { return }

        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try imgData.write(to: directory.appendingPathComponent(name)!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    public func getImage(name: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
           let image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name).path) {
            return image
        }
        return nil
    }
}
