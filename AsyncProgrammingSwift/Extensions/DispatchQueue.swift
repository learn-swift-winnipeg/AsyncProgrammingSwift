import Foundation

extension DispatchQueue {
    func asyncAfter(seconds: TimeInterval, closure: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + seconds, execute: closure)
    }
}
