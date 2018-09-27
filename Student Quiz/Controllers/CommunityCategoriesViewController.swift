//
//  CommunityCategoriesViewController.swift
//  Studiz
//
//  Created by Gabriel Raymondou on 27/09/2018.
//  Copyright © 2018 Gabriel Raymondou. All rights reserved.
//

import UIKit

class CommunityCategoriesViewController: UIViewController {
    
    let cellId: String = "categoryCell"
    
    var selectedCategory: Category = .Misc
    var categoryArray: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView layout
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = UIColor(red:0.21, green:0.31, blue:0.42, alpha:1.0)
        
        getAllCategories()
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAllCategories() {
        categoryArray = []
        for category in Category.allCases {
            categoryArray.append(Helpers.convertCategory(category))
        }
    }
    
    //MARK: Segue Handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategoryQuiz" {
            let communityList = segue.destination as! CommunityListViewController

            communityList.displayedTitle = "Category"

            getCommunityData { (quizList) in
                communityList.quizArray = quizList.sorted { $0.rating > $1.rating }
            }
        }
    }
    
    func getCommunityData(completion: @escaping (([quizCellData]) -> ())) {
        QuizService.getCommunityQuiz { (quizArray) in
            var quizList: [quizCellData] = []
            
            for fetchedQuiz in quizArray {
                if let quiz = fetchedQuiz {
                    if quiz.0.category == self.selectedCategory {
                        quizList.append(Helpers.createCommunityData(from: quiz, consideringDate: true))
                    }
                }
            }
            
            completion(quizList)
        }
    }

}

// MARK: - Extenstion for TableView
extension CommunityCategoriesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommunityCategoryTableViewCell
        
        // cell layout
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.categoryNameLabel.text = categoryArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = QuizService.convertCategory(categoryArray[indexPath.row])
        performSegue(withIdentifier: "goToCategoryQuiz", sender: self)
    }

}
