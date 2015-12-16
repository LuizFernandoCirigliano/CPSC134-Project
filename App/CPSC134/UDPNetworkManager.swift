//
//  TCPNetworkManager.swift
//  CPSC134
//
//  Created by Luiz Fernando 2 on 11/26/15.
//  Copyright © 2015 CiriglianoApps. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class UDPNetworkManager: NetworkManagerProtocol, GCDAsyncUdpSocketDelegate {
    static let sharedManager = UDPNetworkManager()
    
    let socket:GCDAsyncUdpSocket = GCDAsyncUdpSocket()
    var connectionDelegate:NetworkConnectionDelegate?
    
    var serverIP = "localhost"
    var serverPort:UInt16 = 9999
    
    enum NetworkManagerError: ErrorType {
        case ErrorConnecting
        case NotConnected
    }
    
    init() {
        self.socket.setDelegate(self, delegateQueue: dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
    }
    
    func connectToServer(serverIP: String, serverPort: UInt16, delegate: NetworkConnectionDelegate?) throws {
        self.connectionDelegate = delegate

        self.serverPort = serverPort
        self.serverIP = serverIP
        
        self.connectionDelegate?.didConnect()
    }
    
    func sendString(stringToSend: String) throws {
        let data = stringToSend.dataUsingEncoding(NSUTF8StringEncoding)
        
        self.socket.sendData(data, toHost: self.serverIP, port: self.serverPort, withTimeout: 3, tag: 0)
    }
    
    func sendInstrument(instrument: Int, channel: Int) {
        do {
            try sendString("i/\(instrument)/\(channel)")
        } catch {
            print("\(error)")
            print("Erro enviando instrumento")
        }
    }
    
    func sendNoteOn(note: Int, channel: Int) {
        do {
            try sendString("b/\(note)/\(channel)")
        } catch {
            print("\(error)")
            print("Erro enviando nota")
        }
    }
    
    func sendNoteOff(note: Int, channel: Int) {
        do {
            try sendString("e/\(note)/\(channel)")
        } catch {
            print("\(error)")
            print("Erro enviando nota")
        }
    }
    
    func sendNote(note: Int, duration: Int, channel: Int) {
        do {
            try sendString("n/\(note)/\(duration)/\(channel)")
        } catch {
            print("\(error)")
            print("Erro enviando nota")
        }
    }
    func sendNote(note: Int, duration: Int) {
        self.sendNote(note, duration: duration, channel: 0)
    }
    func sendNote(note: Int, channel: Int) {
        self.sendNote(note, duration: 500, channel: channel)
    }
    func sendNote(note: Int) {
        self.sendNote(note, duration: 500)
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        self.connectionDelegate?.didConnect()
    }
    
    @objc func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        self.connectionDelegate?.didNotConnect()
    }
}
