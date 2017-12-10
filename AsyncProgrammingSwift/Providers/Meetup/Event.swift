import Foundation

struct Event {
    let id: String
    
    enum Status {
        case upcoming, past
    }
    let status: Status
    
    let startTime: Date
    let name: String
    let eventDescription: String
}

