//
//  StartsView.swift
//  FL_test
//
//  Created by lihongli on 2022/10/22.
//
//对行走过程进行数据记录

import SwiftUI

struct StartsView: View {
    @EnvironmentObject var client: WebSocketClient
    @EnvironmentObject var user: User
    @Environment(\.managedObjectContext) var moc
    
    @State private var message = ""
    @State private var showingAlert = false
    @State var radis = 0.0
    @State private var start_time = Date()
    @State private var end_time = Date()
    let dateFormatter = DateFormatter()
    
//    init() {
//        client = WebSocketClient()
//        client.setup(url: "ws://192.168.137.202/ws")
//    }
    
    var body: some View {
        VStack {
            HStack{
                FootRightView(rad: radis, pressure_arr: client.pressure_arr_left)
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1.0, z: 0))
                    .scaleEffect(0.8)
                FootRightView(rad: radis, pressure_arr: client.pressure_arr_right)
                    .scaleEffect(0.8)
            }
//            Slider(value: $radis, in: 0...40, step: 0.5)
//            Text("radis: \(radis)")
            
            if client.isConnected {
//                Text(client.message_now)
                Text("设备监控中")
            } else {
                ProgressView()
            }
            Spacer()
            HStack {
                Spacer()
                //开启WebSocket链接，进行通信
                Button(action: {
                    client.setup(url: "ws://" + client.url_str + "/ws")
                    client.connect()
                    start_time = Date()
                }, label: {
                    Label("连接设备", systemImage: "link")
                })
                .padding()
                .disabled(client.isConnected)
                .background(Color.white.opacity(0.3))
                .cornerRadius(10)
                
                //断开WebSocket链接，并存储本次通信数据
                Spacer()
                Button(action: {
                    showingAlert = true
                }, label: {
                    Label("断开连接", systemImage: "xmark.octagon")
                })
                .disabled(!client.isConnected)
                .padding()
                .background(Color.white.opacity(0.3))
                .cornerRadius(10)
                .alert("确认断开链接？", isPresented: $showingAlert) {
                    Button("取消", role: .cancel) { }
                    
                    Button("断开", role: .destructive){
                        end_time = Date()
                        client.disconnect()
                        let newItem = HealthDataItem(context: moc)
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        newItem.start_time = dateFormatter.string(from: start_time)
                        newItem.end_time = dateFormatter.string(from: end_time)
                        newItem.data_frame = client.messages.joined(separator: " \n")
                        newItem.id = UUID()
                        newItem.user_name = user.username
                        newItem.test_type = user.test_type
                        newItem.weight = Int16(user.weight)
                        newItem.pressure_left = client.pressure_sum_left
                        newItem.pressure_right = client.pressure_sum_right
                        
                        try? moc.save()
                        client.messages.removeAll()
                        client.pressure_sum_right.removeAll()
                        client.pressure_sum_left.removeAll()
                    }
                } message: {
                    Text("运动记录将停止")
                }
                Spacer()
            }
            Spacer()
//            HStack {
//                ChartRingView(progressValues: 0.5, center_text: "Data1")
//                    .scaleEffect(0.7)
//                ChartRingView(progressValues: 0.5, center_text: "Data1")
//                    .scaleEffect(0.7)
//                ChartRingView(progressValues: 0.5, center_text: "Data1")
//                    .scaleEffect(0.7)
//            }
            
            HStack(alignment: .center, spacing: 16, content: {
                TextField("向设备发送指令", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if !message.isEmpty {
                        client.send(message)
                        message = ""
                    }}, label: {
                        Label("", systemImage: "paperplane")
                    })
                .disabled(!client.isConnected)
            })
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
//            Text("Current address: \(client.url_str)")
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
//        .onAppear() {
//            client.setup(url: "ws://" + client.url_str + "/ws")
//            client.connect()
//        }
//        .onDisappear() {
//            client.disconnect()
//        }
    }
}

struct StartsView_Previews: PreviewProvider {
//    static let client = WebSocketClient()
//    static let user = User()
    static var previews: some View {
        StartsView()
            .environmentObject(WebSocketClient())
            .environmentObject(User())
    }
}


struct CardView: View{
    var content: String
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            shape.fill().foregroundColor(.blue)
            Text(content)
//                .font(.largeTitle)
        }
    }
}


