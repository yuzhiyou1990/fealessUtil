import Foundation
import Starscream

extension WebSocketEngine: WebSocketDelegate {
//    public func didReceive(event: WebSocketEvent, client: WebSocket) {
//        mutex.lock()
//        switch event {
//        case .binary(let data):
//            handleBinaryEvent(data: data)
//            break
//        case .cancelled:
//            handleCancelled()
//            break
//        case .connected(_):
//            handleConnectedEvent()
//            break
//        case .disconnected(_, _):
//            handleDisconnectedEvent(error: nil)
//            break
//        case .error(let error):
//            handleErrorEvent(error)
//            break
//        case .text(let text):
//            handleTextEvent(string: text)
//            break
//        case .pong(_):
//            break
//        case .ping(_):
//            break
//        case .viabilityChanged(_):
//            break
//        case .reconnectSuggested(_):
//            break
//        }
//        mutex.unlock()
//    }
    public   func websocketDidConnect(socket: WebSocketClient) {
        mutex.lock()
        handleConnectedEvent()
        mutex.unlock()
    }

    public  func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        mutex.lock()
        handleDisconnectedEvent(error: error)
        mutex.unlock()
    }

    public  func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        mutex.lock()
        handleTextEvent(string: text)
        mutex.unlock()
    }

    public  func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        mutex.lock()
        handleBinaryEvent(data: data)
        mutex.unlock()
    }
    
    private func handleCancelled() {
        logger.warning("Remote cancelled")

        switch state {
        case let .connecting(attempt):
            connection.disconnect()
            scheduleReconnectionOrDisconnect(attempt + 1)
        case .connected:
            let cancelledRequests = resetInProgress()

            pingScheduler.cancel()

            connection.disconnect()
            scheduleReconnectionOrDisconnect(1)

            notify(
                requests: cancelledRequests,
                error: JSONRPCEngineError.clientCancelled
            )
        default:
            break
        }
    }

    private func handleErrorEvent(_ error: Error?) {
        if let error = error {
            logger.error("Did receive error: \(error)")
        } else {
            logger.error("Did receive unknown error")
        }

        switch state {
        case .connected:
            let cancelledRequests = resetInProgress()

            pingScheduler.cancel()

            connection.disconnect()
            startConnecting(0)

            notify(
                requests: cancelledRequests,
                error: JSONRPCEngineError.clientCancelled
            )
        case let .connecting(attempt):
            connection.disconnect()

            scheduleReconnectionOrDisconnect(attempt + 1)
        default:
            break
        }
    }

    private func handleBinaryEvent(data: Data) {
        if let decodedString = String(data: data, encoding: .utf8) {
            logger.debug("Did receive data: \(decodedString.prefix(1024))")
        }

        process(data: data)
    }

    private func handleTextEvent(string: String) {
        logger.debug("Did receive text: \(string.prefix(1024))")
        if let data = string.data(using: .utf8) {
            process(data: data)
        } else {
            logger.warning("Unsupported text event: \(string)")
        }
    }

    private func handleConnectedEvent() {
        logger.debug("connection established")

        changeState(.connected)
        sendAllPendingRequests()

        schedulePingIfNeeded()
    }

    private func handleDisconnectedEvent(error: Error?) {
        if let error = error {
            logger.error("Did receive error: \(error)")
        } else {
            logger.error("Did receive unknown error")
        }

        switch state {
        case let .connecting(attempt):
            scheduleReconnectionOrDisconnect(attempt + 1)
        case .connected:
            let cancelledRequests = resetInProgress()

            pingScheduler.cancel()

            scheduleReconnectionOrDisconnect(1)

            notify(
                requests: cancelledRequests,
                error: JSONRPCEngineError.remoteCancelled
            )
        default:
            break
        }
    }
}

extension WebSocketEngine: SchedulerDelegate {
    public func didTrigger(scheduler: SchedulerProtocol) {
        mutex.lock()

        if scheduler === pingScheduler {
            handlePing(scheduler: scheduler)
        } else {
            handleReconnection(scheduler: scheduler)
        }

        mutex.unlock()
    }

    private func handleReconnection(scheduler _: SchedulerProtocol) {
        logger.debug("Did trigger reconnection scheduler")

        if case let .waitingReconnection(attempt) = state {
            startConnecting(attempt)
        }
    }

    private func handlePing(scheduler _: SchedulerProtocol) {
        schedulePingIfNeeded()

        connection.callbackQueue.async {
            self.sendPing()
        }
    }
}
