//
//  GameView.swift
//  GameOfLife
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import SwiftUI

struct GameView: View {
    
    // MARK: - Properties
    
    private static let cellSize: CGFloat = 30
    
    @StateObject private var viewModel = GameViewModel()
    
    // MARK: - View
    
    var body: some View {
        AsyncContentView(source: viewModel) { gameDataSource in
            VStack {
                
                VStack(spacing: 16) {
                    Text("Game of life")
                    
                    Text("Iteration \(gameDataSource.iteration)")
                }
                .padding(.top, 30)
                
                Spacer()
                
                gameGridView(gameDataSource: gameDataSource)
                
                Spacer()
            }
        }
    }
    
}

extension GameView {
    
    private func gameGridView(gameDataSource: GameDataSource) -> some View {
        VStack(spacing: 0) {
            ForEach(0 ..< gameDataSource.size) { rowIndex in
                HStack(spacing: 0) {
                    ForEach(0 ..< gameDataSource.size) { columnIndex in
                        if gameDataSource.grid[rowIndex][columnIndex] == true {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width:GameView.cellSize, height: GameView.cellSize)
                        } else {
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: GameView.cellSize, height: GameView.cellSize)
                        }
                        
                        Divider()
                            .frame(maxHeight: GameView.cellSize)
                    }
                }
                
                Divider()
                    .frame(maxWidth: GameView.cellSize)
            }
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
