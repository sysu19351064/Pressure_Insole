//
//  AddItemView.swift
//  FL_test
//
//  Created by lihongli on 2022/11/3.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var start_time = Date()
    @State private var end_time = Date()
    @State private var data_frame = ["AAA", "BBB", "CCC"]
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Data frame", text: $data_frame[0])
                }
                
                Section {
                    Button("Save") {
                        // add the item
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let newItem = HealthDataItem(context: moc)
                        newItem.start_time = dateFormatter.string(from: Date())
                        newItem.end_time = dateFormatter.string(from: Date())
                        newItem.data_frame = data_frame.joined(separator: " \n")
                        newItem.id = UUID()
                        
                        try? moc.save()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add DataItem")
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
