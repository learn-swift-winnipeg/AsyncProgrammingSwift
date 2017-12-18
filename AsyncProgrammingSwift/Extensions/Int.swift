import Foundation

public extension Int {
    /// Random integer between 0 and upper-1.
    private static func random(upper: UInt) -> Int {
        return Int(arc4random_uniform(UInt32(upper)))
    }
    
    /// Random integer between lower and upper bounds inclusive.
    public static func random(lower: Int, upper: Int) -> Int {
        return Int.random(upper: UInt(upper - lower + 1)) + lower
    }
    
    /// Random integer inside of the closed range inclusive.
    public static func random(in range: ClosedRange<Int>) -> Int {
        return Int.random(upper: (UInt(range.upperBound - range.lowerBound + 1))) + range.lowerBound
    }
}
