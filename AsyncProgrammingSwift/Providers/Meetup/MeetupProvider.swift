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
        
        let meetupSchedule = MeetupSchedule(
            group: group,
            eventsWithRsvps: [
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random, .random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random, .random, .random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random, .random, .random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random]
                ),
                MeetupSchedule.EventWithRsvps(
                    event: .random,
                    rsvps: [.random, .random, .random, .random, .random, .random, .random]
                ),
            ])
        
        resultQueue.asyncAfter(seconds: .random(lower: minFetchDelay, upper: maxFetchDelay)) {
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
