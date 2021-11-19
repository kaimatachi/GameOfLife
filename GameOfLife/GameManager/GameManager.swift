//
//  GameManager.swift
//  GameOfLife
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import Foundation
import Combine

private typealias CellLocation = (row: Int, column: Int)

class GameManager {
    
    // MARK: - Properties
    
    private static let gameSize: Int = 10
    private static let numberOfIterations: Int = 5
    private static let secondBetweenIterations: Int = 2
    
    private(set) var dataSourceSubject: CurrentValueSubject<GameDataSource, Never>
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Init
    
    init(dataSource: GameDataSource = GameDataSourceFactory.random(size: gameSize)) {
        self.dataSourceSubject = CurrentValueSubject<GameDataSource, Never>(dataSource)
    }
    
}

// MARK: - Iterations

extension GameManager {
    
    func startIterating(numberOfIterations: Int = numberOfIterations)  {
        timerCancellable = Timer.publish(every: 2, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .map { [unowned self] _ in self.computeNextIteration() }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newGameDataSource in
                guard let self = self else { return }
                self.dataSourceSubject.send(newGameDataSource)
                
                if newGameDataSource.iteration == numberOfIterations {
                    self.timerCancellable?.cancel()
                }
            }
    }
    
    private func computeNextIteration() -> GameDataSource {
        let currentGameSize = dataSourceSubject.value.size
        var newDataSource = GameDataSourceFactory.empty(size: currentGameSize)
        
        for rowIndex in 0 ..< currentGameSize {
            for columnIndex in 0 ..< currentGameSize {
                newDataSource.grid[rowIndex][columnIndex] = computeCellNextState(dataSource: dataSourceSubject.value, rowIndex: rowIndex, columnIndex: columnIndex, isAlive: dataSourceSubject.value.grid[rowIndex][columnIndex])
            }
        }
        
        newDataSource.iteration =  dataSourceSubject.value.iteration + 1
        
        return newDataSource
    }
    
}

// MARK: - Cell state

extension GameManager {
    
    private func computeCellNextState(dataSource: GameDataSource, rowIndex: Int, columnIndex: Int, isAlive: Bool) -> Bool {
        let locationToCheck = getLocationToCheck(rowIndex: rowIndex, columnIndex: columnIndex)
        
        var countOfCellAlive = 0
        for cellLocation in locationToCheck {
            guard cellLocation.row >= 0 && cellLocation.column >= 0 && cellLocation.row < dataSource.size && cellLocation.column < dataSource.size else {
                continue
            }
            
            if dataSource.grid[cellLocation.row][cellLocation.column] == true {
                countOfCellAlive += 1
            }
        }
        
        if isAlive && (countOfCellAlive == 2 || countOfCellAlive == 3) {
            return true
        } else if !isAlive && countOfCellAlive == 3 {
            return true
        } else {
            return false
        }
    }
    
    private func getLocationToCheck(rowIndex: Int, columnIndex: Int) -> [CellLocation] {
        var locationToCheck = [CellLocation] ()
        locationToCheck.append(CellLocation(row: rowIndex - 1, column: columnIndex - 1))
        locationToCheck.append(CellLocation(row: rowIndex - 1, column: columnIndex))
        locationToCheck.append(CellLocation(row: rowIndex - 1, column: columnIndex + 1))
        
        locationToCheck.append(CellLocation(row: rowIndex, column: columnIndex - 1))
        locationToCheck.append(CellLocation(row: rowIndex, column: columnIndex + 1))
        
        locationToCheck.append(CellLocation(row: rowIndex + 1, column: columnIndex - 1))
        locationToCheck.append(CellLocation(row: rowIndex + 1, column: columnIndex))
        locationToCheck.append(CellLocation(row: rowIndex + 1, column: columnIndex + 1))
        return locationToCheck
    }
    
}
