//
//  CustomShapesAnimateableDataExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 11/11/2024.
//



// MARK: - NOTES

// MARK: 7 - Animate Custom shapes with AnimateableData in SwiftUI
///
/// - aby móc animować obiekt typu `Shape` musimy dodać pole `animatableData` o określonym typie



// MARK: - CODE

import SwiftUI

struct RoundedRectangleShape: Shape {
    
    // MARK: - Properties
    
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { cornerRadius }
        set { cornerRadius = newValue }
    }
    
    // MARK: - Methods
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: .zero)
        }
    }
}



struct PacmanShape: Shape {
    
    // MARK: - Properties
    
    var offset: Double
    
    var animatableData: Double {
        get { offset }
        set { offset = newValue }
    }
    
    // MARK: - Methods
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2,
                startAngle: .degrees(offset),
                endAngle: .degrees(360 - offset),
                clockwise: false
            )
        }
    }
}



struct CustomShapesAnimateableDataExample: View {
    
    // MARK: - Properties
    
    @State
    private var animate: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            RoundedRectangleShape(cornerRadius: animate ? 60 : 0)
                .stroke(lineWidth: 2)
                .frame(width: 200, height: 200)
            
            PacmanShape(offset: animate ? 20 : 0)
                .frame(width: 200, height: 200)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.0).repeatForever()) {
                animate.toggle()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CustomShapesAnimateableDataExample()
}
