//
//  DataStorage.swift
//  FL_test
//
//  Created by lihongli on 2022/11/1.
//
//完成健康数据库存储

import Foundation
import SwiftUI
import CoreData
import UniformTypeIdentifiers
import SwiftUICharts

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "HealthData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

//数据库列表页面
struct DataStorage: View {
    @FetchRequest(sortDescriptors: []) var healthDataset: FetchedResults<HealthDataItem>
    @Environment(\.managedObjectContext) var moc
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(healthDataset) {dataItem in
                    NavigationLink {
                        DateItemDetailView(dataItem: dataItem)
                    } label: {
                        VStack {
                            Text(dataItem.start_time ?? "Unknown")
                            Text(dataItem.end_time ?? "Unknown")
                        }
                    }
                }
                .onDelete(perform: deleteDataItem)
            }
                .navigationTitle("历史记录")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("添加数据", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddItemView()
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
    
    func deleteDataItem(at offsets: IndexSet) {
        for offset in offsets {
            let dataItem = healthDataset[offset]
            moc.delete(dataItem)
        }
        try? moc.save()
    }
}

//管理txt文件的读写
struct TextFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

//单条数据库详情界面
struct DateItemDetailView: View {
    var dataItem: FetchedResults<HealthDataItem>.Element
    @State var document: TextFile = TextFile(initialText: "输入数据")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    var pressure_avarage: Double = 0.0
    @State var step: Int = 0
    
    init(dataItem: FetchedResults<HealthDataItem>.Element) {
        self.dataItem = dataItem
        var pressure_left = (dataItem.pressure_left ?? [0, 1]).reduce(0, +)
        var count = 0
        for value in dataItem.pressure_left ?? [0, 1]{
            if value > 0{
                count = count+1
            }
        }
        pressure_left = pressure_left/Double(count)
        
        var pressure_right = (dataItem.pressure_right ?? [0, 1]).reduce(0, +)
        count = 0
        for value in dataItem.pressure_right ?? [0, 1]{
            if value > 0{
                count = count+1
            }
        }
        pressure_right = pressure_right/Double(count)
        self.pressure_avarage = (pressure_left+pressure_right)*0.85
    }
    
    // 数据分析界面
    var body: some View {
        VStack {
            MultiLineChartView(data: [(dataItem.pressure_left ?? [0.0, 1.0], GradientColors.green), (dataItem.pressure_right ?? [0.0, 1.0], GradientColors.purple)], title: "压感数据", form: CGSize(width: UIScreen.main.bounds.size.width-40, height: 120), rateValue: 0)
            Spacer()
//            GroupBox(label: Text("数据详情")) {
//                ScrollView{
//                    Text(dataItem.data_frame ?? "Unknown")
//                        .fixedSize(horizontal: false, vertical: true)
//                }
//            }
            HStack {
                GroupBox(label: Text("平均压力")) {
                    ChartRingView(progressValues: self.pressure_avarage/Double(dataItem.weight), center_text: "\(Int(self.pressure_avarage))kg")
                        
                }
                
                GroupBox(label: Text("运动步数")) {
                    ChartRingView(progressValues: 0.8, center_text: "\(66)")
                }
            }
            GroupBox {
                HStack {
//                    Spacer()
//
//                    Button(action: {
//                        isImporting = true
//
//                    }, label: {
//                        Text("导入")
//                    })
                    Button(action: {
                        document.text = (dataItem.data_frame ?? "Unknown")
                        isExporting = true
                    }, label: {
                        Label("导出数据", systemImage: "square.and.arrow.up")
                    })
                    
                }
            }
        }
        .padding()
//        .onAppear{
//            self.pressure_avarage_cal()
//        }
        .fileExporter(
             isPresented: $isExporting,
             document: document,
             contentType: .plainText,
             defaultFilename: dataItem.start_time
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
    
    // 计算平均压力数据
    mutating func pressure_avarage_cal() -> Double{
        var pressure_left = (dataItem.pressure_left ?? [0, 1]).reduce(0, +)
        var count = 0
        for value in dataItem.pressure_left ?? [0, 1]{
            if value > 0{
                count = count+1
            }
        }
        pressure_left = pressure_left/Double(count)
        
        var pressure_right = (dataItem.pressure_right ?? [0, 1]).reduce(0, +)
        count = 0
        for value in dataItem.pressure_right ?? [0, 1]{
            if value > 0{
                count = count+1
            }
        }
        pressure_right = pressure_right/Double(count)
        self.pressure_avarage = (pressure_left+pressure_right)*0.85
        
        return pressure_left+pressure_right
    }
    
    func step_avarage_cal(){
        var step_avrage = 0
        
        self.step = step_avrage
    }
    
}


struct DataStorage_Previews: PreviewProvider {
    static var previews: some View {
        DataStorage()
    }
}
