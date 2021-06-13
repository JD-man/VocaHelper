//
//  SearchViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class SearchViewController: UIViewController {
    
//    private var vocaDatas: [VocaData] = []
//    private var files: [URL] = []
//    
//    // 어디의 단어장에서 왔는지 저장하는 Array
//    private var vocaDataIdx: [Int] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadvocaDatas()
//        view.backgroundColor = .systemBackground
//        navigationItem.title = "Search"
//        searchControllerconfigure()
//        
//        //print(vocaDatas)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }
//    
//    private func loadvocaDatas() {
//        let fileManager = FileManager.default
//        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return
//        }
//        
//        let decoder = JSONDecoder()
//        
//        do {
//            files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//            for file in files {
//                let data = try Data(contentsOf: file)
//                let vocaData = try decoder.decode(VocaData.self, from: data)
//                vocaDatas.append(vocaData)
//            }
//        } catch {
//            print(error)
//        }
//        
//    }
//    
//    private func searchControllerconfigure() {
//        // result table 설정
//        let searchResultsVC = SearchResultsTableViewController()
//        searchResultsVC.tableView.delegate = self
//        
//        
//        // search controller 설정
//        let searchController = UISearchController(searchResultsController: searchResultsVC)
//        searchController.searchResultsUpdater = self
//        searchController.automaticallyShowsCancelButton = false
//        searchController.searchBar.autocapitalizationType = .none
//        searchController.searchBar.autocorrectionType = .no
//        searchController.searchBar.placeholder = "Search Words..."
//        self.navigationItem.searchController = searchController
//    }
//}
//
//
//// datasource는 SearchResultsTableViewController에서 직접관리함
//// 여기서는 검색결과를 클릭했을때 단어장으로 넘어가도록 delegate만 다룸.
//extension SearchViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        let editVC = EditViewController()
//        editVC.voca = self.vocaDatas[vocaDataIdx[indexPath.row]]
//        editVC.fileName = files[vocaDataIdx[indexPath.row]].lastPathComponent
//        //print(files[vocaDataIdx[indexPath.row]])
//        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.pushViewController(editVC, animated: true)
//    }
//}
//
//extension SearchViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchResultsVC = searchController.searchResultsController as? SearchResultsTableViewController else {
//            return
//        }
//        guard let searchText = searchController.searchBar.text else {
//            return
//        }
//        
//        searchResultsVC.searchResults = []
//        vocaDataIdx = []
//        
//        for (i,vocaData) in vocaDatas.enumerated() {
//            for voca in vocaData.vocas {
//                guard let word = voca.value.keys.first else {
//                    return
//                }
//                if word.contains(searchText) {
//                    searchResultsVC.searchResults.append(word)
//                    searchResultsVC.searchResults.sort()
//                    vocaDataIdx.append(i)
//                    searchResultsVC.tableView.reloadData()
//                }
//            }
//        }
//    }
}

