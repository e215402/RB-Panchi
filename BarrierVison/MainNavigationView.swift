//
//  MainNavigationView.swift
//  BarrierVison
//
//  Created by e215402 on 2023/10/03.
//

import SwiftUI

struct MainNavigationView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Spacer()
                Image("Image1")
                    .resizable()
                    .scaledToFit()

                Spacer()
                NavigationLink(destination: ARContentView()) {
                    Text("START")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                /*
                NavigationLink(destination: MappingView()){
                    Text("MAPPING")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                */
                NavigationLink(destination: ExplainView()) {
                    Text("ABOUT")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                
            }
            .padding()
        }
    }
}

