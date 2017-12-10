import UIKit

// MARK: - EventsViewControllerDelegate

protocol EventsViewControllerDelegate: AnyObject {
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
            case upcomingEvents(rows: [EventCellData])
            case pastEvents(rows: [EventCellData])
        }
        
        enum RowUpdateOption {
            case allRows
            case groupHeaderRow(groupHeaderCellData: GroupHeaderCellData)
            case eventRow(eventCellData: EventCellData)
            case noRows
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
    
    func update(with viewData: EventsViewData, rowUpdateOption: Table.RowUpdateOption) {
        self.tableSections = viewData.tableSections
        
        switch rowUpdateOption {
        case .allRows:
            tableView.reloadData()
            
        case .groupHeaderRow(let groupHeaderCellData):
            guard let indexPath = indexPathOfGroupHeader() else {
                tableView.reloadData()
                return
            }

            guard let groupHeaderCell = tableView.cellForRow(at: indexPath) as? GroupHeaderCell else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                return
            }
            
            groupHeaderCell.update(with: groupHeaderCellData)
            
        case .eventRow(let eventCellData):
            guard let indexPath = indexPath(of: eventCellData) else {
                tableView.reloadData()
                return
            }
            
            guard let eventCell = tableView.cellForRow(at: indexPath) as? EventCell else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                return
            }
            
            eventCell.update(with: eventCellData)
            
        case .noRows:
            break
        }
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
                break
                
            case .upcomingEvents(let rows):
                if let rowIndex = rows.index(where: { $0.eventId == eventCellData.eventId }) {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
                
            case .pastEvents(let rows):
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
        case .upcomingEvents: return "Upcoming"
        case .pastEvents: return "Past"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableSections[section] {
        case .groupHeader: return 1
        case .upcomingEvents(let rows), .pastEvents(let rows): return rows.count
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
            
        case .upcomingEvents(let rows), .pastEvents(let rows):
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
        print(type(of: self), #function, indexPath)
        switch tableSections[indexPath.section] {
        case .groupHeader(let groupHeaderCellData):
            delegate?.willDisplayRow(forGroupId: groupHeaderCellData.groupId)
            
        case .upcomingEvents(let rows), .pastEvents(let rows):
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
            
        case .upcomingEvents(let rows), .pastEvents(let rows):
            let eventCellData = rows[indexPath.row]
            delegate?.didEndDisplayingRow(forEventId: eventCellData.eventId)
        }
    }
}

// MARK: - LoadableFromStoryboard

extension EventsViewController: LoadableFromStoryboard {
    static var storyboardFilename: String { return "Events" }
}
