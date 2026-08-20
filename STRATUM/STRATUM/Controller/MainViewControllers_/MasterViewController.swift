//
//  MasterViewController.swift


import Foundation
import UIKit
import CloudKit


class MasterViewController: UIViewController, UISearchBarDelegate, UICloudSharingControllerDelegate, UINavigationControllerDelegate {

    let searchController = UISearchController(searchResultsController: nil)
 
    var textTitleMaster = ""
    var textDetailMaster = ""
    var secondTextMaster = ""
    var idtrad : String!
  
    @IBAction func shareButton(_ sender: Any) {
        let zone = CKRecordZone(zoneName: "customZONE")
        let zoneIDent = zone.zoneID
        var rec = CKRecord.ID(recordName: idtrad, zoneID: zoneIDent)
        var record = CKRecord(recordType: "Traduction", recordID: rec)
        let share = CKShare(rootRecord: record)
        
        share[CKShare.SystemFieldKey.title] = "Sharing \(String(describing: idtrad))" as CKRecordValue?
        share[CKShare.SystemFieldKey.shareType] = "iCloud.Huygens.COPERATIO" as CKRecordValue
        prepareToShare(share: share, rootrecord: record )
      
    }
    @IBOutlet var buttonShare: UIBarButtonItem!
    @IBOutlet var buttonSearchComment: UIBarButtonItem!
    @IBAction func searchComment(_ sender: UIBarButtonItem) {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.isTranslucent = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationItem.rightBarButtonItems = nil
        navigationController?.delegate = self

        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootVC, self]
        }
        
 
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         searchController.isActive = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = buttonShare
//        commentViewController.reloadComment()
         }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
////        commentViewController.reloadComment()
//    }
//
  
    
    // MARK: - SegmentedControl Setup
    
    private func setupView() {
//        commentViewController.commentTableView.reloadData()
        setupSegmentedControl()
        updateView()
    }
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Text", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Comments", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)

        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    func updateView() {
                  if segmentedControl.selectedSegmentIndex == 0 {
                      self.navigationItem.rightBarButtonItem = buttonShare
                      add(asChildViewController: detailViewController)
                      remove(asChildViewController: commentViewController)
                  } else {
                     self.navigationItem.rightBarButtonItem = buttonSearchComment
                      remove(asChildViewController: detailViewController)
                      add(asChildViewController: commentViewController)
                  }
           
     }
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    
    lazy var detailViewController: DetailViewController = {
    
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        viewController.id1 = idtrad
        viewController.detailTlt = textTitleMaster
        viewController.detailTag = textDetailMaster
        viewController.detailText = secondTextMaster
        viewController.getCommentOfTraduction()
        self.add(asChildViewController: viewController)
        return viewController
    }()
    private lazy var commentViewController: CommentViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        viewController.detailTlt2 = textTitleMaster
        viewController.detailTag2 = textDetailMaster
        viewController.detailTxt2 = secondTextMaster
        viewController.getCommentOfTraduction()
        viewController.comID = idtrad
        viewController.tableID = idtrad
        self.add(asChildViewController: viewController)
        return viewController
        
       }()
    
    private func add(asChildViewController viewController: UIViewController) {

           addChild(viewController)
           let vc = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        vc.takeStringToColor()
            vc.id1 = idtrad
            view.addSubview(viewController.view)
            viewController.view.frame = view.bounds
            viewController.didMove(toParent: self)
    }
    private func remove(asChildViewController viewController: UIViewController) {
              
                 viewController.willMove(toParent: nil)
                 viewController.view.removeFromSuperview()
                 viewController.removeFromParent()
    }


    // MARK: - Search Bar functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if (searchText.count>0) {
                commentViewController.isFilteringComm = true
                commentViewController.filterArrayComm = commentViewController.commentArr.filter {
                    $0.comment?.text.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
        } else {
                    commentViewController.isFilteringComm = false
                    commentViewController.filterArrayComm = commentViewController.commentArr
                }
        commentViewController.commentTableView.reloadData()
        }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        commentViewController.isFilteringComm = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            commentViewController.isFilteringComm = false
        commentViewController.commentTableView.reloadData()
    }
    
    
    // MARK: - CloudSharing functions
    
    private func prepareToShare(share: CKShare, rootrecord: CKRecord){

           let sharingViewController = UICloudSharingController(preparationHandler: {(UICloudSharingController, handler: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
              
               let modRecordsList = CKModifyRecordsOperation(recordsToSave: [rootrecord, share], recordIDsToDelete: nil)
               modRecordsList.perRecordCompletionBlock = { (record, error) in
                   if let error = error {
                        print("CloudKit errorRR: \(error.localizedDescription)")
                      }
               }
      
                      modRecordsList.modifyRecordsCompletionBlock = {
                          (record, recordID, error) in
                       handler(share, CKContainer.default(), error)

                      }

           CKContainer.default().privateCloudDatabase.add(modRecordsList)
                  })
           
           sharingViewController.delegate = self
           sharingViewController.availablePermissions = [.allowReadWrite, .allowPrivate]
                  self.navigationController?.present(sharingViewController, animated:true, completion:nil)
       
       }

    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("saved successfully")
    }
     
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failed to save: \(error)")
    }
     
    func itemThumbnailData(for csc: UICloudSharingController) -> Data? {
        return nil //You can set a hero image in your share sheet. Nil uses the default.
    }
     
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return self.idtrad
    }
    
    }



//         var rec = CKRecord.ID(recordName: idtrad)
//          let container = CKContainer.default()
       
//         var ourRecord = CKRecord(recordType: "Traduction", zoneID: zone.zoneID)
//          let privateDatabase = container.privateCloudDatabase
//
//        ourRecord.setObject(idtrad as CKRecordValue, forKey: "email")
//
//        privateDatabase.save(ourRecord, completionHandler: { (record, error) -> Void in
//          if let error = error {
////              completion?(false, error)
//          }else {
////              completion?(true, nil)
//          }
//        })

