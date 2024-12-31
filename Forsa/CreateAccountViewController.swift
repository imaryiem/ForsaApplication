import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var GenderTextField: UITextField!
    @IBOutlet weak var DOBTextField: UITextField!
    @IBOutlet weak var CountryTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ContactNumTextField: UITextField!
    @IBOutlet weak var JobTitleTextField: UITextField!
    @IBOutlet weak var EducationTextField: UITextField!
    @IBOutlet weak var ExperienceLevelTextField: UITextField!
    @IBOutlet weak var JobTypeTextField: UITextField!
    @IBOutlet weak var SkillsTextField: UITextView!
    @IBOutlet weak var PreferredIndustriesTextField: UITextView!
    @IBOutlet weak var CareerInterestsTextField: UITextView!
    @IBOutlet weak var ProfilePhoto: UIImageView!

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Password text hidden
        PasswordTextField?.isSecureTextEntry = true
    }

    @IBAction func SaveButtonTapped(_ sender: UIButton) {
        //validate fields
       
    }
    
    
    // Reusable alert function
    func alert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?() // Execute completion handler if provided
        }))
        present(alert, animated: true, completion: nil)
    }
    

    
    
    
    
    // Show success alert
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Your account has been successfully created.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func AddProfilePhotoBtn(_ sender: Any) {
        showPhotoAlert()
    }

    // Show photo selection alert
    func showPhotoAlert() {
        let alert = UIAlertController(title: "Take Photo From:", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.getPhoto(from: .camera)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                self.getPhoto(from: .photoLibrary)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Get photo from camera or library
    func getPhoto(from sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            ProfilePhoto.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

