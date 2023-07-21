//
//  FootShape.swift
//  FL_test
//
//  Created by lihongli on 2022/10/24.
//
//绘制脚掌分区形状

import SwiftUI

struct FootRightView: View {
    var rad: Double
//    var pressure_str: String = "AAAAAAAAAAAAAAAAAAAAAAAA"
    let pressure_arr: Array<Double>
    var body: some View {
        ZStack{
            FootShapeRight()
                .scale(1.3)
                .fill().foregroundColor(Color.green.opacity(0.8))
                .frame(width: 190, height: 442)
                .offset(x: 31, y: 67)
            
            VStack {
                //lline 6
                HStack(alignment: .bottom){
                    // column 1
                    FootShapePart2(high: 65, curve: 30, top: 10, buttom: 28)
                        .scale(x:-1, y: 1, anchor: .center)
                        .frame(width: 30, height: 65)
                        .foregroundColor(Color(red: (pressure_arr[20] > 0.5 ? 1 : pressure_arr[20]), green: (pressure_arr[20] < 0.5 ? 1 : 1-pressure_arr[20]), blue: 0).opacity(0.6))
                        
                    // column 2
                    FootShapePart2(high: 30, curve: 20, top: 65, buttom: 68)
                        .scale(x: 1, y: -1, anchor: .center)
                        .rotation(Angle(degrees: 270))
                        .offset(x:-18, y: 18)
                        .frame(width: 30, height: 65)
                        .foregroundColor(Color(red: (pressure_arr[21] > 0.5 ? 1 : pressure_arr[21]), green: (pressure_arr[21] < 0.5 ? 1 : 1-pressure_arr[21]), blue: 0).opacity(0.6))
                    
                    // column 3
                    FootShapePart2(high: 30, curve: 20, top: 50, buttom: 62)
                        .scale(x: 1, y: -1, anchor: .center)
                        .rotation(Angle(degrees: 270))
                        .offset(x:-18, y: 18)
                        .frame(width: 30, height: 65)
                        .foregroundColor(Color(red: (pressure_arr[22] > 0.5 ? 1 : pressure_arr[22]), green: (pressure_arr[22] < 0.5 ? 1 : 1-pressure_arr[22]), blue: 0).opacity(0.6))
                    
                    // column 4
                    FootShapePart2(high: 45, curve: 25, top: 5, buttom: 38)
                        .scale(x: 1, y: 1, anchor: .center)
                        .frame(width: 35, height: 45)
                        .foregroundColor(Color(red: (pressure_arr[23] > 0.5 ? 1 : pressure_arr[23]), green: (pressure_arr[23] < 0.5 ? 1 : 1-pressure_arr[23]), blue: 0).opacity(0.6))
                }
                .offset(x: -23, y: 0)
                .drawingGroup()
                
                // line 5
                HStack(){
                    // column 1
                    FootShapePart2(high: 65, curve: 25, top: 26, buttom: 33)
                        .scale(x: -1, y: -1, anchor: .center)
                        .frame(width: 35, height: 65)
                        .foregroundColor(Color(red: (pressure_arr[16] > 0.5 ? 1 : pressure_arr[16]), green: (pressure_arr[16] < 0.5 ? 1 : 1-pressure_arr[16]), blue: 0).opacity(0.6))
                    
                    // column 2
                    Rectangle()
                        .frame(width: 35, height: 65)
                        .foregroundColor(Color(red: (pressure_arr[17] > 0.5 ? 1 : pressure_arr[17]), green: (pressure_arr[17] < 0.5 ? 1 : 1-pressure_arr[17]), blue: 0).opacity(0.6))
                    
                    // column 3
                    Rectangle()
                        .frame(width: 35, height: 65)
                        .foregroundColor(Color(red: (pressure_arr[18] > 0.5 ? 1 : pressure_arr[18]), green: (pressure_arr[18] < 0.5 ? 1 : 1-pressure_arr[18]), blue: 0).opacity(0.6))
                    

                        // column 4
                        FootShapePart2(high: 65, curve: 25, top: 26, buttom: 38)
                            .frame(width: 48, height: 65)
                            .foregroundColor(Color(red: (pressure_arr[19] > 0.5 ? 1 : pressure_arr[19]), green: (pressure_arr[19] < 0.5 ? 1 : 1-pressure_arr[19]), blue: 0).opacity(0.6))
                }
                .offset(x: -8, y: 0)
                .drawingGroup()
                
                // line4
                HStack {
                    // column 2
                    FootShapePart2(high: 60, curve: 30, top: 53, buttom: 32)
                        .scale(x:-1, y: 1, anchor: .center)
                        .frame(width: 53, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[13] > 0.5 ? 1 : pressure_arr[13]), green: (pressure_arr[13] < 0.5 ? 1 : 1-pressure_arr[13]), blue: 0).opacity(0.6))

                    // column 3
                    Rectangle()
                        .frame(width: 40, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[14] > 0.5 ? 1 : pressure_arr[14]), green: (pressure_arr[14] < 0.5 ? 1 : 1-pressure_arr[14]), blue: 0).opacity(0.6))
                    
