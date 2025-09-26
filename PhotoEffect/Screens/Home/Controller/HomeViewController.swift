//
//  ViewController.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
   
    let homeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDelegate()
        registerCell()
    }
    
    func applyDelegate(){
        homeViewModel.delegate = self
    }
    
    func registerCell(){
        homeCollectionView.registerCell(with: HomeCollectionViewCell.self)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func handleHomeViewModelOutput(output: HomeViewModelOutput) {
        DispatchQueue.main.async { [weak self]  in
            guard let self else {return}
            switch output {
            case .reloadData:
                homeCollectionView.reloadData()
            case .showLoader(let status):
//                homeActivityIndicator.isHidden = !status
                break
            case .showAlert(let title):
                AlertManager.showAlert(title: title, message: "", destinationVC: self)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        homeViewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.cellName, for: indexPath) as! HomeCollectionViewCell
        cell.prepareCell(item: homeViewModel.cellForItemAt(indexPath: indexPath), model: homeViewModel.userModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItemName = homeViewModel.cellForItemAt(indexPath: indexPath).overlayName
        homeViewModel.userModel.name = selectedItemName
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        homeViewModel.sizeForItemAt(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        homeViewModel.insetForSectionAt()
    }
}
