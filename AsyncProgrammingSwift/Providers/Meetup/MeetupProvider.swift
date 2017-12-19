import Foundation

// MARK: - MeetupProvider

protocol MeetupProvider {
    func fetchMeetupSchedule(
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<MeetupSchedule>) -> Void
    )
}

// MARK: - TestingMeetupProvider

class TestingMeetupProvider: MeetupProvider {
    
    // MARK: - Stored Properties
    
    private let minFetchDelay: TimeInterval = 0.0
    private let maxFetchDelay: TimeInterval = 2.0
    
    // MARK: - Fetching
    
    func fetchMeetupSchedule(
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<MeetupSchedule>) -> Void)
    {
        let group = Group(
            id: "test",
            keyPhotoURL: URL(string: "https://secure.meetupstatic.com/photos/event/b/d/e/7/600_464328615.jpeg")!,
            name: "Testing Meetup Group",
            localizedLocation: "Notre Dame de Lourdes, MB",
            memberCount: 2
        )
        
        let eventsWithRsvps = (1...100).map({ _ in
            return MeetupSchedule.EventWithRsvps(
                event: .random,
                rsvps: (0...Int.random(lower: 5, upper: 10)).map({ _ in .random })
            )
        })
        
        let meetupSchedule = MeetupSchedule(
            group: group,
            eventsWithRsvps: eventsWithRsvps
        )
        
        resultQueue.asyncAfter(seconds: 0.0) {
            resultHandler( .success(meetupSchedule) )
        }
    }
}

extension Event {
    static var random: Event {
        let uuidString = UUID().uuidString
        
        return Event (
            id: uuidString,
            startTime: .randomPastDateWithinOneYear,
            name: "Random name: \(uuidString)"
        )
    }
}

extension Date {
    static var randomPastDateWithinOneYear: Date {
        let roughlyOneYearWorthOfSeconds: UInt32 = 60 * 60 * 24 * 365
        let randomNumberOfSecondsWithinOneYear = arc4random_uniform(roughlyOneYearWorthOfSeconds)
        return Date(timeIntervalSinceNow: TimeInterval(randomNumberOfSecondsWithinOneYear))
    }
}

extension Rsvp{
    static var random: Rsvp {
        let uuidString = UUID().uuidString
        let url = URL(string: "https://\(uuidString).jpeg")!
        return Rsvp(memberThumbnailURL: url)
    }
}

// MARK: - DebugMeetupProvider

class DebugMeetupProvider: MeetupProvider {
    func fetchMeetupSchedule(
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<MeetupSchedule>) -> Void)
    {
        let productionMeetupProvider = ProductionMeetupProvider()
        productionMeetupProvider.fetchMeetupSchedule(resultQueue: resultQueue) { result in
            switch result {
            case .failure(let error):
                resultHandler( .failure(error) )
                
            case .success(let meetupSchedule):
                let eventsWithRsvpsWithUniquePhotoURLs = meetupSchedule.eventsWithRsvps.map { eventWithRsvps -> MeetupSchedule.EventWithRsvps in
                    let rsvpsWithUniqueURLs = eventWithRsvps.rsvps.map { rsvp -> Rsvp in
                        guard let memberThumbnailURL = rsvp.memberThumbnailURL else { return rsvp }
                        let uniqueURLString = memberThumbnailURL.absoluteString.appending("ca.jeffreyfulton.\(eventWithRsvps.event.id)")
                        let uniqueURL = URL(string: uniqueURLString)!
                        
                        return Rsvp(memberThumbnailURL: uniqueURL)
                    }
                    
                    return MeetupSchedule.EventWithRsvps(
                        event: eventWithRsvps.event,
                        rsvps: rsvpsWithUniqueURLs
                    )
                }
                
                let meetupScheduleWithUniqueURLs = MeetupSchedule(
                    group: meetupSchedule.group,
                    eventsWithRsvps: eventsWithRsvpsWithUniquePhotoURLs
                )
                
                resultHandler( .success(meetupScheduleWithUniqueURLs) )
            }
        }
    }
}


// MARK: - ProductionMeetupProviderError

enum ProductionMeetupProviderError: Error {
    case failedWithErrors(errors: [Error])
    case failedToFetchGroup
}

// MARK: - ProductionMeetupProvider

class ProductionMeetupProvider: MeetupProvider {
    
