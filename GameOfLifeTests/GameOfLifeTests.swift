//
//  GameManagerTests.swift
//  GameOfLifeTests
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import XCTest
import Combine
@testable import GameOfLife

class GameManagerTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        super.tearDown()
        cancellables.forEach {
            $0.cancel()
        }
    }

    func testStartIteratingOneIteration() throws {
        let grid = [[true, false, true],
                    [false, true, true],
                    [true, false, false]]
        let manager = GameManager(dataSource: GameDataSourceFactory.create(grid: grid))
        let exp = expectation(description: "First iteration computed")
        var resultCompletion: GameDataSource?
        
        manager.dataSourceSubject
            .dropFirst()
            .sink { gameDataSource in
                resultCompletion = gameDataSource
                exp.fulfill()
            }
        .store(in: &cancellables)
        
        manager.startIterating(numberOfIterations: 1)
        wait(for: [exp], timeout: 5)
        
        let expectedGrid = [[false, false, true],
                            [true, false, true],
                            [false, true, false]]
        
        XCTAssert(resultCompletion?.grid == expectedGrid)
    }
    
    func testStartIteratingFiveIteration() throws {
        let grid = [[false, true, true, false, false, false, false, true, true, true],
                    [true, true, true, false, true, true, false, true, true, false],
                    [false, false, false, false, true, true, false, true, false, true],
                    [true, true, true, false, true, true, true, true, true, true],
                    [false, false, false, false, false, false, false, true, true, true],
                    [true, true, true, false, true, true, false, true, false, true],
                    [true, false, true, true, false, false, true, false, false, false],
                    [false, false, false, true, false, false, false, true, true, false],
                    [true, true, true, true, true, false, false, false, true, false],
                    [true, true, false, false, false, false, false, true, true, true]]
        
        let manager = GameManager(dataSource: GameDataSourceFactory.create(grid: grid))
        let exp = expectation(description: "Five iterations computed")
        var resultCompletion: GameDataSource?
        
        manager.dataSourceSubject
            .dropFirst(5)
            .sink { gameDataSource in
                resultCompletion = gameDataSource
                exp.fulfill()
            }
        .store(in: &cancellables)
        
        manager.startIterating(numberOfIterations: 5)
        wait(for: [exp], timeout: 15)
        
        let expectedGrid = [[false, false, false, false, false, false, true, true, false, false],
                            [false, false, true, false, true, false, false, true, false, false],
                            [false, false, true, true, true, false, true, true, false, false],
                            [false, false, false, false, false, false, true, false, false, false],
                            [false, false, false, false, true, true, true, false, false, false],
                            [true, true, false, false, false, true, false, false, false, false],
                            [true, false, false, false, false, false, false, false, false, false],
                            [true, false, true, false, false, true, true, true, false, false],
                            [true, false, false, true, false, true, false, true, false, false],
                            [false, true, true, false, false, false, false, true, false, false]]
        
        XCTAssert(resultCompletion?.grid == expectedGrid)
    }

}
