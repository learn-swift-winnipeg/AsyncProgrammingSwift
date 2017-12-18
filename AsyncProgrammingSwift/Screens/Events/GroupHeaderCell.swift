import UIKit

// MARK: - GroupHeaderCellData

struct GroupHeaderCellData {
    
    // MARK: - Stored Properties
    
    let groupId: String
    
    let groupImageURL: URL
    let groupNameText: String
    
    let locationDescriptionText: String
    let locationValueText: String
    
    let memberCountDescriptionText: String
    let memberCountValueText: String
    
    let imageProvider: ImageProvider
    
    // MARK: - Lifecycle
    
    init(group: Group, imageProvider: ImageProvider) {
        self.groupId = group.id
        
        self.groupImageURL = group.keyPhotoURL
        self.groupNameText = group.name
        
        self.locationDescriptionText = "Location"
        self.locationValueText = group.localizedLocation
        
        self.memberCountDescriptionText = "Members"
        self.memberCountValueText = String(group.memberCount)
        
        self.imageProvider = imageProvider
    }
}

// MARK: - GroupHeaderCell

class GroupHeaderCell: UITableViewCell, ImageUpdateable {
    
    // MARK: - Outlets
    
    @IBOutlet var groupImageView: UpdateableImageView!
    @IBOutlet var groupNameLabel: UILabel!
    
    @IBOutlet var locationDescriptionLabel: UILabel!
    @IBOutlet var locationValueLabel: UILabel!
    
    @IBOutlet var memberCountDescriptionLabel: UILabel!
    @IBOutlet var memberCountValueLabel: UILabel!
    
    // MARK: - ImageUpdateable
    
    private(set) weak var imageProvider: ImageProvider?
    
    var updateableImageViews: [UpdateableImageView] {
        return [groupImageView]
    }
    
    // MARK: - Update
    
    func update(with viewData: GroupHeaderCellData) {
        imageProvider = viewData.imageProvider
        
        groupImageView.url = viewData.groupImageURL
        groupImageView.image = nil
        groupNameLabel.text = viewData.groupNameText
        
        locationDescriptionLabel.text = viewData.locationDescriptionText
        locationValueLabel.text = viewData.locationValueText
        
        memberCountDescriptionLabel.text = viewData.memberCountDescriptionText
        memberCountValueLabel.text = viewData.memberCountValueText
        
        attemptToLoadImageDataFromDelegate()
    }
}
