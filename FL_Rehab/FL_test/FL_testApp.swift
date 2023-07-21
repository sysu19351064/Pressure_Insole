//
//  FL_testApp.swift
//  FL_test
//
//  Created by lihongli on 2022/10/20.
//

import SwiftUI
import Starscream
@main
struct FL_testApp: App {
    @StateObject var user = User()
    @StateObject var client = WebSocketClient()
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(client)
                .environment(\.managedObjectContext, dataController.container.viewContext)

        }
    }
}
