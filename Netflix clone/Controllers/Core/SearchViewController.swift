//
//  UpcommingViewController.swift
//  Netflix clone
//
//  Created by mac on 13/7/24.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
    private var titles: [Title] = [Title]()
    private var currentPage = 1
    private var isLoadingMore = false

    private let upcommingTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    private let searchControler: UISearchController = {
        let searchBar = UISearchController(searchResultsController: SearchResultsViewController())
        searchBar.searchBar.placeholder = "Search for a Movie"
        searchBar.searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white

        navigationController?.navigationItem.largeTitleDisplayMode = .always
        // Do any additional setup after loading the view.
        
        view.addSubview(upcommingTableView)
        
        navigationItem.searchController = searchControler
        
        
        upcommingTableView.delegate = self
        upcommingTableView.dataSource = self
        
        fetchDiscoverMovie(page: nil)
        
        searchControler.searchResultsUpdater = self
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcommingTableView.frame = view.bounds
        
    }
    
    private func fetchDiscoverMovie(page: Int?) {
        isLoadingMore = true
        APICaller.shared.discoverMovie(page: page ?? 1) { result in
            switch result{
            case .success(let newTitles):
                self.titles.append(contentsOf: newTitles)
                DispatchQueue.main.async {
                    [weak self] in self?.upcommingTableView.reloadData()
                    self?.isLoadingMore = false
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.isLoadingMore = false
            }
        }
    }

}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        
        cell.configure(with: TitleViewModel(titleName: (title.title ?? title.original_title) ?? "Unknow" , posterUrl: title.poster_path  ?? title.backdrop_path ?? "", description: title.overview ))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        if position > (contentHeight - scrollViewHeight - 100) && !isLoadingMore {
            // Load more content
            currentPage += 1
            fetchDiscoverMovie(page: currentPage)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate  {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count > 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultController.delegate = self
         
        APICaller.shared.search(with:query, page: 1) { result in
            switch result{
            case .success(let newTitles):
                resultController.titles = newTitles
                DispatchQueue.main.async {
                    resultController.searchResultCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.name else {return}
        APICaller.shared.getYoutubeData(with: titleName + " trailer") { result in
                    switch result {
                    case .success(let videoData):
                        guard let videoId = videoData.items.first?.id else { return }
                        let viewModel = TitlePreviewModel(title: title.original_title ?? title.name ?? "Unknown", youtubeView: videoId, titleOverView: title.overview)
                        DispatchQueue.main.async { [weak self] in
                            let vc = TitlePreviewViewController()
                            vc.configure(with: viewModel)
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewModel) {
           
           DispatchQueue.main.async { [weak self] in
               let vc = TitlePreviewViewController()
               vc.configure(with: viewModel)
               self?.navigationController?.pushViewController(vc, animated: true)
           }
       }
    
}
