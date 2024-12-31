import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class EditProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Firebase Firestore reference
    let db = Firestore.firestore()

    // Link the UI with the code
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserData()
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


    // Set up UI elements
    func setupUI() {
        PasswordTextField.isSecureTextEntry = true // Hide password for security
        PasswordTextField.isUserInteractionEnabled = false // Make password field uneditable
        EmailTextField.isUserInteractionEnabled = false // Make email field uneditable
     
    }

    // Fetch user data from Firestore
    func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No logged-in user.")
            return
        }

        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    // Populate text fields with user data
                    self.NameTextField.text = data["FullName"] as? String
                    self.GenderTextField.text = data["Gender"] as? String
                    self.DOBTextField.text = data["DOB"] as? String
                    self.CountryTextField.text = data["Country"] as? String
                    self.EmailTextField.text = data["Email"] as? String
                    self.ContactNumTextField.text = data["ContactNum"] as? String
                    self.JobTitleTextField.text = data["JobTitle"] as? String
                    self.EducationTextField.text = data["Education"] as? String
                    self.ExperienceTextField.text = data["ExperienceLevel"] as? String
                    self.JobTypeTextField.text = data["JobType"] as? String
                    self.SkillsTextField.text = data["Skills"] as? String
                    self.PreferredIndustriesTextField.text = data["PreferredIndustries"] as? String
                    self.CareerInterestsTextField.text = data["CareerInterests"] as? String

                    // Populate password field for display only (optional for security)
                    self.PasswordTextField.text = data["Password"] as? String
                }
            } else {
                print("No user document found.")
            }
        }
    }

    // Save edited data back to Firestore
    @IBAction func SaveBtn(_ sender: Any) {
        guard validateFields() else {
            showAlert(title: "Error", message: "All fields except password must be filled.")
            return
        }

        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No logged-in user.")
            return
        }

        var updatedData: [String: Any] = [
            "FullName": NameTextField.text ?? "",
            "Gender": GenderTextField.text ?? "",
            "DOB": DOBTextField.text ?? "",
            "Country": CountryTextField.text ?? "",
            "Email": EmailTextField.text ?? "",
            "ContactNum": ContactNumTextField.text ?? "",
            "JobTitle": JobTitleTextField.text ?? "",
            "Education": EducationTextField.text ?? "",
            "ExperienceLevel": ExperienceTextField.text ?? "",
            "JobType": JobTypeTextField.text ?? "",
            "Skills": SkillsTextField.text ?? "",
            "PreferredIndustries": PreferredIndustriesTextField.text ?? "",
            "CareerInterests": CareerInterestsTextField.text ?? ""
        ]

        // Only update the password if it's not empty
        if let password = PasswordTextField.text, !password.isEmpty {
            updatedData["Password"] = password
        }

        db.collection("users").document(userID).setData(updatedData, merge: true) { error in
            if let error = error {
                print("Error saving data: \(error.localizedDescription)")
            } else {
                print("Data updated successfully!")
                self.showSaveConfirmation()
            }
        }
    }

    // Validate fields
    func validateFields() -> Bool {
        let fields = [
            NameTextField, GenderTextField, DOBTextField, CountryTextField,
            EmailTextField, ContactNumTextField, JobTitleTextField,
            EducationTextField, ExperienceTextField, JobTypeTextField,
            SkillsTextField, PreferredIndustriesTextField, CareerInterestsTextField
        ]
        return fields.allSatisfy { !($0?.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) }
    }

    // Show confirmation after saving
    func showSaveConfirmation() {
        let alert = UIAlertController(title: "Success", message: "Profile updated successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            NotificationCenter.default.post(name: NSNotification.Name("ProfileUpdated"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    // Image picker methods
    @IBAction func AddProfilePhotoBtnTapped(_ sender: Any) {
        showPhotoAlert()
    }

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

    func getPhoto(from sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            ProfileImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // Show alerts
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
