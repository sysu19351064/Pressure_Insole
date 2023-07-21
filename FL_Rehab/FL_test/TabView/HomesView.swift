//
//  HomesView.swift
//  FL_test
//
//  Created by lihongli on 2022/10/22.
//
//首页面，对软件进行介绍
import SwiftUI
import AVKit
import AVFoundation

struct PlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }

    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(frame: .zero)
    }
}

class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Load the resource
        let fileUrl = Bundle.main.url(forResource: "demoVideo", withExtension: "mp4")!
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)

        // Setup the player
        let player = AVQueuePlayer()
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)

        // Start the movie
        player.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}


struct HomesView: View {

    var body: some View {
        GeometryReader{ geo in
            ZStack{
                PlayerView()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height+100)
                    .overlay(Color.black.opacity(0.2))
                    .blur(radius: 1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    Text("使用方法")
                        .font(.largeTitle)
                    Spacer()
                        .frame(height: 40)
                    
                    Text("步骤1：链接设备无线局域网")
                        .font(.headline)
                    Spacer()
                        .frame(height: 30)
                    Text("步骤2：输入测试者身体特征")
                        .font(.headline)
                    Spacer()
                        .frame(height: 30)
                    Text("步骤3:实时检测行走过程")
                        .font(.headline)
                }
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background{
//            ZStack {
//                VStack {
//                    Circle()
//                        .fill(Color.green)
//                        .scaleEffect(0.6)
//                        .offset(x:20)
//                        .blur(radius: 120)
//
//                    Circle()
//                        .fill(Color.purple)
//                        .scaleEffect(0.6)
//                        .offset(x:-20)
//                        .blur(radius: 120)
//                }
//            }
//            .ignoresSafeArea()
        }
//        .preferredColorScheme(.dark)
        
}


struct HomesView_Previews: PreviewProvider {
    static var previews: some View {
        HomesView()
    }
}
