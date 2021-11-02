import Foundation

struct BTChannel: Channel {
        
    var domain: Domain { .BT }
    var commandRouteID: String { "samples.flutter.io/btAvailability" }
    var eventRouteID: String { "samples.flutter.io/btState" }

    enum Commands: String {
        case availability = "getBTAvailability"
        case name = "getBTName"
    }
    
    enum Availability: String {
        case unavailable = "Unavailable"
        case unauthorised = "Unauthorised"
        case available = "Available"
        case unknown = "Unknown"
    }
    
    enum State: String {
        case on = "On"
        case off = "Off"
        case resetting = "Resetting"
        case unauthorised = "Unothorised"
        case unknown = "Unknown"
    }
}
