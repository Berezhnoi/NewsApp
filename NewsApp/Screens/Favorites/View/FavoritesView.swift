//
//  FavoritesView.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import Foundation

class FavoritesView: MainView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setMainViewDelegate(mainViewDelegate: MainViewDelegate) {
        self.delegate = mainViewDelegate
    }
}
