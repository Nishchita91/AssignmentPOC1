//
//  Manager.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 26/03/26.
//

import Network

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    var isConnected: Bool = false
    var onStatusChange: ((Bool) -> Void)?
    
    private init() {
        monitor.pathUpdateHandler = { path in
            
            let status = path.status == .satisfied
            self.isConnected = status
            
            DispatchQueue.main.async {
                self.onStatusChange?(status)
            }
        }
        
        monitor.start(queue: queue)
    }
}
