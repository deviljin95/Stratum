//
//  DetailViewController.swift
//

import Foundation
import UIKit
import CloudKit

public class DetailViewController: UIViewController {

    let globalColor = UIColor(red: 77/255, green: 80/255, blue: 97/255, alpha: 1.0)

    var detailTlt = ""
    var detailTag = ""
    var detailText = ""
    var id1 : String!

    var commArray1 = [Commento]()
    let dao = TestoDAO()

    var string_to_color = [String]()

    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailTagLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!

    @IBAction func addComment(_ sender: Any) {
        let lc3 = storyboard?.instantiateViewController(withIdentifier: "CommentEditingViewController") as! CommentEditingViewController
        lc3.editingTest = detailText
        lc3.idtrad2 = id1
        self.navigationController?.pushViewController(lc3, animated: true)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        detailTitleLabel.text = detailTlt
        detailTagLabel.text = detailTag
        detailTextView.text = detailText

        detailTitleLabel.textColor = .white
        detailTagLabel.textColor = .systemGray4
        if !(detailTagLabel.text?.hasPrefix("#") ?? true) {
            detailTagLabel.text?.insert("#", at: detailTagLabel.text!.startIndex)
        }

        detailTextView.layer.cornerRadius = 15
        detailTextView.backgroundColor = .white
        detailTextView.font = UIFont(name: "AlNile", size: 25)
        self.view.backgroundColor = globalColor
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCommentOfTraduction()
    }

    // MARK: - Highlight CommentText
    func takeStringToColor() {
        string_to_color.removeAll()
        for commento in commArray1 {
            string_to_color.append(commento.testoSelezionato)
        }
    }

    func colorText() {
        takeStringToColor()
        let attribute = NSMutableAttributedString.init(string: detailText)

        for stringa in string_to_color {
            // Nota: questo evidenzia solo la prima occorrenza
            let range = (detailText as NSString).range(of: stringa)
            if range.location != NSNotFound {
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
            }
        }
        detailTextView.attributedText = attribute
        detailTextView.font = UIFont(name: "AlNile", size: 25)
    }

    // MARK: - Get Trad/Comm
    func getCommentOfTraduction() {
        // Chiamata pulita tramite DAO
        dao.recuperaCommenti(per: id1) { [weak self] (commenti, error) in
            DispatchQueue.main.async {
                if let commenti = commenti {
                    self?.commArray1 = commenti
                    self?.colorText()
                }
            }
        }
    }
}