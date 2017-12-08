import UIKit

// MARK: - RsvpIconCellData

struct RsvpIconCellData {
    let rsvpImage: UIImage?
}

// MARK: - RsvpIconCell

class RsvpIconCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var rsvpImageView: UIImageView!
    
    // MARK: - Update
    
    func update(with viewData: RsvpIconCellData) {
        rsvpImageView.image = viewData.rsvpImage
    }
}
