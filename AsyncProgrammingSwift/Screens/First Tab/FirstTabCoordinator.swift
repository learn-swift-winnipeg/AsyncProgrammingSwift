import UIKit

// MARK: - FirstTabCoordinator

class FirstTabCoordinator {
    
    // MARK: - Stored Properties
    
    private let providers: Providers
    private let eventsViewController: EventsViewController
    
    // MARK: - Lifecycle
    
    init(
        providers: Providers,
        eventsViewController: EventsViewController)
    {
        self.providers = providers
        self.eventsViewController = eventsViewController
    }
    
    func start() {
        // TODO: Implement.
        eventsViewController.loadViewIfNeeded()
        
        let group = Group(
            id: "test",
            name: "Testing Meetup Group",
            localizedLocation: "Notre Dame de Lourdes, MB",
            memberCount: 2
        )
        var groupHeaderCellData = GroupHeaderCellData(
            group: group,
            groupImage: nil
        )
        
        let upcomingEvent = Event(
            id: "245590889",
            status: .upcoming,
            startTime: Date(timeIntervalSince1970: 1513814400000 / 1000),
            name: "Asynchronous Programming in Swift along with other interesting things!",
            eventDescription: "Perhaps we should ditch this field... it will require too much effort to strip the html out."
        )
        let upcomingRsvpIconCellData = [
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil)
        ]
        var upcomingEventCellData = EventCellData(
            event: upcomingEvent,
            rsvpIconCellData: upcomingRsvpIconCellData
        )
        
        let pastEvent = Event(
            id: "237981458",
            status: .past,
            startTime: Date(timeIntervalSince1970: 1489017600000 / 1000),
            name: "Application Architecture: Presenters & View Models (MVP & MVVM)",
            eventDescription: "Perhaps we should ditch this field... it will require too much effort to strip the html out."
        )
        let pastRsvpIconCellData = [
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
            RsvpIconCellData(rsvpImage: nil),
        ]
        let pastEventCellData = EventCellData(
            event: pastEvent,
            rsvpIconCellData: pastRsvpIconCellData
        )
        
        let viewData = EventsViewData(
            groupHeaderCellData: groupHeaderCellData,
            upcomingEventCellData: [upcomingEventCellData],
            pastEventCellData: [pastEventCellData, pastEventCellData, pastEventCellData]
        )
        eventsViewController.update(
            with: viewData,
            rowUpdateOption: .allRows
        )
        
        DispatchQueue.main.asyncAfter(seconds: 1) {
            groupHeaderCellData = GroupHeaderCellData(
                group: group,
                groupImage: #imageLiteral(resourceName: "FirstUI Tab Icon")
            )
            
            let viewData = EventsViewData(
                groupHeaderCellData: groupHeaderCellData,
                upcomingEventCellData: [upcomingEventCellData],
                pastEventCellData: [pastEventCellData, pastEventCellData, pastEventCellData]
            )
            self.eventsViewController.update(
                with: viewData,
                rowUpdateOption: .groupHeaderRow(groupHeaderCellData: groupHeaderCellData)
            )
        }
        
        DispatchQueue.main.asyncAfter(seconds: 2) {
            let upcomingRsvpIconCellData = [
                RsvpIconCellData(rsvpImage: #imageLiteral(resourceName: "FirstUI Tab Icon")),
                RsvpIconCellData(rsvpImage: nil),
                RsvpIconCellData(rsvpImage: nil)
            ]
            upcomingEventCellData = EventCellData(event: upcomingEvent, rsvpIconCellData: upcomingRsvpIconCellData)
            
            let viewData = EventsViewData(
                groupHeaderCellData: groupHeaderCellData,
                upcomingEventCellData: [upcomingEventCellData],
                pastEventCellData: [pastEventCellData, pastEventCellData, pastEventCellData]
            )
            self.eventsViewController.update(
                with: viewData,
                rowUpdateOption: .eventRow(eventCellData: upcomingEventCellData)
            )
        }
        
        DispatchQueue.main.asyncAfter(seconds: 3) {
            let upcomingRsvpIconCellData = [
                RsvpIconCellData(rsvpImage: #imageLiteral(resourceName: "FirstUI Tab Icon")),
                RsvpIconCellData(rsvpImage: #imageLiteral(resourceName: "SecondUI Tab Icon")),
                RsvpIconCellData(rsvpImage: nil)
            ]
            upcomingEventCellData = EventCellData(event: upcomingEvent, rsvpIconCellData: upcomingRsvpIconCellData)
            
            let viewData = EventsViewData(
                groupHeaderCellData: groupHeaderCellData,
                upcomingEventCellData: [upcomingEventCellData],
                pastEventCellData: [pastEventCellData, pastEventCellData, pastEventCellData]
            )
            self.eventsViewController.update(
                with: viewData,
                rowUpdateOption: .eventRow(eventCellData: upcomingEventCellData)
            )
        }
        
        DispatchQueue.main.asyncAfter(seconds: 4) {
            let upcomingRsvpIconCellData = [
                RsvpIconCellData(rsvpImage: #imageLiteral(resourceName: "FirstUI Tab Icon")),
                RsvpIconCellData(rsvpImage: #imageLiteral(resourceName: "SecondUI Tab Icon")),
                RsvpIconCellData(rsvpImage: #imageLiteral(resourceName: "ThirdUI Tab Icon"))
            ]
            upcomingEventCellData = EventCellData(event: upcomingEvent, rsvpIconCellData: upcomingRsvpIconCellData)
            
            let viewData = EventsViewData(
                groupHeaderCellData: groupHeaderCellData,
                upcomingEventCellData: [upcomingEventCellData],
                pastEventCellData: [pastEventCellData, pastEventCellData, pastEventCellData]
            )
            self.eventsViewController.update(
                with: viewData,
                rowUpdateOption: .eventRow(eventCellData: upcomingEventCellData)
            )
        }
    }
}
