import Foundation

// MARK: - Event

struct Event {
    let id: String
    let startTime: Date
    let name: String
}

// MARK: - Decodable

extension Event: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "time"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        
        let timeInMilliSeconds = try values.decode(TimeInterval.self, forKey: CodingKeys.startTime)
        self.startTime = Date(timeIntervalSince1970: timeInMilliSeconds / 1000)
        
        self.name = try values.decode(String.self, forKey: CodingKeys.name)
    }
}
