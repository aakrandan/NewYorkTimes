//
//  ViewController.swift
//  NewYorkTimes
//
//  Created by Ananth Kamath on 09/06/22.
//

import UIKit

class NewYorkTimesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var newsArticleArr: [Results] = []
    var newsArticlaImageArr: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        
        self.navigationItem.title = "The New York Times"
        
        self.tableView.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        
        self.activity.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor, constant: 0).isActive = true
        self.activity.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        
        self.activity.startAnimating()
        tableView.isUserInteractionEnabled = false
        self.activity.hidesWhenStopped = true
        
        RestAPIHelper.shared.getNewArticleDataFromURL(url: "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=4l3b0h7CtvGG4LELYVfzjfvcKKbaAKB5") { responseData in
           
            self.newsArticleArr = responseData.results
            
            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.tableView.isUserInteractionEnabled = true
                
                self.tableView.reloadData()
            }
        }
        
        registerTableViewCell()
    }
    
    
    // MARK: Other Functions
    
    func registerTableViewCell() {
        let newsArticleTableViewCell = UINib(nibName: "NewsArticleTableViewCell", bundle: nil)
        tableView.register(newsArticleTableViewCell, forCellReuseIdentifier: "NewsArticleTableViewCell")
    }
    
    func prettifyDateFormat(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let prettyDate = formatter.date(from: dateString) ?? Date()
        formatter.dateFormat = "MMM dd, yyy"

        let prettyDateString = formatter.string(from: prettyDate)
        return prettyDateString
    }
    
    // MARK: Scroll view delegate methods
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
            
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension NewYorkTimesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArticleArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)

        let articleDetailsVC = ArticleDetailsViewController(nibName: "ArticleDetailsViewController", bundle: nil)
        articleDetailsVC.urlString = self.newsArticleArr[indexPath.row].url
        self.navigationController?.pushViewController(articleDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsArticleTableViewCell") as? NewsArticleTableViewCell {
            
            cell.titleLabel.text = self.newsArticleArr[indexPath.row].title
            cell.abstractLabel.text = self.newsArticleArr[indexPath.row].abstract
            cell.authorLabel.text = self.newsArticleArr[indexPath.row].byline
            cell.dateLabel.text = self.prettifyDateFormat(dateString: self.newsArticleArr[indexPath.row].pubDate)
            
            let media: [MetaData] = self.newsArticleArr[indexPath.row].media
            
            if media.count > 0 {
                let mediaMetaData: [ImageName] = media[0].mediaMetaData
                
                if mediaMetaData.count > 0 {
                    let url = mediaMetaData[0].url
                    
                    RestAPIHelper.shared.imageFromServerURL(urlString: url) { image in
                        cell.thumbnailImageView.image = image
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}

