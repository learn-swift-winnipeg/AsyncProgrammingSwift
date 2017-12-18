import UIKit

// MARK: - TabCoordinator

protocol TabCoordinator: EventsViewControllerDelegate {
    var providers: Providers { get }
    var meetupSchedule: MeetupSchedule? { get set }
    var eventsViewController: EventsViewController { get }
}

// MARK: - Extension

extension TabCoordinator {
    
    // MARK: - Fetch
    
    func fetchMeetupScheduleAndUpdateUI() {
        providers.meetupProvider.fetchMeetupSchedule(
            forGroupURLname: "learn-swift-winnipeg",
            resultQueue: .main)
        { result in
            switch result {
            case .failure(let error):
                // TODO: Handle error.
                print(error)
                
            case .success(let meetupSchedule):
                self.meetupSchedule = meetupSchedule
                self.updateUI(reloadTableView: true)
            }
        }
    }
    
    // MARK: - Update
    
    func updateUI(reloadTableView: Bool) {
        guard let meetupSchedule = self.meetupSchedule else { return }
        
        let groupHeaderCellData = GroupHeaderCellData(group: meetupSchedule.group, imageProvider: self)
        
        let eventCellData: [EventCellData] = meetupSchedule.eventsWithRsvps.map {
            let rsvpIconCellData = $0.rsvps.map({ RsvpIconCellData(rsvp: $0, imageProvider: self) })
            
            return EventCellData(event: $0.event, rsvpIconCellData: rsvpIconCellData)
        }
        
        let eventsViewData = EventsViewData(
            groupHeaderCellData: groupHeaderCellData,
            eventCellData: eventCellData
        )
        
        self.eventsViewController.update(
            with: eventsViewData,
            reloadTableView: reloadTableView
        )
    }
}

// MARK: - EventsViewControllerDelegate

extension TabCoordinator {
    func didUpdateURLsForVisibleImages(urls: [URL]) {
        // TODO: Implement in conforming types when needed.
    }
}
