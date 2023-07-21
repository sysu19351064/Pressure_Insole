//
//  SettingsView.swift
//  FL_test
//
//  Created by lihongli on 2022/10/22.
//
//设置页面，对IP地址，健康数据进行设置

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var client: WebSocketClient
    @EnvironmentObject var user: User
    @State var url_str = ""
    @State var selection_number = 0
    let test_types: [String] = ["正常", "扁平足", "筋膜炎", "半月板损伤", "腱鞘炎","膝关节损伤" ]
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {
        NavigationView {
            Form{
                Section(header:Text("用户信息")){
                    NavigationLink {
                        NameView()
                    } label: {
                        HStack {
                            Text("姓名")
                            Spacer()
                            Text(user.username)
                        }
                    }
                    NavigationLink {
                        WeightView()
                    } label: {
                        HStack {
                            Text("体重")
                            Spacer()
                            Text("\(user.weight)千克")
                        }
                    }
                    NavigationLink {
                        TypeView()
                    } label: {
                        HStack {
                            Text("测试类型")
                            Spacer()
                            Text("\(user.test_type)")
                        }
                    }
//                    Picker(selection: $user.test_type, label: Text("测试类型")){
//                        ForEach(test_types, id:\.self) {test_type in
//                            Text(test_type)
//                        }
//                    }
                }
                Section(header:Text("输入设备IP地址")){
                    NavigationLink {
                        IPView()
                    } label: {
                        HStack {
                            Text("设备地址")
                            Spacer()
                            Text(client.url_str)
                        }
                    }
                }
                Section{
                    Text("联系方式: lhli25@mail2.sysu.edu.cn")
                }
            }
            .navigationBarTitle("设置")
        }
        
        .background{
            ZStack {
                VStack {
                    Circle()
                        .fill(Color.green)
                        .scaleEffect(0.6)
                        .offset(x:20)
                        .blur(radius: 120)
                    
                    Circle()
                        .fill(Color.purple)
                        .scaleEffect(0.6)
                        .offset(x:-20)
                        .blur(radius: 120)
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct NameView: View {
    @EnvironmentObject var user: User
    var body: some View {
        Text("姓名")
            .font(.headline)
        TextField("", text: $user.username)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5.0)
        Spacer()
    }
}

struct WeightView: View {
    @EnvironmentObject var user: User
    let weights = [Int](0..<95)
    var body: some View {
        Text("体重")
            .font(.headline)
        Picker(" ", selection: $user.weight) {
            ForEach(weights, id:\.self) {index in
                Text("\(self.weights[index])").tag(index)
            }
        }
        .pickerStyle(.wheel)
        Spacer()
    }
}

struct TypeView: View {
    @EnvironmentObject var user: User
    let test_types: [String] = ["正常", "扁平足", "筋膜炎", "半月板损伤", "腱鞘炎","膝关节损伤" ]
    var body: some View {
        Text("测试类型")
            .font(.headline)
        Picker("", selection: $user.test_type) {
            ForEach(test_types, id:\.self) {test_type in
                Text(test_type)
            }
        }
        .pickerStyle(.wheel)
        Spacer()
    }
}

struct IPView: View {
    @EnvironmentObject var client: WebSocketClient
    var body: some View {
        Text("设备IP地址")
            .font(.headline)
        TextField("", text: $client.url_str)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5.0)
        Spacer()
    }
}

struct SettingsView_Previews: PreviewProvider {
//    static let client = WebSocketClient()
    static var previews: some View {
        SettingsView()
            .environmentObject(WebSocketClient())
            .environmentObject(User())
    }
}
