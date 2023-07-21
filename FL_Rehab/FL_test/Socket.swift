//
//  Socket.swift
//  FL_test
//
//  Created by lihongli on 2022/10/20.
//

//完成WebSocket通信

import Foundation

class WebSocketClient: NSObject, ObservableObject {

    private var webSocketTask: URLSessionWebSocketTask?

    @Published var url_str: String = "192.168.4.1"
//    @Published var user_name: String = "someone"
    @Published var messages: [String] = []
    @Published var isConnected: Bool = false
    @Published var message_now: String = "000000000000000000000000"
    @Published var pressure_arr_right = [Double](repeating: 0, count: 24)
    @Published var pressure_arr_left = [Double](repeating: 0, count: 24)
    @Published var pressure_sum_right: [Double] = []
    @Published var pressure_sum_left: [Double] = []

    func setup(url: String) {
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with: URL(string: url)!)
    }

    func connect() {
        webSocketTask?.resume()
        receive()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    func send(_ message: String) {
        let msg = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(msg) { error in
            if let error = error {
                print(error)
            }
        }
    }

    //从单片机接收数据
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                    DispatchQueue.main.async {
                        self?.messages.append(text)
                        self?.message_now = text
                        let arr_right = Array(text.prefix(24))
                        let arr_left = Array(text.suffix(24))
                        for index in 0..<24 {
                            self?.pressure_arr_left[index] = (Double(arr_left[index].asciiValue!)-48)/20.0
                            self?.pressure_arr_right[index] = (Double(arr_right[index].asciiValue!)-48)/20.0
                        }
                        self?.pressure_sum_left.append(self?.pressure_arr_left.reduce(0, +) ?? 0.0)
                        self?.pressure_sum_right.append(self?.pressure_arr_right.reduce(0, +) ?? 0.0)
                    }
                case .data(let data):
                    print("Received binary message: \(data)")
                @unknown default:
                    fatalError()
                }
                self?.receive()
            case .failure(let error):
                print("Failed to receive message: \(error)")
            }
        }
    }
}

extension WebSocketClient: URLSessionWebSocketDelegate {

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("didOpenWithProtocol")
        DispatchQueue.main.async {
            self.isConnected = true
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("didCloseWith: closeCode: \(closeCode) reason: \(String(describing: reason))")
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("didCompleteWithError error: \(String(describing: error))")
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
}
