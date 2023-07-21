//
//  Realtime.swift
//  FL_test
//
//  Created by lihongli on 2022/10/21.
//

import SwiftUI
import UniformTypeIdentifiers


struct Realtime: View {
    let userItem: User_data
//    let dataItem: FetchedResults<HealthDataItem>.Element
    
    @State var document: TextFile = TextFile(initialText: "AAAAA")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
   
    var body: some View {
            VStack {
                GroupBox(label: Text("Data:")) {
                    Text(userItem.data.joined(separator: " \n"))
//                    TextEditor(text: $document.text)
                }
                GroupBox {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isImporting = true
                            
                        }, label: {
                            Text("Import")
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            document.text = userItem.data.joined(separator: " \n")
                            isExporting = true
                        }, label: {
                            Text("Export")
                        })
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .fileExporter(
                 isPresented: $isExporting,
                 document: document,
                 contentType: .plainText,
                 defaultFilename: "Message"
             ) { result in
                 if case .success = result {
                     // Handle success.
                 } else {
                     // Handle failure.
                 }
             }
             .fileImporter(
                 isPresented: $isImporting,
                 allowedContentTypes: [.plainText],
                 allowsMultipleSelection: false
             ) { result in
                 do {
                     guard let selectedFile: URL = try result.get().first else { return }
                     guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }

                     document.text = message
                 } catch {
                     // Handle failure.
                 }
             }
        }
}

//struct Realtime_Previews: PreviewProvider {
//    let viewContext = PersistenceController.preview.container.viewContext
//    
//    static var previews: some View {
//        Realtime(userItem: User_data(data: ["YYYY", "ZZZZ"]))
//    }
//}

