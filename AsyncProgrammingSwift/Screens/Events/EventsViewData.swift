import Foundation

struct EventsViewData {
    
    // MARK: - Stored Properties
    
    let tableSections: [EventsViewController.Table.Section]
    
    // MARK: - Lifecycle
    
    init(
        groupHeaderCellData: GroupHeaderCellData,
        upcomingEventCellData: [EventCellData],
        pastEventCellData: [EventCellData])
    {
        tableSections = [
            .groupHeader(groupHeaderCellData: groupHeaderCellData),
            .upcomingEvents(rows: upcomingEventCellData),
            .pastEvents(rows: pastEventCellData)
        ]
    }
}
