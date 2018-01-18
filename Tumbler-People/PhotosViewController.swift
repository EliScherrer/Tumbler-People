//
//  PhotosViewController.swift
//  Tumbler-People
//
//  Created by Eli Scherrer on 1/13/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var photoTableView: UITableView!
    
    var posts: [[String: Any]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        requestTumblerData()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ photoTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ photoTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photoTableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as! PhotoTableViewCell
        
        let post = posts[indexPath.row]
        
        // photos is not nil, use it
        if let photos = post["photos"] as? [[String: Any]] {
            
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            
            let url = URL(string: urlString)
            cell.photoView.af_setImage(withURL: url!)
        }
        
        return cell
    }
    

    func requestTumblerData() {
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Get the response dictionary from the returned JSON
                let responseDictionary = dataDictionary!["response"] as! [String: Any]
                // get posts from the response dictionary
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                // Reload the table view
                self.photoTableView.reloadData()
                
            }
        }
        task.resume()
    }

}
