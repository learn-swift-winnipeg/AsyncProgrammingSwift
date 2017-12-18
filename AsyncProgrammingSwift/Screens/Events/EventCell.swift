import UIKit

// MARK: - EventCellData

struct EventCellData {
    
    // MARK: - Stored Properties
    
    let eventId: String
    
    let dateIconDayText: String
    let dateIconMonthText: String
    
    let dateText: String
    let eventNameText: String
    
    let eventDescriptionText: String
    
    let rsvpIconCellData: [RsvpIconCellData]
    
    // MARK: - Lifecycle
    
    init(event: Event, rsvpIconCellData: [RsvpIconCellData]) {
        self.eventId = event.id
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd"
        self.dateIconDayText = dateFormatter.string(from: event.startTime)
        
        dateFormatter.dateFormat = "MMM"
        self.dateIconMonthText = dateFormatter.string(from: event.startTime).uppercased()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.dateText = dateFormatter.string(from: event.startTime)
        self.eventNameText = event.name
        
        self.eventDescriptionText = event.eventDescription
        
        self.rsvpIconCellData = rsvpIconCellData
    }
}

// MARK: - EventCell

class EventCell: UITableViewCell, ImageUpdateable {
    var imageProvider: ImageProvider? = nil
    
    var updateableImageViews: [UpdateableImageView] {
        return rsvpIconCollectionView.visibleCells
            .flatMap({ $0 as? ImageUpdateable })
            .flatMap({ $0.updateableImageViews })
    }
    
    func imageDataUpdated(for url: URL) {
        rsvpIconCollectionView.visibleCells
            .flatMap({ $0 as? ImageUpdateable })
            .forEach({ $0.imageDataUpdated(for: url) })
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var dateIconDayLabel: UILabel!
    @IBOutlet var dateIconMonthLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var eventNameLabel: UILabel!
    
    @IBOutlet var eventDescriptionLabel: UILabel!
    
    @IBOutlet var rsvpIconCollectionView: UICollectionView!
    
    // MARK: - Stored Properties
    
    private var rsvps: [RsvpIconCellData] = []
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        rsvpIconCollectionView.dataSource = self
    }
    
    // MARK: - Update
    
    func update(with viewData: EventCellData) {
        self.dateIconDayLabel.text = viewData.dateIconDayText
        self.dateIconMonthLabel.text = viewData.dateIconMonthText
        
        self.dateLabel.text = viewData.dateText
        self.eventNameLabel.text = viewData.eventNameText
        
        self.eventDescriptionLabel.text = viewData.eventDescriptionText
        
        self.rsvps = viewData.rsvpIconCellData
        
        self.rsvpIconCollectionView.reloadData()
        self.rsvpIconCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
    }
}

// MARK: - UICollectionViewDataSource

extension EventCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return rsvps.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "rsvpIconCell",
            for: indexPath
        ) as! RsvpIconCell
        
        let viewData = rsvps[indexPath.row]
        cell.update(with: viewData)
        
        return cell
    }
}

