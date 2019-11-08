//
//  ContentView.swift
//  Drawing { Paul Hudson }
//
//  Created by Dmitry Novosyolov on 06/11/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    @State private var colorCycle = 0.0
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ColorCyclingCircle(amount: self.colorCycle)
                    .frame(width: 300, height: 300)
                Text("Cycle")
                Slider(value: $colorCycle)
                
                Spacer()
                
                Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                    .fill(Color.pink, style: FillStyle(eoFill: true))
                    .frame(width: 300, height: 300)
                
                Slider(value: $petalOffset, in: -40...40) { Text("Offset")}
                    .padding([.horizontal, .bottom])
                
                Slider(value: $petalWidth, in: 0...100) { Text("Width")}
                    .padding(.horizontal)
            }
        }
    }
}

struct Flower: Shape {
    var petalOffset: Double = -20
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8).forEach {
            let rotation = CGAffineTransform(rotationAngle: $0)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)
            path.addPath(rotatedPetal)
        }
        return path
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)]),
                                                 startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }.drawingGroup()
    }
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        targetHue > 1 ? targetHue -= 1 : nil
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
