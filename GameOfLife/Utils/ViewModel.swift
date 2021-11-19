//
//  ViewModel.swift
//  GameOfLife
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import Foundation

protocol ViewModel {
    
    associatedtype Value
    
    var state: ViewModelState<Value> { get set }
    
    func fetchData()
    
}
