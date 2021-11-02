import Foundation
import Flutter

final class CommandCoordinator: NSObject {
    private var btCoordinator = BTCoordinator()
}

extension CommandCoordinator {
    
    func setupFlutterCommunication(channel: Channel, in vc: FlutterViewController) {
        switch channel.domain {
        case .BT: btCoordinator.setup(channel as! BTChannel, in: vc)
        }
    }
}
