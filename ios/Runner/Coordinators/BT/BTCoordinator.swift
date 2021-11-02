import Foundation
import CoreBluetooth
import Flutter

class BTCoordinator: NSObject {
    
    private var channel: BTChannel?
    private var events: FlutterEventSink?
    private lazy var cbManager: CBCentralManager = {
        let manager = CBCentralManager()
        manager.delegate = self
        return manager
    }()
    
    func setup(_ channel: BTChannel, in vc: FlutterViewController) {
        self.channel = channel
        setupCommands(in: vc)
        setupEventStream(in: vc)
    }
}

// MARK: - Commands

extension BTCoordinator {
        
    private func setupCommands(in vc: FlutterViewController) {
        guard let channel = channel else { return }
        let commandChannel = FlutterMethodChannel(name: channel.commandRouteID,
                                                  binaryMessenger: vc.binaryMessenger)
        commandChannel.setMethodCallHandler({ [weak self] (call, result) in
            guard let command = BTChannel.Commands(rawValue: call.method) else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.handleCommand(command, updating: result)
        })
    }
    
    private func handleCommand(_ command: BTChannel.Commands, updating result: FlutterResult) {
        switch command {
        case .availability: getBTAvailability(result)
        case .name: result("TestName")
        }
    }
    
    private func getBTAvailability(_ result: FlutterResult) {
                
        let event: BTChannel.Availability = {
            switch cbManager.state {
            case .unauthorized: return .unauthorised
            case .unsupported: return .unavailable
            case .poweredOn, .poweredOff, .resetting: return .available
            default: return .unknown
            }
        }()
        result(event.rawValue)
    }
}

// MARK: - Events

extension BTCoordinator: FlutterStreamHandler {
    
    private func setupEventStream(in vc: FlutterViewController) {
        guard let channel = channel else { return }
        let eventStream = FlutterEventChannel(name: channel.eventRouteID,
                                              binaryMessenger: vc.binaryMessenger)
        eventStream.setStreamHandler(self)
    }

    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        events = eventSink
        sendBTAvailability()
        return nil
    }
    
    private func sendBTAvailability() {
        guard let events = events else { return }
        let state: BTChannel.State = {
            switch cbManager.state {
            case .poweredOn: return .on
            case .poweredOff: return .off
            case .resetting: return .resetting
            case .unauthorized: return .unauthorised
            default: return .unknown
            }
        }()
        events(state.rawValue)
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        events = nil
        return nil
    }
}

// MARK: - CBCentralManager

extension BTCoordinator: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        sendBTAvailability()
    }
}
