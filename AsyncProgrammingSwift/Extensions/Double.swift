import Foundation

public extension Double {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
    
    /// Returns a random floating point number between lower and upper bounds.
    public static func random(lower: Double, upper: Double) -> Double {
        return Double.random * (upper - lower) + lower
    }
}
