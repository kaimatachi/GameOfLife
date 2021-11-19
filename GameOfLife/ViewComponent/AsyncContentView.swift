//
//  AsyncContentView.swift
//  GameOfLife
//
//  Created by Jérémy Van Cauteren on 16/11/2021.
//

import SwiftUI

struct AsyncContentView<Value, ContentView, LoadingView, ErrorView>: View where ContentView: View, LoadingView: View, ErrorView: View {
    
    // MARK: - Properties
    
    private let state: ViewModelState<Value>
    private let fetchData: () -> Void
    
    private let contentView: (Value) -> ContentView
    private let loadingView: () -> LoadingView
    private let errorView: (String) -> ErrorView
    
    // MARK: - Init's
    
    init<Source>(source: Source,
                 @ViewBuilder contentView: @escaping (Value) -> ContentView,
                 @ViewBuilder loadingView: @escaping () -> LoadingView,
                 @ViewBuilder errorView: @escaping (String) -> ErrorView) where Source: ViewModel, Source.Value == Value {
        self.init(state: source.state, fetchData: source.fetchData, contentView: contentView, loadingView: loadingView, errorView: errorView)
    }
    
    init(state: ViewModelState<Value>, fetchData: @escaping () -> Void,
         @ViewBuilder contentView: @escaping (Value) -> ContentView,
         @ViewBuilder loadingView: @escaping () -> LoadingView,
         @ViewBuilder errorView: @escaping (String) -> ErrorView) {
        self.state = state
        self.fetchData = fetchData
        self.contentView = contentView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    // MARK: - View
    
    var body: some View {
        switch state {
        case .loading:
            loadingView().onAppear { fetchData() }
        case .finished(let result):
            contentView(result)
        case .error(let error):
            errorView(error)
        }
    }
    
}

// MARK: LoadingView

extension AsyncContentView where LoadingView == ProgressView<EmptyView, EmptyView> {
    
    init<Source>(source: Source,
                 @ViewBuilder contentView: @escaping (Value) -> ContentView,
                 @ViewBuilder errorView: @escaping (String) -> ErrorView) where Source: ViewModel, Source.Value == Value {
        self.init(source: source, contentView: contentView, loadingView: { ProgressView() }, errorView: errorView)
    }
    
}

// MARK: ErrorView

extension AsyncContentView where ErrorView == Text {
    
    init<Source>(source: Source,
                 @ViewBuilder contentView: @escaping (Value) -> ContentView,
                 @ViewBuilder loadingView: @escaping () -> LoadingView) where Source: ViewModel, Source.Value == Value {
        self.init(source: source, contentView: contentView, loadingView: loadingView, errorView: { error in Text(error) })
    }
    
}

// MARK: LoadingView && ErrorView

extension AsyncContentView where ErrorView == Text, LoadingView == ProgressView<EmptyView, EmptyView> {
    
    init<Source>(source: Source, @ViewBuilder contentView: @escaping (Value) -> ContentView) where Source: ViewModel, Source.Value == Value {
        self.init(source: source, contentView: contentView, loadingView: { ProgressView() }, errorView: { error in Text(error) })
    }
    
}
