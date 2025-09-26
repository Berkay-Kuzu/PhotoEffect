//
//  ViewController.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var draggableView: DraggableView!
    
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
    
    func setupDraggableView(with item : Overlay){
        draggableView.setupViews(overlayItem: item)
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
            case .reloadItem(index: let index):
                let indexPath = IndexPath(row: index, section: 0)
                homeCollectionView.reloadItems(at: [indexPath])
            case .selectedItem(item: let item):
                setupDraggableView(with: item)
                homeCollectionView.reloadData()
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
        homeViewModel.didSelectItemAt(indexPath: indexPath)
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
