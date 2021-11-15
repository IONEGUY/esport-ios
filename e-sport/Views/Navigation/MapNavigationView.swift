//
//  MapNavigationView.swift
//  e-sport
//
//  Created by MacBook on 13.10.21.
//

import SwiftUI
import MapKit

struct MapNavigationView: View {
    @ObservedObject var viewModel: MapNavigationViewModel = MapNavigationViewModel()
    @State private var bottomSheetShown = false
    
    var body: some View {
        NavigationView {
            ZStack {
                MapViewWithRoute(userLocation: $viewModel.currentLocation)
                    .edgesIgnoringSafeArea(.top)
                    .navigationTitle("Navigation")
                BottomSheetView(isOpen: self.$bottomSheetShown, maxHeight: 250) {
                    VStack(alignment: .leading, spacing: 17) {
                        HStack {
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.green)
                            Spacer()
                            Button(action: { bottomSheetShown = false }) {
                                Image("cross")
                                    .frame(width: 30, height: 30)
                                    .background(Color(hex: 0x3A3A3C))
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal, 16)
                        Rectangle()
                            .frame(width: UIScreen.width, height: 0.2)
                            .foregroundColor(Color.gray)
                        Text("ADDRESS")
                            .foregroundColor(Color(hex: 0xFFFFFF, alpha: 0.16))
                            .font(.system(size: 13, weight: .thin))
                            .padding(.leading, 16)
                        Text(viewModel.currentSelectedPin?.description ?? .empty)
                            .foregroundColor(Color.white)
                            .font(.system(size: 17, weight: .bold))
                            .lineLimit(nil)
                            .padding(.horizontal, 16)
                    }
                    .background(Color(hex: 0x1C1C1E))
                }
                .zIndex(10)
            }
        }
    }
}

struct MapNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MapNavigationView()
    }
}
