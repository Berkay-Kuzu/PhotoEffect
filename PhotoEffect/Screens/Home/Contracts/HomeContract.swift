//
//  HomeContract.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func handleHomeViewModelOutput(output: HomeViewModelOutput)
}

enum HomeViewModelOutput {
    case reloadData
    case showLoader(status: Bool)
    case showAlert(title: String)
    case reloadItem(index: Int)
}
