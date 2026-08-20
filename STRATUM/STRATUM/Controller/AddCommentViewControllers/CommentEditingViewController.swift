//
//  CommentEditingViewController.swift


import Foundation
import UIKit


class CommentEditingViewController: UIViewController {
   
    var editingTest = ""
    var idtrad2: String!

    @IBOutlet weak var commentTextView: UITextView!
    @IBAction func okButton(_ sender: Any) {
        if  let textRange = commentTextView.selectedTextRange {
            let selectedText = commentTextView.text(in: textRange)
            
  if (selectedText != ""){
  let lc4 = storyboard?.instantiateViewController(withIdentifier: "AddingCommentViewController") as! AddingCommentViewController
                lc4.idtrad3 = idtrad2
                lc4.editedText = selectedText!
                self.navigationController?.pushViewController(lc4, animated: true)
            } else {
                let alert = UIAlertController(title: "Warning", message: "You must selected text", preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                           self.present(alert, animated: true, completion: nil)            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.text = editingTest        
    }
}
