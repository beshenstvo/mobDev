//
//  ViewController.swift
//  lesson2
//
//  Created by Rufus on 06.10.2021.
//

import UIKit
//struct searchDecode: Codable{
//    var result: fullInfoSearch?
//}
//struct fullInfoSearch: Codable{
//    var wrapperType: String;
//    var trackViewUrl: String;
//    var kind: String;
//    var artistName: String;
//    var trackName: String;
//    var artworkUrl30: String;
//}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    struct ResultCount: Codable {
        let resultCount: Int?
        let results: [Results]
    }
    struct Results: Codable{
        let wrapperType: String?
        let kind: String?
        let artistName: String?
        let trackName: String?
        let trackViewUrl: String?
        let artworkUrl100: String?
    }
    var fullData = [ResultCount]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        searchBar.delegate = self
//        JSONDownload {
//            print("Удачно")
//        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        JSONDownload( searchBar.text!)
    }
    
    func JSONDownload(_ searchBarText: String){
        print(searchBarText)
        let newString = searchBarText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let jsonUrlString = "https://itunes.apple.com/search?term=\(newString)"
        guard let url = URL(string: jsonUrlString) else { return }

        URLSession.shared.dataTask(with: url) {(data, response, err) in
            guard let data = data else { return }
            do {
                let show = try JSONDecoder().decode(ResultCount.self, from: data)
                self.fullData.append(show)
                print(show)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }

        }.resume()
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fullData.first?.results.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = fullData[0].results[indexPath.row].trackName
        content.secondaryText = fullData[0].results[indexPath.row].artistName
        let url = URL(string: fullData[0].results[indexPath.row].artworkUrl100!)
            if let data = try? Data(contentsOf: url!)
            {
                content.image = UIImage(data: data)
            }
        content.imageProperties.cornerRadius = tableView.rowHeight / 2
        cell.contentConfiguration = content
        return cell
    }
}




