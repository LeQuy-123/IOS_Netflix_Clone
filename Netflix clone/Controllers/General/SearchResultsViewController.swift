//
//  SearchResultsViewController.swift
//  Netflix clone
//
//  Created by mac on 15/7/24.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewModel)
}

class SearchResultsViewController: UIViewController {

    public var titles: [Title] = [Title]()
    
    weak var delegate: SearchResultsViewControllerDelegate?

    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 3
        layout.itemSize = CGSize(width: width - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectioNView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectioNView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectioNView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }

}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.name else {return}
        print(titleName)
        APICaller.shared.getYoutubeData(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                guard let videoId = videoElement.items.first?.id else { return }
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewModel(title: titleName, youtubeView: videoId, titleOverView: title.overview ))

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
