import UIKit

final class ScreenForSaveSubjectViewController: UIViewController,
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    UITextFieldDelegate {
    // MARK: - Constants
    // MARK: - Private
    private let typesSubjects: [String] = ["No type subject", "Lecture", "Practice", "Lab", "Other"]
    private let date = Date()

    // Label
    private let pageTitle = UILabel()
    private let dashLabel = UILabel()

    // Buttons
    private let dismissButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)

    // Text Fields
    private let subjectNameField = CustomScheduleUITextField(
        placeholderText: "Subject name",
        autocapitalizationType: .words,
        keyboardType: .default
    )
    private let buildingNumberField = CustomScheduleUITextField(
        placeholderText: "Building number",
        autocapitalizationType: .allCharacters,
        keyboardType: .numberPad
    )
    private let audienceNumberField = CustomScheduleUITextField(
        placeholderText: "Audience number",
        autocapitalizationType: .allCharacters,
        keyboardType: .numberPad
    )
    private let teacherNameField = CustomScheduleUITextField(
        placeholderText: "Teacher name",
        autocapitalizationType: .words,
        keyboardType: .default
    )

    // Pickers
    private let typeSubjectPicker: UIPickerView = UIPickerView()
    private var subjectStartTimePicker = UIDatePicker()
    private let subjectEndTimePicker = UIDatePicker()

    // Stack Views
    private let navigationStackView = UIStackView()
    private let mainStackView = UIStackView()
    private let textFieldsStackView = UIStackView()
    private let clocksStackView = UIStackView()
    private let segmentedControlsStackView = UIStackView()

    // Segmented Control
    private let typesOfWeeksSegmentedControl = UISegmentedControl()
    private let daysOfWeekSegmentedControl = UISegmentedControl()

    // MARK: - Properties
    private var selectedTypeSubject: String = " "
    private var type: ScheduleWeekType?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationStackView()
        setupDismissButton()
        setupPageTitle()
        setupSaveButton()
        setupMainStackView()
        setupTextFieldsStackView()
        setupTypeSubjectPicker()
        setupClocksStackView()
        setupSubjectStartTimePicker()
        setupDashLabel()
        setupSubjectEndTimePicker()
        setupSegmentedControlsStackView()
        setupTypesOfWeekSegmentedControl()
        setupDaysOfWeekSegmentedControl()
    }

    // MARK: - Setups
    // MARK: View
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
        view.addSubview(navigationStackView)
        view.addSubview(mainStackView)
    }

    // MARK: NavigationStackView
    private func setupNavigationStackView() {
        navigationStackView.axis = .horizontal
        navigationStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: mainStackView.topAnchor,
            padding: .init(top: 12, left: 0, bottom: 8, right: 0)
        )
        navigationStackView.heightAnchor.constraint(
            equalTo: mainStackView.heightAnchor,
            multiplier: 0.1
        ).isActive = true
        navigationStackView.addArrangedSubview(dismissButton)
        navigationStackView.addArrangedSubview(pageTitle)
        navigationStackView.addArrangedSubview(saveButton)
        navigationStackView.alignment = .center
        navigationStackView.distribution = .fillEqually
        navigationStackView.spacing = 28
    }

    private func setupDismissButton() {
        dismissButton.setTitle("Back", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
    }

    private func setupPageTitle() {
        pageTitle.text = "New subject"
        pageTitle.textAlignment = .center
        pageTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    private func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonDidTapped), for: .touchUpInside)
    }

    // MARK: MainStackView
    private func setupMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.anchor(
            top: navigationStackView.bottomAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            padding: .init(top: 8, left: 12, bottom: 8, right: 12)
        )
        mainStackView.addArrangedSubview(textFieldsStackView)
        mainStackView.addArrangedSubview(typeSubjectPicker)
        mainStackView.addArrangedSubview(clocksStackView)
        mainStackView.addArrangedSubview(segmentedControlsStackView)
    }

    private func setupTextFieldsStackView() {
        textFieldsStackView.axis = .vertical
        textFieldsStackView.anchor(
            top: mainStackView.topAnchor,
            leading: mainStackView.leadingAnchor,
            trailing: mainStackView.trailingAnchor,
            bottom: typeSubjectPicker.topAnchor
        )
        textFieldsStackView.heightAnchor.constraint(
            equalTo: mainStackView.heightAnchor,
            multiplier: 0.4
        ).isActive = true
        textFieldsStackView.addArrangedSubview(subjectNameField)
        textFieldsStackView.addArrangedSubview(buildingNumberField)
        textFieldsStackView.addArrangedSubview(audienceNumberField)
        textFieldsStackView.addArrangedSubview(teacherNameField)
        textFieldsStackView.alignment = .fill
        textFieldsStackView.distribution = .fillEqually
        textFieldsStackView.spacing = 8
        subjectNameField.delegate = self
        buildingNumberField.delegate = self
        audienceNumberField.delegate = self
        teacherNameField.delegate = self
    }

    private func setupTypeSubjectPicker() {
        typeSubjectPicker.tag = 0
        typeSubjectPicker.delegate = self
        typeSubjectPicker.dataSource = self
        typeSubjectPicker.anchor(
            top: textFieldsStackView.bottomAnchor,
            leading: mainStackView.leadingAnchor,
            trailing: mainStackView.trailingAnchor,
            bottom: clocksStackView.topAnchor
        )
        typeSubjectPicker.heightAnchor.constraint(
            equalTo: mainStackView.heightAnchor,
            multiplier: 0.3
        ).isActive = true
    }

    private func setupClocksStackView() {
        clocksStackView.axis = .horizontal
        clocksStackView.anchor(
            top: typeSubjectPicker.bottomAnchor,
            leading: mainStackView.leadingAnchor,
            trailing: mainStackView.trailingAnchor,
            bottom: segmentedControlsStackView.topAnchor
        )
        clocksStackView.heightAnchor.constraint(
            equalTo: mainStackView.heightAnchor,
            multiplier: 0.1
        ).isActive = true
        clocksStackView.addArrangedSubview(subjectStartTimePicker)
        clocksStackView.addArrangedSubview(dashLabel)
        clocksStackView.addArrangedSubview(subjectEndTimePicker)
        clocksStackView.alignment = .fill
        clocksStackView.distribution = .equalCentering
        clocksStackView.spacing = 6
    }

    private func setupSubjectStartTimePicker() {
        subjectStartTimePicker.preferredDatePickerStyle = .inline
        subjectStartTimePicker.datePickerMode = .time
    }

    private func setupDashLabel() {
        dashLabel.text = "\u{2E3A}"
        dashLabel.textAlignment = .center
    }

    private func setupSubjectEndTimePicker() {
        subjectEndTimePicker.preferredDatePickerStyle = .inline
        subjectEndTimePicker.datePickerMode = .time
    }

    private func setupSegmentedControlsStackView() {
        segmentedControlsStackView.axis = .vertical
        segmentedControlsStackView.anchor(
            top: clocksStackView.bottomAnchor,
            leading: mainStackView.leadingAnchor,
            trailing: mainStackView.trailingAnchor,
            bottom: mainStackView.bottomAnchor
        )
        segmentedControlsStackView.heightAnchor.constraint(
            equalTo: mainStackView.heightAnchor,
            multiplier: 0.15
        ).isActive = true
        segmentedControlsStackView.addArrangedSubview(typesOfWeeksSegmentedControl)
        segmentedControlsStackView.addArrangedSubview(daysOfWeekSegmentedControl)
        segmentedControlsStackView.alignment = .fill
        segmentedControlsStackView.distribution = .fillEqually
        segmentedControlsStackView.spacing = 4
    }

    private func setupTypesOfWeekSegmentedControl() {
        typesOfWeeksSegmentedControl.addItems(items: [
            "Upper week",
            "Bottom week"
        ])
    }

    private func setupDaysOfWeekSegmentedControl() {
        daysOfWeekSegmentedControl.addItems(items: [
            "Mon.",
            "Tues.",
            "Wed.",
            "Thurs.",
            "Fri.",
            "Sat."
        ])
    }

    // MARK: - Helpers
    private func switchToNextTextField(_ textField: UITextField) {
        switch textField {
        case subjectNameField: buildingNumberField.becomeFirstResponder()
        case buildingNumberField: audienceNumberField.becomeFirstResponder()
        case audienceNumberField: teacherNameField.becomeFirstResponder()
        case teacherNameField: typeSubjectPicker.becomeFirstResponder()
        default: subjectNameField.resignFirstResponder()
        }
    }

    private func handleTypesSubjectsLogic(row: Int) {
        if typeSubjectPicker.selectedRow(inComponent: 0) != 0 {
            selectedTypeSubject = typesSubjects[row]
        } else {
            selectedTypeSubject = " "
        }
    }

    private func handleScheduleWeekTypeLogic() {
        let weekType = typesOfWeeksSegmentedControl.selectedSegmentIndex
        let day = daysOfWeekSegmentedControl.selectedSegmentIndex

        if weekType == 0 {
            switch day {
            case 0:type = .upper(.monday)
            case 1:type = .upper(.tuesday)
            case 2:type = .upper(.wednesday)
            case 3:type = .upper(.thursday)
            case 4:type = .upper(.friday)
            case 5:type = .upper(.saturday)
            default:print("choosed upper week type")
            }
        } else if weekType == 1 {
            switch day {
            case 0:type = .bottom(.monday)
            case 1:type = .bottom(.tuesday)
            case 2:type = .bottom(.wednesday)
            case 3:type = .bottom(.thursday)
            case 4:type = .bottom(.friday)
            case 5:type = .bottom(.saturday)
            default:print("choosed bottom week type")
            }
        }
    }

    private func showAlertWithDismissing(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func makeSaveSubject() {
        let subjectName = subjectNameField.text ?? "Subject not defined"
        if !subjectName.isEmpty {
            handleScheduleWeekTypeLogic()
            let saveNameSubject = subjectNameField.text ?? " "
            let saveBuildingNumber = buildingNumberField.text ?? "no build."
            let saveAudienceNumber = audienceNumberField.text ?? "no aud."
            let saveTeacherName = teacherNameField.text ?? " "
            let selectedTypeSubject = selectedTypeSubject
            let selectedStartTime = subjectStartTimePicker.date
            let selectedEndTime = subjectEndTimePicker.date

            let schedule = Schedule.init(
                nameSubject: saveNameSubject,
                typeSubject: selectedTypeSubject,
                subjectStartTime: selectedStartTime,
                subjectEndTime: selectedEndTime,
                buildingNumber: saveBuildingNumber,
                audienceNumber: saveAudienceNumber,
                teacherName: saveTeacherName,
                scheduleDateType: type ?? .upper(.monday)
            )
            UserManager.instance.saveScheduleToUserDefaults(schedule: schedule)
            showAlertWithDismissing(title: "New subject added", message: "")
        } else {
            showAlert(title: "Attention", message: "Make sure you have entered subject name")
        }
    }

    // MARK: - Picker view data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesSubjects.count
    }
    // MARK: Picker view delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let typeSubject = typesSubjects[row]
        return typeSubject
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        handleTypesSubjectsLogic(row: row)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToNextTextField(textField)
        return true
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc func dismissButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonDidTapped() {
        makeSaveSubject()
    }

    // MARK: - Touch responders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Deinit
    deinit {
        print("ScreenForSaveScheduleViewController is deleted")
    }
}
