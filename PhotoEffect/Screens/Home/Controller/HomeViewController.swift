//
//  ViewController.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    let homeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDelegate()
    }
    
    func applyDelegate(){
        homeViewModel.delegate = self
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func handleHomeViewModelOutput(output: HomeViewModelOutput) {
        //
    }
}
