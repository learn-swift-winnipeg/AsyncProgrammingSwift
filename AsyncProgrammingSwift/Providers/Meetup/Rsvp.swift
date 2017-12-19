import Foundation

// MARK: - Rsvp

struct Rsvp {
    let memberThumbnailURL: URL?
}

// MARK: - Decodable

extension Rsvp: Decodable {
    enum CodingKeys: String, CodingKey {
        case member
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let member = try values.decode(Member.self, forKey: .member)
        self.memberThumbnailURL = member.photo.map({ URL(string: $0.thumbLink)! })
    }
}
