//
//  chooseViewController.swift



import UIKit
import Vision
import VisionKit

protocol CameraViewDelegate {
    func passCameraText(cameraText: String)
}


class ChooseViewController: UIViewController, CameraViewDelegate {
    
    
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
     var scannedText1 = ""
     var cameraDelegate: CameraViewDelegate?
    
    func passCameraText(cameraText: String) {
        self.cameraDelegate?.passCameraText(cameraText: cameraText)
        let lc = storyboard?.instantiateViewController(identifier: "AddTraductionViewController") as! AddTraductionViewController
        lc.scannedText = cameraText
        self.navigationController?.pushViewController(lc, animated: true)
    }
    
    
    @IBAction func scanBtn(_ sender: Any) {
        
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
   
          configureOCR()
      }
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch {
            print(error)
        }
    }
    
    
    private func configureOCR() {
               ocrRequest = VNRecognizeTextRequest { (request, error) in
                   guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                   
                   var ocrText = ""
                   for observation in observations {
                       guard let topCandidate = observation.topCandidates(1).first else { return }
                       
                       ocrText += topCandidate.string + "\n"
                   }
                   
                   
                   DispatchQueue.main.async {
    
                       self.scannedText1 = ocrText

                   }
               }
               
               ocrRequest.recognitionLevel = .accurate

               ocrRequest.usesLanguageCorrection = true
           }
    
    
    

}


extension ChooseViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            
            
            return
        }
        
        processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true, completion: {
            self.passCameraText(cameraText: self.scannedText1)
        })
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        //Handle properly error
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
}




