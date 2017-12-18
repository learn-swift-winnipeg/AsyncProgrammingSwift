import Foundation

extension Array {
    var random: Element? {
        guard self.count > 0 else { return nil }
        let index = Index.random(lower: 0, upper: self.count - 1)
        return self[index]
    }
}
