//
//  ViewController.swift
//  lesson4
//
//  Created by Rufus on 25.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let downloadQueue = DispatchQueue(label: "lesson4-downloadQueue")
    let imageLoadingQueue = DispatchQueue(label: "lesson4-imageLoadingQueue")
    
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
                imageLoadingQueue.async { // файлы с диска стоит грузить в бэкграунд очереде
                    let image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(self.imageName[indexPath.row].label!).path)
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                    
                }

            }
        cell.labelView.text = imageName[indexPath.row].label
        
        return cell
    }
    
    @IBAction func PlusButton(_ sender: Any) {
        guard let url = URL(string: "https://source.unsplash.com/random/110x110") else { return }
        
        downloadQueue.async { [self] in // лучше создавать отдельные очереди и обращаться к ним, а не каждый раз создавать новую очередь через  global
            guard let data = try? Data(contentsOf: url) else { return }
            
            var documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
            let uuid = UUID().uuidString
            documentDirectoryPath?.appendPathComponent(uuid)
            
            try? data.write(to: documentDirectoryPath!)
            print(documentDirectoryPath!)
            DispatchQueue.main.async { // сохранять в Core Data нужно обязательно с того потока в котором был создан контекст, в данном случае на главном потоке
                self.saveLabel(newLabel: uuid)
            }
            
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



