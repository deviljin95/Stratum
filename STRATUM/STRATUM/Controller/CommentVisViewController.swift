//
//  CommentVisViewController.swift


import UIKit

class CommentVisViewController: UIViewController {
      
   var questionText = ""
   var selectedTxt = ""
   var userTxt = ""

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var selectedText: UITextView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
         questionTextView.text = questionText
         selectedText.text = selectedTxt
     
     }
}
