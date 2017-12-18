import Foundation

// MARK: - MeetupProvider

protocol MeetupProvider {
    func fetchMeetupSchedule(
        forGroupURLname: String,
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
        forGroupURLname: String,
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
            name: "Random name: \(uuidString)",
            eventDescription: "Random description: \(uuidString)")
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
        return Rsvp(
            id: uuidString,
            memberThumbnailURL: URL(string: "https://\(uuidString).jpeg")!
        )
    }
}

class ProductionMeetupProvider: MeetupProvider {
    
    // MARK: - Fetching
    
    func fetchMeetupSchedule(
        forGroupURLname: String,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<MeetupSchedule>) -> Void)
    {
        // TODO: Implement.
    }
}
