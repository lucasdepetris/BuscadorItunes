//
//  ViewController.swift
//  BuscadorItunes
//
//  Created by mac on 12/7/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var tableViewResults: UITableView!
    @IBOutlet weak var resultsHeight: NSLayoutConstraint!
    @IBOutlet weak var heigthItunesLabel: NSLayoutConstraint!
    @IBOutlet weak var searchItunesLabel: UILabel!
    
    var resultsItunes = [[String:Any]]()
    var mediaType:String? = "music"
    //Create Activity Indicator
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBAction func segmentedChangeValue(_ sender: Any) {
        switch mySegmentControl.selectedSegmentIndex {
        case 0:
            mediaType = "music"
            break;
        case 1:
            mediaType = "tvShow"
            break;
        case 2:
            mediaType = "movie"
            break;
        default:
            break;
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableViewResults.delegate = self
        self.tableViewResults.dataSource = self
        tableViewResults.estimatedRowHeight = 131
        tableViewResults.rowHeight = UITableViewAutomaticDimension
        self.mySearchBar.delegate = self
        self.mySearchBar.placeholder = "Search..."
        
        self.tableViewResults.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //self.view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        self.resultsHeight.constant = tableViewResults.contentSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Custom Methods
    @objc func dismissKeyboard(){
        self.mySearchBar.endEditing(true)
    }
    
    func showAlertError(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    //Pragma Mark TableView Delegates Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsItunes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = tableViewResults.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        if(self.resultsItunes.count > 0){
            self.heigthItunesLabel.constant = 0
            switch mediaType {
                case "music":
                    cell.artistName.text = resultsItunes[indexPath.row]["artistName"] as? String
                    cell.trackName.text = resultsItunes[indexPath.row]["trackName"] as? String
                    cell.longDescription.text = ""
                    break;
                case "movie":
                    cell.artistName.text = ""
                    cell.trackName.text = resultsItunes[indexPath.row]["trackName"] as? String
                    cell.longDescription.text = resultsItunes[indexPath.row]["longDescription"] as? String
                    break;
                case "tvShow":
                    cell.artistName.text = resultsItunes[indexPath.row]["artistName"] as? String
                    cell.trackName.text = resultsItunes[indexPath.row]["trackName"] as? String
                    cell.longDescription.text = resultsItunes[indexPath.row]["longDescription"] as? String
                    break;
                default:
                    break;
            }
            
            
            let url = URL(string: (resultsItunes[indexPath.row]["artworkUrl100"] as? String)!)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    guard let dataImage = data else{
                        cell.imgTvShow.image = UIImage(imageLiteralResourceName: "imgNotFound")
                        return
                    }
                    cell.imgTvShow.image = UIImage(data: dataImage)
                }
            }
        }else{
            self.heigthItunesLabel.constant = 39
            self.searchItunesLabel.text = "Lo sentimos, No se han encontrado resultados."
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cellSelected")
        if(mediaType == "movie" || mediaType == "tvShow"){
            let videoURL = URL(string: (resultsItunes[indexPath.row]["previewUrl"] as? String)!)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }else{
            
            /*let playerItem = AVPlayerItem(url: URL(string: "https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/Music6/v4/13/22/67/1322678b-e40d-fb4d-8d9b-3268fe03b000/mzaf_8818596367816221008.plus.aac.p.m4a")!)
            let player = AVPlayer(playerItem: playerItem)
            player.play()*/
           
            let videoURL = URL(string: (resultsItunes[indexPath.row]["previewUrl"] as? String)!)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect")
    }
    //Pragma Mark SearchBar Delegates Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search Clicked! \(String(describing: mediaType)) ")
        self.mySearchBar.endEditing(true)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        myActivityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(myActivityIndicator)
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "itunes.apple.com";
        urlComponents.path = "/search";
        
        // add params
        let dateQuery = NSURLQueryItem(name: "media", value: mediaType)
        let conceptQuery = NSURLQueryItem(name: "term", value: searchBar.text)
        urlComponents.queryItems = [dateQuery, conceptQuery] as [URLQueryItem]
        
        self.resultsItunes = [[String:Any]]()
        
        guard let url = urlComponents.url else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    self.showAlertError(message: "Response Error")
                    DispatchQueue.main.async {
                        self.myActivityIndicator.stopAnimating()
                    }
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
                print(jsonResponse)
                
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                
                //Now get results property
                guard let results = jsonArray["results"] as? [[String:Any]] else { return }
         
                self.resultsItunes = results
                
                DispatchQueue.main.async {
                    self.tableViewResults.reloadData()
                    self.viewDidLayoutSubviews()
                    self.myActivityIndicator.stopAnimating()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
                self.showAlertError(message: "Error Parsing")
                DispatchQueue.main.async {
                    self.myActivityIndicator.stopAnimating()
                }
            }
        }
        task.resume()
    }
}

