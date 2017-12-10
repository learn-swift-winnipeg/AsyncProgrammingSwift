import UIKit

// MARK: - FirstTabCoordinator

class FirstTabCoordinator: TabCoordinator {
    
    // MARK: - Stored Properties
    
    let providers: Providers
    let eventsViewController: EventsViewController
    
    var meetupSchedule: MeetupSchedule?
    
    // MARK: - Lifecycle
    
    init(
        providers: Providers,
        eventsViewController: EventsViewController)
    {
        self.providers = providers
        self.eventsViewController = eventsViewController
        self.eventsViewController.delegate = self
    }
    
    func start() {
        // TODO: Implement.
        eventsViewController.loadViewIfNeeded()
        
        fetchMeetupScheduleAndUpdateUI()
    }
    
    // MARK: - Fetching
    
    private func fetchMeetupScheduleAndUpdateUI() {
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
}

// MARK: - EventsViewControllerDelegate

extension FirstTabCoordinator: EventsViewControllerDelegate {
    func willDisplayRow(forGroupId groupId: String) {
        guard let meetupSchedule = self.meetupSchedule else { return }
        let group = meetupSchedule.group
        let imageUrl = group.keyPhotoUrl
        
        do {
            try providers.imageCacheProvider.fetchAndCacheImageSynchronously(from: imageUrl)
            DispatchQueue.main.async {
                self.updateUI(rowUpdateOption: .groupHeaderRow)
            }
        } catch {
            // TODO: Handle error.
            print(error)
        }
    }
    
    func willDisplayRow(forEventId eventId: String) {
        guard let meetupSchedule = self.meetupSchedule else { return }
        
        
        for eventWithRsvps in meetupSchedule.eventsWithRsvps.filter({ $0.event.id == eventId }) {
            for rsvp in eventWithRsvps.rsvps {
                let imageUrl = rsvp.memberThumbnailUrl
                
                do {
                    try providers.imageCacheProvider.fetchAndCacheImageSynchronously(from: imageUrl)
                    DispatchQueue.main.async {
                        self.updateUI(rowUpdateOption: .eventRow(event: eventWithRsvps.event))
                    }
                } catch {
                    // TODO: Handle error.
                    print(error, "rsvp.id: \(rsvp.id)")
                }
            }
        }
    }
    
    func didEndDisplayingRow(forGroupId groupId: String) {
        // TODO: Implement.
        print(type(of: self), #function)
    }
    
    func didEndDisplayingRow(forEventId eventId: String) {
        // TODO: Implement.
        print(type(of: self), #function)
    }
    
    
}
