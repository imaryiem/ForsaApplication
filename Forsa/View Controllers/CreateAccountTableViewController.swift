import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CreateAccountTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //link the ui with the code file

    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var AddProfilePhotoBtn: UIButton!
    
    @IBOutlet weak var NameTextField: UITextField!
    
    @IBOutlet weak var GenderTextField: UITextField!
    
    @IBOutlet weak var DOBTextField: UITextField!
    
    @IBOutlet weak var CountryTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var ContactNumTextField: UITextField!
    
    @IBOutlet weak var JobTitleTextField: UITextField!
    
    @IBOutlet weak var EducationTextField: UITextField!
    
    @IBOutlet weak var ExperienceTextField: UITextField!
    
    @IBOutlet weak var JobTypeTextField: UITextField!
    
    @IBOutlet weak var SkillsTextField: UITextField!
    
    @IBOutlet weak var PreferredIndustriesTextField: UITextField!
    
    @IBOutlet weak var CareerInterestsTextField: UITextField!
    
    private let datePicker = UIDatePicker()
    
    @IBAction func AddProfilePhotoBtnTapped(_ sender: Any) {
        showPhotoAlert()
    }
    
    @IBAction func SaveBtn(_ sender: Any) {
        // Validate fields
        if let validationError = validateFields() {
            showAlert(message: validationError)
            return
        }

        // Create data variables
        let fullname = NameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let gender = GenderTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let dob = DOBTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let country = CountryTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let contactNum = ContactNumTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let jobTitle = JobTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let education = EducationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let experience = ExperienceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let jobType = JobTypeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let skills = SkillsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let preferredIndustries = PreferredIndustriesTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let careerInterests = CareerInterestsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        // Create user in Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showAlert(message: "Error creating user: \(error.localizedDescription)")
                return
            }

            guard let userID = result?.user.uid else {
                self.showAlert(message: "Error retrieving user ID.")
                return
            }

            // Save user data in Firestore
            let db = Firestore.firestore()
            db.collection("users").document(userID).setData([
                "FullName": fullname,
                "Gender": gender,
                "DOB": dob,
                "Country": country,
                "Email": email,
                "Password": password,
                "ContactNum": contactNum,
                "JobTitle": jobTitle,
                "Education": education,
                "ExperienceLevel": experience,
                "JobType": jobType,
                "Skills": skills,
                "PreferredIndustries": preferredIndustries,
                "CareerInterests": careerInterests,
                "Role": "job_seeker", // Default role
                "uid": userID
            ]) { error in
                if let error = error {
                    self.showAlert(message: "Error saving user data: \(error.localizedDescription)")
                    return
                }

                // Transition to login page
                self.transitionToLogin()
            }
        }
    }

    
    //go to login screen after creating account
    func transitionToLogin(){
        
       let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    // Validate method with alerts
    func validateFields() -> String? {
        // Check that all text fields are filled in
        if NameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            GenderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            DOBTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            CountryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ContactNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            JobTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EducationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ExperienceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            JobTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            SkillsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PreferredIndustriesTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            CareerInterestsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(message: "Please fill in all fields.")
            return "Missing fields"
        }

        // Check password length
        if let password = PasswordTextField.text, password.count < 8 {
            showAlert(message: "Password must be at least 8 characters long.")
            return "Password too short"
        }

        // Check that a profile photo is selected
        if ProfileImage.image == nil {
            showAlert(message: "Please add a profile photo.")
            return "No profile photo selected"
        }

        // If all validations pass
        showAlert(message: "All fields are valid. Proceeding...")
        return nil
    }
    
    
    // Helper method to show alerts
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //password text hidden
        PasswordTextField?.isSecureTextEntry = true
        configureDatePicker()
    }

    // Configure Date Picker for DOB
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        DOBTextField.inputView = datePicker

        // Add a toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissDatePicker))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        DOBTextField.inputAccessoryView = toolbar
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        DOBTextField.text = formatter.string(from: sender.date)
    }

    @objc private func dismissDatePicker() {
        view.endEditing(true)
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
        
        // Fix for iPad or potential crash
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = AddProfilePhotoBtn
            popoverController.sourceRect = AddProfilePhotoBtn.bounds
            popoverController.permittedArrowDirections = .up
        }

       
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
            ProfileImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
