//
//  ContentView.swift
//  FL_test
//
//  Created by lihongli on 2022/10/20.
//

import SwiftUI

struct ContentView: View{
    private enum Tab: Hashable {
        case home
        case start
        case user
        case setting
    }
    
    @EnvironmentObject var user: User
    @EnvironmentObject var client: WebSocketClient
    @State private var SelectedTab: Tab = .home
    
    var body: some View{
        TabView(selection: $SelectedTab) {
            HomesView()
                .tag(Tab.home)
                .tabItem {
                    Text("主页")
                    Image(systemName: "house.fill")
                }
            StartsView()
                .tag(Tab.start)
                .tabItem {
                    Text("行走")
                    Image(systemName: "person")
                }
            DataStorage()
                .tag(Tab.user)
                .tabItem {
                    Text("数据")
//                    Image(systemName: "list.clipboard")
                    Image(systemName: "folder")
                }
            SettingsView()
                .tag(Tab.setting)
                .tabItem {
                    Text("设置")
                    Image(systemName: "gear")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.gray.opacity(0.2))
            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up:
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
    }
}


struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
            .environmentObject(User())
            .environmentObject(WebSocketClient())
//            .environmentObject()
    }
}
