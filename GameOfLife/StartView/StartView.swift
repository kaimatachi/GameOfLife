//
//  ContentView.swift
//  GameOfLife
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import SwiftUI

struct StartView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Welcome to the game of life !")
                    .font(.title)
                
                Spacer()
                
                NavigationLink(destination: GameView()) {
                    Text("Start")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(4)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
