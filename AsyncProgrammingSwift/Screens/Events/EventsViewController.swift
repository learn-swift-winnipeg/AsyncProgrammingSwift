import UIKit

// MARK: - EventsViewControllerDelegate

protocol EventsViewControllerDelegate: ImageProvider {
    func didUpdateURLsForVisibleImages(urls: [URL])
}

// MARK: - EventsViewController

class EventsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Stored Properties
    
    weak var delegate: EventsViewControllerDelegate?
    
    enum Table {
        enum Section {
            case groupHeader(groupHeaderCellData: GroupHeaderCellData)
            case events(rows: [EventCellData])
        }
    }
    private var tableSections: [Table.Section] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        tableView.prefetchDataSource = nil
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 240
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Update
    
    func update(with viewData: EventsViewData, reloadTableView: Bool) {
        self.loadViewIfNeeded()
        
        self.tableSections = viewData.tableSections
        
        if reloadTableView {
            tableView.reloadData()
        }
    }
    
    func imageDataUpdated(for url: URL) {
        tableView.visibleCells
            .flatMap({ $0 as? ImageUpdateable })
            .forEach({ $0.imageDataUpdated(for: url) })
    }
}

// MARK: - UITableViewDataSource

extension EventsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return CGFloat.leastNonzeroMagnitude
        default: return 50
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableSections[section] {
        case .groupHeader: return nil
        case .events: return "Meetups"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableSections[section] {
        case .groupHeader: return 1
        case .events(let rows): return rows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableSections[indexPath.section] {
        case .groupHeader(let groupHeaderCellData):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "groupHeaderCell",
                for: indexPath
            ) as! GroupHeaderCell
            
            cell.update(with: groupHeaderCellData)
            
            return cell
            
        case .events(let rows):
            let eventCellData = rows[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "eventCell",
                for: indexPath
            ) as! EventCell
            
            cell.update(with: eventCellData)
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension EventsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath)
    {
        // Something just went out of view, report back to delegate all urls for images which are still visible.
        let urlsForVisibleUpdateableImageViews = tableView.visibleCells
            .flatMap({ $0 as? ImageUpdateable })
            .flatMap({ $0.updateableImageViews })
            .flatMap({ $0.url })
        
        delegate?.didUpdateURLsForVisibleImages(
            urls: urlsForVisibleUpdateableImageViews
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath)
    {
        // Something just went out of view, report back to delegate all urls for images which are still visible.
        let urlsForVisibleUpdateableImageViews = tableView.visibleCells
            .flatMap({ $0 as? ImageUpdateable })
            .flatMap({ $0.updateableImageViews })
            .flatMap({ $0.url })
        
        delegate?.didUpdateURLsForVisibleImages(
            urls: urlsForVisibleUpdateableImageViews
        )
    }
}

// MARK: - LoadableFromStoryboard

extension EventsViewController: LoadableFromStoryboard {
    static var storyboardFilename: String { return "Events" }
}
