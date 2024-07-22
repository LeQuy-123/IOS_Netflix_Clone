//
//  DownloadsViewController.swift
//  Netflix clone
//
//  Created by mac on 13/7/24.
//

import UIKit

class DownloadsViewController: UIViewController {
    private var titles: [TitleItem] = [TitleItem]()

    private let downloadTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        // Do any additional setup after loading the view.
        
        view.addSubview(downloadTableView)
        
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        fetchDownloadedMovie()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            print("notification")
                    self.fetchDownloadedMovie()
        }
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTableView.frame = view.bounds
        
    }
    
    private func fetchDownloadedMovie() {
        DataPersistenceManager.shared.getTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titleItems):
               
                self?.titles = titleItems
                DispatchQueue.main.async { self?.downloadTableView.reloadData() }
            case .failure(let error):
                print(error)
            }
        }
    }

}
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        
        cell.configure(with: TitleViewModel(titleName: (title.name ?? title.original_title) ?? "Unknow" , posterUrl: title.poster_path  ?? title.backdrop_path ?? "", description: title.overview ?? "" ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
                case .delete:
                    
                    DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                        switch result {
                        case .success():
                            print("deleted")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        self?.titles.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                default:
                    break;
                }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.name else {return}
        APICaller.shared.getYoutubeData(with: titleName + " trailer") { result in
                    switch result {
                    case .success(let videoData):
                        guard let videoId = videoData.items.first?.id else { return }
                        let viewModel = TitlePreviewModel(title: title.original_title ?? title.name ?? "Unknown", youtubeView: videoId, titleOverView: title.overview ?? "")
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
    
   
}
 
