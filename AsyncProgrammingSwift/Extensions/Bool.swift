import Foundation

public extension Bool {
    public static var random: Bool {
        return arc4random_uniform(2) > 0
    }
}
