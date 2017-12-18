import UIKit

protocol ImageProvider: AnyObject {
    func image(for url: URL) -> UIImage?
}

protocol ImageUpdateable {
    var imageProvider: ImageProvider? { get }
    var updateableImageViews: [UpdateableImageView] { get }
    func attemptToLoadImageDataFromDelegate()
    func imageDataUpdated(for url: URL)
}

extension ImageUpdateable {
    func attemptToLoadImageDataFromDelegate() {
        updateableImageViews.forEach {
            guard let url = $0.url else { return }
            $0.image = imageProvider?.image(for: url)
        }
    }
    
    func imageDataUpdated(for url: URL) {
        updateableImageViews
            .filter({ url == $0.url })
            .forEach({ $0.image = self.imageProvider?.image(for: url) })
    }
}
