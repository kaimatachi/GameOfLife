//
//  ViewModelState.swift
//  GameOfLife
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import Foundation

enum ViewModelState<T> {
    
    case loading
    case finished(T)
    case error(String)

}