                    // column 4
                    FootShapePart2(high: 60, curve: 45, top: 39, buttom: 46)
                        .scale(x:1, y: -1, anchor: .center)
                        .frame(width: 46, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[15] > 0.5 ? 1 : pressure_arr[15]), green: (pressure_arr[15] < 0.5 ? 1 : 1-pressure_arr[15]), blue: 0).opacity(0.6))
                }
                .offset(x: -5, y: 0)
                .drawingGroup()
                
                
                // line3
                HStack {
                    // column 2
                    FootShapePart2(high: 60, curve: 30, top: 37, buttom: 33)
                        .scale(x:-1, y: 1, anchor: .center)
                        .frame(width: 50, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[9] > 0.5 ? 1 : pressure_arr[9]), green: (pressure_arr[9] < 0.5 ? 1 : 1-pressure_arr[9]), blue: 0).opacity(0.6))

                    // column 3
                    Rectangle()
                        .frame(width: 30, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[10] > 0.5 ? 1 : pressure_arr[10]), green: (pressure_arr[10] < 0.5 ? 1 : 1-pressure_arr[10]), blue: 0).opacity(0.6))
                    
                    // column 4
                    FootShapePart2(high: 60, curve: 45, top: 38, buttom: 32)
                        .scale(x:1, y: 1, anchor: .center)
                        .frame(width: 48, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[11] > 0.5 ? 1 : pressure_arr[11]), green: (pressure_arr[11] < 0.5 ? 1 : 1-pressure_arr[11]), blue: 0).opacity(0.6))
                }
                .offset(x: 0, y: 0)
                .drawingGroup()
                
                
                // line2
                HStack {
                    // column 2
                    Rectangle()
                        .frame(width: 45, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[5] > 0.5 ? 1 : pressure_arr[5]), green: (pressure_arr[5] < 0.5 ? 1 : 1-pressure_arr[5]), blue: 0).opacity(0.6))
                    Spacer()
                        .frame(width: 14)
                    // column 3
                    Rectangle()
                        .frame(width: 45, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[6] > 0.5 ? 1 : pressure_arr[6]), green: (pressure_arr[6] < 0.5 ? 1 : 1-pressure_arr[6]), blue: 0).opacity(0.6))
                }
                .offset(x: 0, y: 0)
                .drawingGroup()
                
                // line 1
                
                HStack {
                    // colmn 2
                    FootShapePart1(high: 65, radius: 45)
                        .frame(width: 48, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[1] > 0.5 ? 1 : pressure_arr[1]), green: (pressure_arr[1] < 0.5 ? 1 : 1-pressure_arr[1]), blue: 0).opacity(0.6))
                    
                    // column 3
                    FootShapePart1(high: 65, radius: 45)
                        .scale(x: -1, y: 1, anchor: .center)
                        .frame(width: 48, height: 60)
                        .foregroundColor(Color(red: (pressure_arr[2] > 0.5 ? 1 : pressure_arr[2]), green: (pressure_arr[2] < 0.5 ? 1 : 1-pressure_arr[2]), blue: 0).opacity(0.6))
                }
                .offset(x: 0, y: 0)
                .drawingGroup()
            }
