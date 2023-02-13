import Foundation

extension Date {
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isTommorow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
}
