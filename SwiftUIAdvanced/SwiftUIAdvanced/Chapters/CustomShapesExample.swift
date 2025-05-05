//
//  CustomShapesExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 05/11/2024.
//



// MARK: - NOTES

// MARK: 5 - Custom Shapes in SwiftUI
///
/// - aby stworzyć customowy kształt musimy stworzyć strukturę zgodną z protokołem `Shape`
/// - oraz zaimplementować wymaganą metodę `path(in rect: CGRect) -> Path`
/// - argument `rect` to czworokąt w który wpisany jest kształt
/// - wewnątrz metody tworzymy obiekt typu `Path` z domknięciem i wywołujemy metody na argumencie `path`
/// - metoda `move(to:)` pozwala ustawić pierwszy punkt nowego kształtu
/// - metoda `addLine(to:)` pozwala narysować linię łączącą poprzedni z punkt z nowo określonym



// MARK: - CODE

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}



struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset = rect.width * 0.2
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}



struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset = rect.width * 0.2
            path.move(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
        }
    }
}



struct CustomShapesExample: View {
    
    // MARK: - Body
    
    var body: some View {
        Rectangle()
            .trim(from: 0, to: 0.5)
            .frame(width: 100, height: 100)
        
        Triangle()
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [10]))
            .foregroundStyle(.indigo)
            .frame(width: 100, height: 100)
        
        Diamond()
            .frame(width: 100, height: 100)
        
        Trapezoid()
            .frame(width: 200, height: 50)
    }
}

// MARK: - Preview

#Preview {
    CustomShapesExample()
}
