//
//  AircraftStateCell.swift
//  OpenSkyUtah
//
//  Created by Koleton Murray on 11/7/24.
//

import SwiftUI

struct AircraftStateCell: View {
    let aircraftState: AircraftState

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(aircraftState.flight)
                    .font(.headline)
                Text(
                    "\(aircraftState.altitude), \(aircraftState.speed), \(aircraftState.ascentRate)"
                )
                .font(.subheadline)
            }
            Spacer()
            Image(systemName: iconName)
                .imageScale(.large)
                .foregroundStyle(.tint)
                .rotationEffect(.degrees(iconRotation))
        }
    }

    private var iconName: String {
        if aircraftState.verticalRate ?? 0 > 0 {
            "airplane.departure"
        } else if aircraftState.verticalRate ?? 0 < 0 {
            "airplane.arrival"
        } else if aircraftState.onGround {
            "airplane.circle"
        } else {
            "airplane"
        }
    }

    private var iconRotation: Double {
        if aircraftState.verticalRate ?? 0 > 0 {
            0
        } else if aircraftState.verticalRate ?? 0 < 0 {
            0
        } else if aircraftState.onGround {
            270
        } else {
            aircraftState.heading
        }
    }
}
