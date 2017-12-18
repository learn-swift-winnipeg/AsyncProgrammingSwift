import UIKit

// MARK: - EventsViewControllerDelegate

protocol EventsViewControllerDelegate: ImageProvider {
    func willDisplayRow(forGroupId groupId: String)
    func willDisplayRow(forEventId eventId: String)
    
    func didEndDisplayingRow(forGroupId groupId: String)
    func didEndDisplayingRow(forEventId eventId: String)
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
    
    // MARK: - IndexPath Lookup
    
    private func indexPathOfGroupHeader() -> IndexPath? {
        guard let section = tableSections.index(where: {
            switch $0 {
            case .groupHeader: return true
            default: return false
            }
        }) else { return nil }
        
        return IndexPath(row: 0, section: section)
    }
    
    private func indexPath(of eventCellData: EventCellData) -> IndexPath? {
        for (sectionIndex, tableSection) in tableSections.enumerated() {
            switch tableSection {
            case .groupHeader:
                return nil
                
            case .events(let rows):
                if let rowIndex = rows.index(where: { $0.eventId == eventCellData.eventId }) {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        
        return nil
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
        // Ask delegate for imageData which may return nil if image not yet available.
        
        switch tableSections[indexPath.section] {
        case .groupHeader(let groupHeaderCellData):
            delegate?.willDisplayRow(forGroupId: groupHeaderCellData.groupId)
            
        case .events(let rows):
            let eventCellData = rows[indexPath.row]
            delegate?.willDisplayRow(forEventId: eventCellData.eventId)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath)
    {
        switch tableSections[indexPath.section] {
        case .groupHeader(let groupHeaderCellData):
            delegate?.didEndDisplayingRow(forGroupId: groupHeaderCellData.groupId)
            
        case .events(let rows):
            let eventCellData = rows[indexPath.row]
            delegate?.didEndDisplayingRow(forEventId: eventCellData.eventId)
        }
    }
}

// MARK: - LoadableFromStoryboard

extension EventsViewController: LoadableFromStoryboard {
    static var storyboardFilename: String { return "Events" }
}
