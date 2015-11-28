//
//  TCPNetworkManager.swift
//  CPSC134
//
//  Created by Luiz Fernando 2 on 11/26/15.
//  Copyright © 2015 CiriglianoApps. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class TCPNetworkManager: NetworkManagerProtocol, GCDAsyncSocketDelegate {
    static let sharedManager = TCPNetworkManager()
    
    let socket:GCDAsyncSocket = GCDAsyncSocket()
    var connectionDelegate:NetworkConnectionDelegate?
    
    enum NetworkManagerError: ErrorType {
        case ErrorConnecting
        case NotConnected
    }
    
    init() {
        self.socket.setDelegate(self, delegateQueue: dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
    }
    
    func connectToServer(serverIP: String, serverPort: UInt16, delegate: NetworkConnectionDelegate?) throws {
        self.connectionDelegate = delegate
        do {
            try self.socket.connectToHost(serverIP, onPort: serverPort, withTimeout: 3)
        } catch {
            self.connectionDelegate?.didNotConnect()
            throw NetworkManagerError.ErrorConnecting
        }
    }
    
    func sendString(stringToSend: String) throws {
        guard self.socket.isConnected else {
            throw NetworkManagerError.NotConnected
        }
        
        let data = stringToSend.dataUsingEncoding(NSUTF8StringEncoding)
        
        self.socket.writeData(data, withTimeout: 3, tag: 0)
    }
    
    func sendNote(note: Int) {
        do {
            try sendString("\(note)")
        } catch {
            print("\(error)")
            print("Erro enviando nota")
        }
    }
    
    @objc func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        self.connectionDelegate?.didConnect()
    }
    
    @objc func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        print("\(err)")
    }
}
