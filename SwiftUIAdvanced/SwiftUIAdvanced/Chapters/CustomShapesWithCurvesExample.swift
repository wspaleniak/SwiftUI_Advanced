//
//  CustomShapesWithCurvesExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 10/11/2024.
//



// MARK: - NOTES

// MARK: 6 - Custom shapes with Arcs and Quad Curves in SwiftUI
///
/// - aby zrobić krzywą o określonym promieniu używamy metody `addArc(center:radius:startAngle:endAngle:clockwise:)`
/// - aby zrobić krzywą od punktu do punktu z określonym wygięciem używamy metody `addQuadCurve(to:control:)`



// MARK: - CODE

import SwiftUI

struct ArcShapeFirst: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(300),
                clockwise: false
            )
        }
    }
}



struct ArcShapeSecond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(180),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
    }
}



struct QuadShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.maxY),
                control: CGPoint(x: rect.minX, y: rect.maxY)
            )
            path.addLine(to: .zero)
        }
    }
}



struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.30)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.70)
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        }
    }
}



struct CustomShapesWithCurvesExample: View {
    
    // MARK: - Body
    
    var body: some View {
        ArcShapeFirst()
            .frame(width: 100 , height: 100)
        
        ArcShapeSecond()
            .stroke(lineWidth: 2)
            .frame(width: 100 , height: 100)
        
        QuadShape()
            .stroke(lineWidth: 2)
            .frame(width: 100 , height: 100)
        
        WaterShape()
            .frame(width: 100 , height: 100)
    }
}

// MARK: - Preview

#Preview {
    CustomShapesWithCurvesExample()
}
