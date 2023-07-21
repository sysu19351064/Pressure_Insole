//
//  UsersView.swift
//  FL_test
//
//  Created by lihongli on 2022/10/22.
//

import SwiftUI

struct User_data: Codable, Identifiable {
    var id = UUID()
    var timestamp: String = "2022"
    var data: [String] = []
}

//class User: ObservableObject{
//    var username: String = "LHL"
//    @Published var user_dataset: [User_data] = []
//    let KeyForUserDefaults = "DataKey"
//
//    init (user_dataset: [User_data] = []) {
//        self.user_dataset = user_dataset
//    }
//
//    func updateName(name: String){
//        self.username = name
//    }
//
//    func updataData(timestamp: String, data: [String]) {
//        let user_data_temp = User_data(timestamp: timestamp, data: data)
//        user_dataset.append(user_data_temp)
//    }
//
//    func save() {
//        let data = user_dataset.map { try? JSONEncoder().encode($0) }
//        UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
//    }
//
//    func load() -> [User_data] {
//        guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data]
//        else {
//            return []
//            }
//        return encodedData.map { try! JSONDecoder().decode(User_data.self, from: $0) }
//    }
//}

class User: ObservableObject{
    @Published var username: String = "测试者"
//    @Published var user_dataset: [User_data] = []
    @Published var weight: Int = 65
    @Published var test_type: String = "正常"
    
//    init (name: String) {
//        self.user_dataset = user_dataset
//    }

    func updateName(name: String){
        self.username = name
    }
}


//struct UsersView: View{
//    @EnvironmentObject var user: User
//
////    init(){
////        user.save()
////    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Button("Load", action: {
//                    user.user_dataset.append(contentsOf: user.load())
//                })
//
//                List {
//                    ForEach (user.user_dataset) { item in
//                        NavigationLink(destination: Realtime(userItem: item)) {
//                            HStack {
//                                Text(item.timestamp)
//                                    .font(.headline)
//                            }
//                            .padding()
//                        }
//                    }
//                    .onDelete(perform: deleteItem)
////                    .onMove(perform: moveItem)
//                }
////                .navigationBarTitle("Fetch TXT File")
//            }
//        }
//        .onAppear{
//            user.updataData(timestamp: "2022", data: ["AAA", "BBB", "CCC"])
//            user.save()
//        }
//    }
//
//    func deleteItem(at offsets: IndexSet) {
//        user.user_dataset.remove(atOffsets: offsets)
//    }
//
//    func moveItem(from source: IndexSet, to destination: Int) {
//        user.user_dataset.move(fromOffsets: source, toOffset: destination)
//    }
//}
//
//
////struct DeltailView: View {
////    @EnvironmentObject var user: User
////    let userItem: User_data
////
////    var body: some View {
////        VStack(alignment: .leading) {
////            VStack {
////                Text("Username: \(user.username)")
////                    .font(.title2)
////                    .multilineTextAlignment(.leading)
////
////                Text("Data: \(userItem.data)")
////                    .font(.title2)
////                    .multilineTextAlignment(.leading)
////            }
////            Spacer()
////        }
////        .padding()
////        .navigationBarTitle(Text(user.username), displayMode: .automatic)
////    }
////}
//
//
//struct UsersView_Previews: PreviewProvider {
////    static let user = User()
//    static var previews: some View {
//        UsersView()
//            .environmentObject(User())
//    }
//}
