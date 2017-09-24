//
//  ViewController.swift
//  DocTalk
//
//  Created by saikrishna on 22/09/17.
//  Copyright © 2017 apnacomplex. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UINavigationControllerDelegate {
    var items:[String]=[]
    var filitems:[String]=[]
    @IBOutlet weak var Searchbar: UISearchBar!
      @IBOutlet weak var tabview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Searchbar.delegate=self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func parseJson(_ dt:Data)->AnyObject?
    {
        do{
            let json=try JSONSerialization.jsonObject(with: dt, options: JSONSerialization.ReadingOptions(rawValue: 0))
            
            return json as AnyObject?
            
        }
        catch{
            print("Json object not created")
        }
        return nil
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let url=URL(string:"https://api.github.com/search/users?q=\(searchText)&sort=followers")
        var request = URLRequest(url:url!)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github.v3.text-match+json", forHTTPHeaderField: "Accept")
        // request.httpBody = queryString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            
            do{
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                print(result)
                self.filitems.removeAll()
                let its=result!["items"]as?NSArray
                for i in 0..<its!.count
                {
                    let itm=its![i]as?NSDictionary
                    
                    self.filitems.append(itm!["login"]as!String)
                }
                DispatchQueue.main.async{
                    self.items = self.filitems.filter({( x ) in
                        return x.contains(searchText.lowercased())
                    })
                self.tabview.reloadData()
                }
                
            } catch {
                print("Error -> \(error)")
                
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring)
            }
        })
        task.resume()
        //self.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "customcell",for: indexPath)as!CustCell
        
        DispatchQueue.main.async {
            cell.Label.text=self.items[indexPath.row]
        }
     
        cell.selectionStyle = .none
        cell.separatorInset=UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
           return items.count
        
    }
   
}

