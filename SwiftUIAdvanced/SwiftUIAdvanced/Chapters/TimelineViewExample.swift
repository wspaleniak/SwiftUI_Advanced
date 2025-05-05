//
//  TimelineViewExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 02/02/2025.
//



// MARK: - NOTES

// MARK: 26 - How to use TimelineView in SwiftUI
///
/// - widok `TimelineView` pozwala odświeżać umieszczone wewnątrz widoki co określony interwał czasowy
/// - defaultowo jest to odświeżanie ciągłe przez cały czas
/// - możemy wybrać inne interwały albo podać swój np. `.animation(minimumInterval: 1.0)`
/// - aktualizowanie czasu możemy zatrzymać przekazując argument `paused` i zarządzając nim z zewnątrz
/// - nie jest to polecane do np. pobierania danych z backgroundu co określony czas - do tego lepszy jest prosty timer



// MARK: - CODE

import SwiftUI

struct TimelineViewExample: View {
    
    // MARK: - Properties
    
    @State
    private var startTime: Date = .now
    
    @State
    private var pauseAnimation: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 40) {
            TimelineView(.animation(minimumInterval: 1.0, paused: pauseAnimation)) { context in
                Text("\(context.date.timeIntervalSince1970)")
                
                // let seconds = Calendar.current.component(.second, from: context.date)
                let seconds = context.date.timeIntervalSince(startTime)
                
                Text("\(seconds)")
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.indigo)
                    .frame(
                        width: seconds < 10 ? 50 : seconds < 30 ? 200 : 300,
                        height: 100
                    )
                    .animation(.bouncy, value: seconds)
                
                switch context.cadence {
                case .live: Text("Cadence LIVE")
                case .seconds: Text("Cadence SECONDS")
                case .minutes: Text("Cadence MINUTES")
                @unknown default: Text("Cadence UNKNOWN")
                }
            }
            
            Button(pauseAnimation ? "Play" : "Pause") {
                pauseAnimation.toggle()
                startTime = .now
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TimelineViewExample()
}
