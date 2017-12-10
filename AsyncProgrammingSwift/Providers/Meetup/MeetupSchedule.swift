struct MeetupSchedule {
    let group: Group
    
    struct EventWithRsvps {
        let event: Event
        let rsvps: [Rsvp]
    }
    let eventsWithRsvps: [EventWithRsvps]
}
