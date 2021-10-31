//
//  ViewController.swift
//  lesson4
//
//  Created by Rufus on 25.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var imageName: [ImageName] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func saveLabel(newLabel: String){
        let label =  ImageName(context: self.container.viewContext)
        label.label = newLabel
        if self.container.viewContext.hasChanges {
            do {
                try self.container.viewContext.save()
                print("Имя картинки занесено в БД")
            } catch {
                print("Error: ", error)
            }
        }
        imageName.insert(label, at: 0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! DetailTableViewCell
        
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                let image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(imageName[indexPath.row].label!).path)
                cell.ImageView.image = image
            }
        cell.labelView.text = imageName[indexPath.row].label
        
        return cell
    }
    
    @IBAction func PlusButton(_ sender: Any) {
        guard let url = URL(string: "https://source.unsplash.com/random/110x110") else { return }
        
        DispatchQueue.global().async { [self] in
            guard let data = try? Data(contentsOf: url) else { return }
            
            var DocumentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
            let uuid = UUID().uuidString
            DocumentDirectoryPath?.appendPathComponent(uuid)
            
            try? data.write(to: DocumentDirectoryPath!)
            print(DocumentDirectoryPath!)
            saveLabel(newLabel: uuid)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
        let delegate = UIApplication.shared.delegate as? AppDelegate
        container = delegate?.persistentContainer
        guard container != nil else {
            fatalError("View needs a persistent container")
        }
        let labelFetch: NSFetchRequest<ImageName> = ImageName.fetchRequest()
        imageName = try! container.viewContext.fetch(labelFetch)
        print(imageName.count)
    }
}



