import Foundation

enum Domain {
    case BT
}

protocol Channel {
    var domain: Domain { get }
    var commandRouteID: String { get }
    var eventRouteID: String { get }
}
