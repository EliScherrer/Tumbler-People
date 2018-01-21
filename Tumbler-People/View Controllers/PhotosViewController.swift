//
//  PhotosViewController.swift
//  Tumbler-People
//
//  Created by Eli Scherrer on 1/13/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var photoTableView: UITableView!
    
    var posts: [[String: Any]] = []
    var isMoreDataLoading = false
    var photoCountOffset = 20
    

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
    
    //how many rows in each section
    func tableView(_ photoTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in photoTableView: UITableView) -> Int {
        return posts.count
    }
    
    //return what cell at the index path
    func tableView(_ photoTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photoTableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as! PhotoTableViewCell
        
        let post = posts[indexPath.section]
        
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
    
    //configure each section header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 3.5, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        let post = posts[section]
        
        // photos is not nil, use it
        if let dateText = post["date"] as? String {
            
            let date = UILabel(frame: CGRect(x: 45, y: 10, width: 300, height: 21))
            date.text = dateText
            
            headerView.addSubview(date)

        }
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        // let label = ...
        
        return headerView
    }
    
    //configure the height of each section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    //Get rid of the gray selection effect by deselecting the cell with animation
    func tableView(_ photoTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        photoTableView.deselectRow(at: indexPath, animated: false)
    }
    
    //handle the user scrolling down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = photoTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - photoTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && photoTableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                addTumblerData()
            }
        }
    }
    
    //adding data to the table after the user scrolls down a lot
    func addTumblerData() {
        
        let basePath = "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let offset = "&offset=\(photoCountOffset)"
        let full: String = basePath + offset
        let url = URL(string: full)!
        
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
//                let mergingDict = responseDictionary["posts"] as! [[String: Any]]
                self.posts += responseDictionary["posts"] as! [[String: Any]]
                

                
                // Reload the table view
                self.photoTableView.reloadData()
                self.isMoreDataLoading = false
                self.photoCountOffset += 20
                
            }
        }
        task.resume()
        
    }
    
    

    //get the photo data from tumbler
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
    
    //send data in transition to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = photoTableView.indexPath(for: cell ) {
            let post = posts[indexPath.section]
            let detailViewController = segue.destination as! PhotoDetailsViewController
            
            
            if let photos = post["photos"] as? [[String: Any]] {
                
                let photo = photos[0]
                let originalSize = photo["original_size"] as! [String: Any]
                let urlString = originalSize["url"] as! String
                
                let url = URL(string: urlString)
                
                detailViewController.photoURL = url!

            }
        }
    }

}