    // MARK: - Stored Properties
    
    let groupURL = URL(string: "https://api.meetup.com/learn-swift-winnipeg")!
    let eventsURL = URL(string: "https://api.meetup.com/learn-swift-winnipeg/events?desc=true&status=past%2Cupcoming")!
    
    // MARK: - Fetching
    
    func fetchMeetupSchedule(
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<MeetupSchedule>) -> Void)
    {
        // Group and Events can start at the same time.
        // Rsvps can't start until Events returns.
        // Final completion handler can't start until Group, Events, and all Rsvps have returned.
        
        // Declare result references.
        var group: Group?
        var eventsWithRsvps: [MeetupSchedule.EventWithRsvps] = []
        var errors: [Error] = []
        
        // Only modify result references from the serialQueue to avoid weird threading bugs.
        let serialQueue = DispatchQueue(label: "ProductionMeetupProvider.serialQueue")
        
        // Create a DispatchGroup to manage dependencies by controlling WHEN different portions of code execute.
        let networkRequestDispatchGroup = DispatchGroup()
        
        // Fetch Group
        
        // Enter the DispatchGroup which ensures it's completion closure won't execute until we leave it. Each `enter()` call will be paired with a future `leave()` call.
        networkRequestDispatchGroup.enter()
        
        // Fetch requests will dispatch to (execute on) a background queue so we don't block the calling queue which is probably main.
        DispatchQueue.global().async {
            // Do the work of fetching and storing results.
            do {
                let groupData = try Data(contentsOf: self.groupURL)
                let decodedGroup = try JSONDecoder().decode(Group.self, from: groupData)
                
                // Only modify result references from the serialQueue to avoid weird threading bugs.
                serialQueue.async { group = decodedGroup }
            } catch {
                // Only modify result references from the serialQueue to avoid weird threading bugs.
                serialQueue.async { errors.append(error) }
            }
            
            // Exit the DispatchGroup
            networkRequestDispatchGroup.leave()
        }
        
        
        // Fetch Events
        
        // See above comment for explaination.
        networkRequestDispatchGroup.enter()
        
        // See above comment for explaination.
        DispatchQueue.global().async {
            // Do the work of fetching and storing results.
            do {
                let eventsData = try Data(contentsOf: self.eventsURL)
                let events = try JSONDecoder().decode([Event].self, from: eventsData)
                
                // Fetch Rsvps
                
                for event in events {
                    let rsvpsURL = URL(string: "https://api.meetup.com/learn-swift-winnipeg/events/\(event.id)/rsvps")!
                    
                    // See above comment for explanation.
                    networkRequestDispatchGroup.enter()
                    
                    // See above comment for explaination.
                    DispatchQueue.global().async {
                        do {
                            let rsvpsData = try Data(contentsOf: rsvpsURL)
                            let rsvps = try JSONDecoder().decode([Rsvp].self, from: rsvpsData)
                            let decodedEventsWithRsvp = MeetupSchedule.EventWithRsvps(event: event, rsvps: rsvps)
                            
                            // Only modify result references from the serialQueue to avoid weird threading bugs.
                            serialQueue.async { eventsWithRsvps.append(decodedEventsWithRsvp) }
                            
                        } catch {
                            // Only modify result references from the serialQueue to avoid weird threading bugs.
                            serialQueue.async { errors.append(error) }
                        }
                        
                        // Exit the DispatchGroup
                        networkRequestDispatchGroup.leave()
                    }
                }
            } catch {
                // Only modify result references from the serialQueue to avoid weird threading bugs.
                serialQueue.async { errors.append(error) }
            }
            
            // Exit the DispatchGroup
            networkRequestDispatchGroup.leave()
        }
        
        // Define completion handler
        networkRequestDispatchGroup.notify(queue: resultQueue) {
            guard errors.isEmpty else {
                let error = ProductionMeetupProviderError.failedWithErrors(errors: errors)
                resultHandler( .failure(error) )
                return
            }
            
            guard let group = group else {
                let error = ProductionMeetupProviderError.failedToFetchGroup
                resultHandler( .failure(error) )
                return
            }
            
            let meetupSchedule = MeetupSchedule(
                group: group,
                eventsWithRsvps: eventsWithRsvps
            )
            resultHandler( .success(meetupSchedule) )
        }
    }
}
