import UIKit

// MARK: - TabCoordinator

protocol TabCoordinator: AnyObject {
    var providers: Providers { get }
    var meetupSchedule: MeetupSchedule? { get set }
    var eventsViewController: EventsViewController { get }
}

// MARK: - RowUpdateOption

enum RowUpdateOption {
    case allRows
    case groupHeaderRow
    case eventRow(event: Event)
    case noRows
}

// MARK: - Extension

extension TabCoordinator {
    func fetchMeetupScheduleAndUpdateUI() {
        providers.meetupProvider.fetchMeetupSchedule(
            forGroupUrlname: "learn-swift-winnipeg",
            resultQueue: .main)
        { result in
            switch result {
            case .failure(let error):
                // TODO: Handle error.
                print(error)
                
            case .success(let meetupSchedule):
                self.meetupSchedule = meetupSchedule
                self.updateUI(rowUpdateOption: .allRows)
            }
        }
    }
    
    func updateUI(rowUpdateOption: RowUpdateOption) {
        guard let meetupSchedule = self.meetupSchedule else { return }
        let imageCache = providers.imageCacheProvider.imageCache
        
        let groupHeaderCellData = GroupHeaderCellData(
            group: meetupSchedule.group,
            groupImage: imageCache[meetupSchedule.group.keyPhotoUrl]
        )
        
        let now = Date()
        let upcomingEventsWithRsvps = meetupSchedule.eventsWithRsvps.filter({ $0.event.startTime > now })
        let pastEventsWithRsvps = meetupSchedule.eventsWithRsvps.filter({ $0.event.startTime <= now })
        
        let upcomingEventCellData: [EventCellData] = upcomingEventsWithRsvps.map {
            let rsvpIconCellData = $0.rsvps.map({ rsvp in
                RsvpIconCellData(rsvpImage: imageCache[rsvp.memberThumbnailUrl])
            })
            
            return EventCellData(event: $0.event, rsvpIconCellData: rsvpIconCellData)
        }
        
        let pastEventCellData: [EventCellData] = pastEventsWithRsvps.map {
            let rsvpIconCellData = $0.rsvps.map({ rsvp in
                RsvpIconCellData(rsvpImage: imageCache[rsvp.memberThumbnailUrl])
            })
            return EventCellData(event: $0.event, rsvpIconCellData: rsvpIconCellData)
        }
        
        let eventsViewData = EventsViewData(
            groupHeaderCellData: groupHeaderCellData,
            upcomingEventCellData: upcomingEventCellData,
            pastEventCellData: pastEventCellData
        )
        
        let eventsVCRowUpdateOption: EventsViewController.Table.RowUpdateOption
        
        switch rowUpdateOption {
        case .allRows:
            eventsVCRowUpdateOption = .allRows
            
        case .groupHeaderRow:
            eventsVCRowUpdateOption = .groupHeaderRow(groupHeaderCellData: groupHeaderCellData)
            
        case .eventRow(let event):
            guard let eventCellData = upcomingEventCellData.first(where: { $0.eventId == event.id })
                ?? pastEventCellData.first(where: { $0.eventId == event.id })
                else {
                    eventsVCRowUpdateOption = .allRows
                    return
            }
            eventsVCRowUpdateOption = .eventRow(eventCellData: eventCellData)
            
        case .noRows:
            eventsVCRowUpdateOption = .noRows
        }
        
        self.eventsViewController.update(
            with: eventsViewData,
            rowUpdateOption: eventsVCRowUpdateOption
        )
    }
}
