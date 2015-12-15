//
//  NetworkManager.swift
//  CPSC134
//
//  Created by Luiz Fernando 2 on 11/25/15.
//  Copyright © 2015 CiriglianoApps. All rights reserved.
//

import UIKit

protocol NetworkConnectionDelegate {
    func didConnect()
    func didNotConnect()
}

protocol NetworkManagerProtocol {
    func connectToServer(serverIP: String, serverPort: UInt16, delegate: NetworkConnectionDelegate?) throws
    func sendString(stringToSend: String) throws
    func sendNote(note: Int)
    
}

class NetworkManager {
    static let sharedManager = UDPNetworkManager.sharedManager
    
    static func setLastIP(newIP: String) {
        NSUserDefaults.standardUserDefaults().setObject(newIP, forKey: "LastIP")
    }
    
    static func getLastIP() -> String {
        let lastIP = NSUserDefaults.standardUserDefaults().objectForKey("LastIP") ?? "localhost"
        return lastIP as! String
    }
    
    static func setLastPort(newPort: String) {
        NSUserDefaults.standardUserDefaults().setObject(newPort, forKey: "LastPort")
    }
    
    static func getLastPort() -> String {
        let lastPort = NSUserDefaults.standardUserDefaults().objectForKey("LastPort") ?? "9999"
        return lastPort as! String
    }
}
