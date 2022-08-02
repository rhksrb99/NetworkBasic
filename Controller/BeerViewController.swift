//
//  BeerViewController.swift
//  NetworkBasic
//
//  Created by 박관규 on 2022/08/02.
//

import UIKit

import Alamofire
import SwiftyJSON

class BeerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var beerTableView: UITableView!
    
    var list:[Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerTableView.delegate = self
        beerTableView.dataSource = self
        beerTableView.register(UINib(nibName: BeerTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: BeerTableViewCell.reuseIdentifier)
        
        configureView()
        requestBeer()
    }
    
    func requestBeer() {
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                      
                for beer in json.arrayValue {
                    var name = beer["name"].stringValue
                    var image_url = URL(string:beer["image_url"].stringValue)
                    var description = beer["description"].stringValue
                    let data = Beer(name: name, description: description, image_url: image_url!)
                    self.list.append(data)
                }
                
                print(self.list)
                
                self.beerTableView.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureView() {
        beerTableView.backgroundColor = .clear
        beerTableView.separatorColor = .clear
        beerTableView.rowHeight = 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.reuseIdentifier, for: indexPath) as? BeerTableViewCell else { return UITableViewCell() }
        
        cell.lb_beer[0].text = "\(list[indexPath.row].name)"
        cell.lb_beer[1].text = "\(list[indexPath.row].description)"
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: self.list[indexPath.row].image_url)
            DispatchQueue.main.async {
                cell.img_beer.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
}
