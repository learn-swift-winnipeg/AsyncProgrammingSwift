import Foundation

protocol MeetupProvider {
    func fetchMeetupSchedule(
        forGroupUrlname: String,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<MeetupSchedule>) -> Void
    )
}

class TestingMeetupProvider: MeetupProvider {
    
    // MARK: - Stored Properties
    
    private let minFetchDelay: TimeInterval = 0.0
    private let maxFetchDelay: TimeInterval = 2.0
    
    // MARK: - Fetching
    
    func fetchMeetupSchedule(
        forGroupUrlname: String,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<MeetupSchedule>) -> Void)
    {
        let group = Group(
            id: "test",
            keyPhotoUrl: URL(string: "https://secure.meetupstatic.com/photos/event/b/d/e/7/600_464328615.jpeg")!,
            name: "Testing Meetup Group",
            localizedLocation: "Notre Dame de Lourdes, MB",
            memberCount: 2
        )
        
        let upcomingEvent = Event(
            id: "245590889",
            status: .upcoming,
            startTime: Date(timeIntervalSince1970: 1513814400000 / 1000),
            name: "Asynchronous Programming in Swift along with other interesting things!",
            eventDescription: "Perhaps we should ditch this field... it will require too much effort to strip the html out."
        )
        
        let firstPastEvent = Event(
            id: "237981458",
            status: .past,
            startTime: Date(timeIntervalSince1970: 1489017600000 / 1000),
            name: "Application Architecture: Presenters & View Models (MVP & MVVM)",
            eventDescription: "Perhaps we should ditch this field... it will require too much effort to strip the html out."
        )
        
        let secondPastEvent = Event(
            id: "237981459",
            status: .past,
            startTime: Date(timeIntervalSince1970: 1489017600000 / 1000),
            name: "Application Architecture: Presenters & View Models (MVP & MVVM)",
            eventDescription: "Perhaps we should ditch this field... it will require too much effort to strip the html out."
        )
        
        let thirdPastEvent = Event(
            id: "237981460",
            status: .past,
            startTime: Date(timeIntervalSince1970: 1489017600000 / 1000),
            name: "Application Architecture: Presenters & View Models (MVP & MVVM)",
            eventDescription: "Perhaps we should ditch this field... it will require too much effort to strip the html out."
        )
        
        let fourthPastEvent = Event(
            id: "237981461",
            status: .past,
            startTime: Date(timeIntervalSince1970: 1489017600000 / 1000),
            name: "Application Architecture: Presenters & View Models (MVP & MVVM)",
            eventDescription: "Perhaps we should ditch this field... it will require too much effort to strip the html out."
        )
        
        let fifthPastEvent = Event(
            id: "237981462",
            status: .past,
            startTime: Date(timeIntervalSince1970: 1489017600000 / 1000),
            name: "Application Architecture: Presenters & View Models (MVP & MVVM)",
            eventDescription: "Perhaps we should ditch this field... it will require too much effort to strip the html out."
        )
        
        let firstRsvp = Rsvp(id: "1", memberThumbnailUrl: URL(string: "https://secure.meetupstatic.com/photos/member/4/3/b/4/thumb_222557332.jpeg")!)
        
        let secondRsvp = Rsvp(id: "2", memberThumbnailUrl: URL(string: "https://secure.meetupstatic.com/photos/member/4/e/0/c/thumb_256519980.jpeg")!)
        
        let thirdRsvp = Rsvp(id: "3", memberThumbnailUrl: URL(string: "https://secure.meetupstatic.com/photos/member/b/b/4/9/thumb_260747945.jpeg")!)
        
        let fourthRsvp = Rsvp(id: "4", memberThumbnailUrl: URL(string: "https://secure.meetupstatic.com/photos/member/9/3/9/6/thumb_93157782.jpeg")!)
        
        let fifthRsvp = Rsvp(id: "5", memberThumbnailUrl: URL(string: "https://secure.meetupstatic.com/photos/member/9/e/4/0/thumb_266440512.jpeg")!)
        
        let sixthRsvp = Rsvp(id: "6", memberThumbnailUrl: URL(string: "https://secure.meetupstatic.com/photos/member/8/6/0/f/thumb_255214319.jpeg")!)
        
        let meetupSchedule = MeetupSchedule(
            group: group,
            eventsWithRsvps: [
                MeetupSchedule.EventWithRsvps(event: upcomingEvent, rsvps: [firstRsvp, firstRsvp, firstRsvp]),
                MeetupSchedule.EventWithRsvps(event: firstPastEvent, rsvps: [secondRsvp, secondRsvp, secondRsvp]),
                MeetupSchedule.EventWithRsvps(event: secondPastEvent, rsvps: [thirdRsvp, thirdRsvp, thirdRsvp]),
                MeetupSchedule.EventWithRsvps(event: thirdPastEvent, rsvps: [fourthRsvp, fourthRsvp, fourthRsvp]),
                MeetupSchedule.EventWithRsvps(event: fourthPastEvent, rsvps: [fifthRsvp, fifthRsvp, fifthRsvp]),
                MeetupSchedule.EventWithRsvps(event: fifthPastEvent, rsvps: [sixthRsvp, sixthRsvp, sixthRsvp]),
            ])
        
        resultQueue.asyncAfter(seconds: .random(lower: minFetchDelay, upper: maxFetchDelay)) {
            resultHandler( .success(meetupSchedule) )
        }
    }
}

class ProductionMeetupProvider: MeetupProvider {
    
    // MARK: - Fetching
    
    func fetchMeetupSchedule(
        forGroupUrlname: String,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<MeetupSchedule>) -> Void)
    {
        // TODO: Implement.
    }
}
