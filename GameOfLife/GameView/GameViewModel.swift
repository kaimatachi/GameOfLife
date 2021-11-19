//
//  GameViewModel.swift
//  GameOfLife
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import Foundation
import Combine

class GameViewModel: ObservableObject, ViewModel {
    
    // MARK: - Properties
    
    @Published var state = ViewModelState<GameDataSource>.loading
    
    private let manager = GameManager()
    private var cancellables = Set<AnyCancellable>()
    
}

// MARK: - Fetch data

extension GameViewModel {
    
    func fetchData() {
        manager.dataSourceSubject.sink { [weak self] gameDataSource in
            guard let self = self else { return }
            self.state = .finished(gameDataSource)
        }
        .store(in: &cancellables)
        manager.startIterating()
    }
    
}
