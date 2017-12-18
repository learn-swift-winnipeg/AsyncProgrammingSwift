import Foundation

struct EventsViewData {
    
    // MARK: - Stored Properties
    
    let tableSections: [EventsViewController.Table.Section]
    
    // MARK: - Lifecycle
    
    init(
        groupHeaderCellData: GroupHeaderCellData,
        eventCellData: [EventCellData])
    {
        tableSections = [
            .groupHeader(groupHeaderCellData: groupHeaderCellData),
            .events(rows: eventCellData)
        ]
    }
}