//            .foregroundColor(Color(red: (color_value > 0.5 ? 1 : color_value), green: (color_value < 0.5 ? 1 : 1-color_value), blue: 0))
            .offset(x: 12, y: 0)
            .blur(radius: rad)
        }
        .drawingGroup()
    }
}


struct FootShapeRight: Shape {
    func path(in rect: CGRect) -> Path {
        let start_width = 30
        let start_height = 290
        let rad1 = 50
        let point1 = CGPoint(x: start_width, y: start_height)
        let point2 = CGPoint(x: start_width+rad1, y: start_height)
//        let point3 = CGPoint(x: start_width+rad1*2, y: start_height)
        let point4 = CGPoint(x: start_width+rad1*2, y: start_height-60)
        let point5 = CGPoint(x: point4.x+7, y: point4.y-50)
        let point6 = CGPoint(x: point5.x+7, y: point5.y-50)
        let point7 = CGPoint(x: point6.x-100, y: 0)
        let point8 = CGPoint(x: 0, y: 60)
        let point9 = CGPoint(x: point8.x+15, y: point8.y+80)
        let point10 = CGPoint(x: point9.x+15, y: point9.y+80)
        
        var path = Path()
        path.move(to: point1)
        path.addArc(center: point2, radius: CGFloat(50), startAngle: .degrees(180), endAngle: .degrees(0), clockwise: true)
        path.addLine(to: point4)
        path.addQuadCurve(to: point5, control: CGPoint(x: point4.x, y: point5.y+25))
        
        path.addQuadCurve(to: point6, control: CGPoint(x: point6.x, y: point5.y-25))
        
        path.addQuadCurve(to: point7, control: CGPoint(x: point6.x, y: point7.y+15))
        
        path.addQuadCurve(to: point8, control: CGPoint(x: point8.x, y: point7.y))
        path.addQuadCurve(to: point9, control: CGPoint(x: point8.x, y: point8.y+55))
        path.addQuadCurve(to: point10, control: CGPoint(x: point10.x, y: point10.y-55))
        
        path.closeSubpath()
        return path
    }
}

struct FootShapePart1: Shape {
    var high: CGFloat
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path{
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: high-radius))
        path.addArc(center: CGPoint(x: radius, y: high-radius), radius: CGFloat(radius), startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
        path.addLine(to: CGPoint(x: radius, y: 0))
        path.closeSubpath()
        return path
    }
}

struct FootShapePart2: Shape {
    var high: CGFloat
    var curve: CGFloat
    var top: CGFloat
    var buttom: CGFloat
    
    func path(in rect: CGRect) -> Path{
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: high))
        path.addLine(to: CGPoint(x: buttom, y: high))
        path.addQuadCurve(to: CGPoint(x: top, y: 0), control: CGPoint(x: buttom, y: curve))
        path.closeSubpath()
        return path
    }
}


struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var customShape = Path { p in
            p.move(to: CGPoint(x: 0, y: 0))
            p.addQuadCurve(to: CGPoint(x: 0, y: 100),
                           control: CGPoint(x: 0, y: 0))
            p.addCurve(to: CGPoint(x: 100, y: 400),
                       control1: CGPoint(x: 0, y: 200),
                       control2: CGPoint(x: 100, y: 200))
            p.addCurve(to: CGPoint(x: 200, y: 100),
                       control1: CGPoint(x: 100, y: 200),
                       control2: CGPoint(x: 200, y: 200))
            p.addQuadCurve(to: CGPoint(x: 200, y: 0),
                           control: CGPoint(x: 200, y: 0))
        }

        let rectangle = Rectangle()
            .path(in: customShape.boundingRect)
            .offsetBy(dx: 100, dy: 0)

        customShape.addPath(rectangle, transform: .init(scaleX: 0.5, y: 0.35))

        return customShape
    }
}

