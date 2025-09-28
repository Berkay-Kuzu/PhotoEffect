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
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var homeActivityIndicator: UIActivityIndicatorView!
    
    private lazy var histogramView: HistogramView = {
        let view = HistogramView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDelegate()
        registerCell()
        updateUI()
        setupHistogramView()
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
    
    func updateUI(){
        saveButton.isHidden = homeViewModel.userModel.name == nil ? true : false
    }
    
    func setupHistogramView() {
        view.addSubview(histogramView)
        
        NSLayoutConstraint.activate([
            histogramView.trailingAnchor.constraint(equalTo: homeImageView.trailingAnchor, constant: 0),
            histogramView.bottomAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: 0),
            histogramView.widthAnchor.constraint(equalToConstant: 200),
            histogramView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let bottomImage = homeImageView.image,
              let topImage = homeViewModel.downloadedImage else { return }
        
        if let savedURL = homeViewModel.handleSave(bottom: bottomImage,
                                                   top: topImage,
                                                   frame: CGRect(x: 50, y: 50, width: 200, height: 200),
                                                   asPNG: true) {
            AlertManager.showAlert(title: "Success", message: "The image is saved: \(savedURL.lastPathComponent)", destinationVC: self)
            print("✅ Image Saved: \(savedURL)")
            
            homeViewModel.updateHistogram(bottomImage: bottomImage, topImage: topImage)
        }
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
                homeActivityIndicator.isHidden = !status
            case .showAlert(let title):
                AlertManager.showAlert(title: title, message: "", destinationVC: self)
            case .reloadItem(index: let index):
                let indexPath = IndexPath(row: index, section: 0)
                homeCollectionView.reloadItems(at: [indexPath])
            case .selectedItem(item: let item):
                setupDraggableView(with: item)
                updateUI()
                homeCollectionView.reloadData()
            case .histogram(item: let item):
                histogramView.updateHistogram(red: item.red, green: item.green, blue: item.blue)
                histogramView.isHidden = false
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
