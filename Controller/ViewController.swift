//
//  ViewController.swift
//  NetworkBasic
//
//  Created by 박관규 on 2022/08/01.
//

import UIKit

import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var img_beer: UIImageView!
    @IBOutlet weak var lb_beerName: UILabel!
    @IBOutlet weak var tv_beerDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomBeerImageLoad()
        showBeer()
    }
    
    func randomBeerImageLoad() {
        let imgClicked = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        img_beer.isUserInteractionEnabled = true
        img_beer.addGestureRecognizer(imgClicked)
    }
    
    @objc func imageClicked() {
        showBeer()
    }
    
    func showBeer() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("json : \(json)")
                
//                print("name : \(json[0]["name"].stringValue)")
//                print("description : \(json[0]["description"].stringValue)")
                self.lb_beerName.text = json[0]["name"].stringValue
                self.tv_beerDescription.text = json[0]["description"].stringValue
                let img_url = URL(string:json[0]["image_url"].stringValue)
//                print("imageURL : \(json[0]["image_url"].stringValue)")
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: img_url!)
                    DispatchQueue.main.async {
                        self.img_beer.image = UIImage(data: data!)
                    }
                }
            
                
                
            case .failure(let error):
                print("error : \(error)")
            }
        }
    }
}
