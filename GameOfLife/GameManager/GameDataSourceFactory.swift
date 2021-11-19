//
//  GameDataSourceFactory.swift
//  GameOfLife
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import Foundation

struct GameDataSourceFactory {
    
    static func empty(size: Int) -> GameDataSource {
        let grid = Array(repeating: Array(repeating: false, count: size), count: size)
        return GameDataSource(grid: grid, size: size)
    }
    
    static func random(size: Int) -> GameDataSource {
        var grid = [[Bool]]()
        
        for _ in 0 ..< size {
            var columnArray = [Bool]()
            
            for _ in 0 ..< size {
                columnArray.append(Bool.random())
            }
            
            grid.append(columnArray)
        }
        
        return GameDataSource(grid: grid, size: size)
    }
    
    static func create(grid: [[Bool]]) -> GameDataSource {
        return GameDataSource(grid: grid, size: grid.count)
    }
    
}
