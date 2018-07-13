//
//  ViewController.swift
//  BuscadorItunes
//
//  Created by mac on 12/7/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var tableViewResults: UITableView!
    @IBOutlet weak var resultsHeight: NSLayoutConstraint!
    
    var resultsItunes = [[String:Any]]()
    var mediaType:String = "music"
    
    @IBAction func segmentedChangeValue(_ sender: Any) {
        switch mySegmentControl.selectedSegmentIndex {
        case 0:
            mediaType = "music"
            break;
        case 1:
            mediaType = "tvshow"
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
        //self.tableViewResults.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        self.tableViewResults.register(UINib(nibName: "TvShowTableViewCell", bundle: nil), forCellReuseIdentifier: "tvShowCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
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
    
    //Pragma Mark TableView Delegates Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsItunes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TvShowTableViewCell = tableViewResults.dequeueReusableCell(withIdentifier: "tvShowCell") as! TvShowTableViewCell
        
        cell.artistName.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
        return cell
        
    }
    
    //Pragma Mark SearchBar Delegates Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search Clicked! \(String(describing: mediaType)) ")
        self.mySearchBar.endEditing(true)
        
        guard let url = URL(string: "https://itunes.apple.com/search?media=movie&term=jack+johnson") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
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
                print(jsonArray)
                //Now get title value
                guard let results = jsonArray["results"] as? [[String:Any]] else { return }
                print("RESULTS")
                print(results[0]["trackId"]) // delectus aut autem
                
                self.resultsItunes = results
                print(self.resultsItunes)
                
                DispatchQueue.main.async {
                    self.tableViewResults.reloadData()
                    self.viewDidLayoutSubviews()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}

