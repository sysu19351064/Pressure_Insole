//
//  ChartView.swift
//  FL_test
//
//  Created by lihongli on 2022/11/17.
//环形图绘制界面

import SwiftUI
//import Charts

extension Color {
    public static var outlineRed: Color {
        return Color(decimalRed: 34, green: 0, blue: 3)
    }
    
    public static var darkRed: Color {
        return Color(decimalRed: 221, green: 31, blue: 59)
    }
    
    public static var lightRed: Color {
        return Color(decimalRed: 239, green: 54, blue: 128)
    }
    
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
}


struct ChartRingView: View {
    var progressValues: Double = 0.0
    @State var progressValuesOrigin: Double = 0.0
    var center_text: String = "Hello"
    var body: some View {
        ZStack() {
            Text(center_text)
                .font(.headline)
                .minimumScaleFactor(0.1)
//                .frame(width: 40, height: 20)
                        
            ActivityRingView(progress: progressValuesOrigin,
                            ringRadius: 100.0,
                            thickness: 20.0,
                            startColor: Color(red: 1.000, green: 0.596, blue: 0.588),
                            endColor: Color(red: 0.839, green: 0.153, blue: 0.157))
        }
        .animation(.linear(duration:0.4))
        .onAppear{
            progressValuesOrigin = progressValues
        }
    }
}


struct ActivityRingView: View {
    var progress: Double
    var ringRadius: Double = 60.0
    var thickness: CGFloat = 20.0
    var startColor = Color(red: 0.784, green: 0.659, blue: 0.941)
    var endColor = Color(red: 0.278, green: 0.129, blue: 0.620)
    
    private var ringTipShadowOffset: CGPoint {
        let ringTipPosition = tipPosition(progress: progress, radius: ringRadius)
        let shadowPosition = tipPosition(progress: progress + 0.0075, radius: ringRadius)
        return CGPoint(x: shadowPosition.x - ringTipPosition.x,
                       y: shadowPosition.y - ringTipPosition.y)
    }
    
    private func tipPosition(progress:Double, radius:Double) -> CGPoint {
        let progressAngle = Angle(degrees: (360.0 * progress) - 90.0)
        return CGPoint(
            x: radius * cos(progressAngle.radians),
            y: radius * sin(progressAngle.radians))
    }
    
    var body: some View {
        let activityAngularGradient = AngularGradient(
            gradient: Gradient(colors: [startColor, endColor]),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360.0 * progress))
        
        ZStack {
            Circle()
                .stroke(startColor.opacity(0.15), lineWidth: thickness)
            
            Circle()
                .trim(from: 0, to: CGFloat(self.progress))
                .stroke(
                    activityAngularGradient,
                    style: StrokeStyle(lineWidth: thickness, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                
            ActivityRingTip(progress: progress,
                            ringRadius: Double(ringRadius))
                .fill(progress>0.95 ? endColor : .clear)
                .frame(width:thickness, height:thickness)
                .shadow(color: progress>0.95 ? .black.opacity(0.3) : .clear,
                        radius: 2.5,
                        x: ringTipShadowOffset.x,
                        y: ringTipShadowOffset.y)
        }
    }
}

struct ActivityRingTip: Shape {
    var progress: Double
    var ringRadius: Double
    
    private var position: CGPoint {
        let progressAngle = Angle(degrees: (360.0 * progress) - 90.0)
        return CGPoint(
            x: ringRadius * cos(progressAngle.radians),
            y: ringRadius * sin(progressAngle.radians))
    }
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        if progress > 0.0 {
            path.addEllipse(in: CGRect(
                                x: position.x,
                                y: position.y,
                                width: rect.size.width,
                                height: rect.size.height))
        }
        return path
    }
}





struct Chart_Previews: PreviewProvider {
//    @State private var progress: CGFloat = 0.3
    static var previews: some View {
        ZStack {
            ChartRingView(progressValues: 0.0)
//                .fixedSize()
        }
    }
}



