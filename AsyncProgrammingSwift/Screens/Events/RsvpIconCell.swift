import UIKit

// MARK: - RsvpIconCellData

struct RsvpIconCellData {
    let imageURL: URL
    let imageProvider: ImageProvider
    
    init(rsvp: Rsvp, imageProvider: ImageProvider) {
        self.imageURL = rsvp.memberThumbnailURL
        self.imageProvider = imageProvider
    }
}

// MARK: - RsvpIconCell

class RsvpIconCell: UICollectionViewCell, ImageUpdateable {
    
    // MARK: - Outlets
    
    @IBOutlet var rsvpImageView: UpdateableImageView!
    
    // MARK: - ImageUpdateable
    
    private(set) weak var imageProvider: ImageProvider?
    var updateableImageViews: [UpdateableImageView] {
        return [rsvpImageView]
    }
    
    // MARK: - Update
    
    func update(with viewData: RsvpIconCellData) {
        imageProvider = viewData.imageProvider
        
        rsvpImageView.url = viewData.imageURL
        rsvpImageView.image = nil
        
        attemptToLoadImageDataFromDelegate()
    }
}
