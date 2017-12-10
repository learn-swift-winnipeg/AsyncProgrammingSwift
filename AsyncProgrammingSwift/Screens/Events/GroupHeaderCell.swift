import UIKit

// MARK: - GroupHeaderCellData

struct GroupHeaderCellData {
    
    // MARK: - Stored Properties
    
    let groupId: String
    
    let groupImage: UIImage?
    let groupNameText: String
    
    let locationDescriptionText: String
    let locationValueText: String
    
    let memberCountDescriptionText: String
    let memberCountValueText: String
    
    // MARK: - Lifecycle
    
    init(group: Group, groupImage: UIImage?) {
        self.groupId = group.id
        
        self.groupImage = groupImage
        self.groupNameText = group.name
        
        self.locationDescriptionText = "Location"
        self.locationValueText = group.localizedLocation
        
        self.memberCountDescriptionText = "Members"
        self.memberCountValueText = String(group.memberCount)
    }
}

// MARK: - GroupHeaderCell

class GroupHeaderCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupNameLabel: UILabel!
    
    @IBOutlet var locationDescriptionLabel: UILabel!
    @IBOutlet var locationValueLabel: UILabel!
    
    @IBOutlet var memberCountDescriptionLabel: UILabel!
    @IBOutlet var memberCountValueLabel: UILabel!
    
    // MARK: - Update
    
    func update(with viewData: GroupHeaderCellData) {
        groupImageView.image = viewData.groupImage
        groupNameLabel.text = viewData.groupNameText
        
        locationDescriptionLabel.text = viewData.locationDescriptionText
        locationValueLabel.text = viewData.locationValueText
        
        memberCountDescriptionLabel.text = viewData.memberCountDescriptionText
        memberCountValueLabel.text = viewData.memberCountValueText
    }
}
