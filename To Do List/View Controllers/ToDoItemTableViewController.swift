//
//  ToDoItemTableViewController.swift
//  To Do List
//
//  Created by Konstantin Ryabtsev on 18.02.2022.
//

import UIKit

class ToDoItemTableViewController: UITableViewController {
    // MARK: - Properties
    var todo = ToDo()
    var datePickers = [IndexPath: Bool]()
}

// MARK: - UITableViewDataSource
extension ToDoItemTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let value = todo.values[indexPath.section]
        if value is Date && indexPath.row == 1 {
            return datePickers[indexPath] ?? true ? 0 : UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        todo.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = todo.values[section]
        return value is Date ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let value = todo.values[section]
        let cell = getCellFor(indexPath: indexPath, with: value)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = todo.capitalizedKeys[section]
        return key
    }
    
}

// MARK: - UITableViewDelegate
extension ToDoItemTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = todo.values[indexPath.section]
        
        if value is Date {
            let indexPathDatePicker = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if let cell = tableView.cellForRow(at: indexPathDatePicker) as? DatePickerCell {
                cell.datePicker.isHidden.toggle()
                datePickers[indexPathDatePicker] = cell.datePicker.isHidden
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // TODO: Implement sow/hide date picker
            
        } else if value is UIImage {
            let alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancel)
            
            let imagePicker = SectionImagePickerController()
            imagePicker.delegate = self
            imagePicker.section = indexPath.section
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true)
                }
                alert.addAction(cameraAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true)
                }
                alert.addAction(photoLibraryAction)
            }
            
            present(alert, animated: true)
        }
    }
}

// MARK: - Cell Configurator
extension ToDoItemTableViewController {
    func getCellFor(indexPath: IndexPath, with value: Any?) -> UITableViewCell {
        
        if let stringValue = value as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.textField.text = stringValue
            cell.textField.section = indexPath.section
            return cell
            
        } else if let dateValue = value as? Date {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                cell.setDate(dateValue)
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! DatePickerCell
                cell.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
                cell.datePicker.date = dateValue
                cell.datePicker.minimumDate = Date()
                cell.datePicker.preferredDatePickerStyle = .wheels
                cell.datePicker.section = indexPath.section
                datePickers[indexPath] = cell.datePicker.isHidden
                return cell
                
            default:
                fatalError("Please add more prototype cells for Date section")
            }
            
        } else if let boolValue = value as? Bool {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.switch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.switch.isOn = boolValue
            cell.switch.section = indexPath.section
            return cell
            
        } else if let imageValue = value as? UIImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.largeImageView.image = imageValue
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.textField.text = ""
            cell.textField.section = indexPath.section
            return cell
            
        }
    }
}

// MARK: - Action
extension ToDoItemTableViewController {
    @objc func datePickerValueChanged(_ sender: SectionDatePicker) {
        let section = sender.section!
        let key = todo.keys[section]
        let date = sender.date
        todo.setValue(date, forKey: key)
        let labelIndexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [labelIndexPath], with: .automatic)
    }
    
    @objc func switchValueChanged(_ sender: SectionSwitch) {
        let key = todo.keys[sender.section!]
        let value = sender.isOn
        todo.setValue(value, forKey: key)
    }
    
    @objc func textFieldValueChanged(_ sender: SectionTextField) {
        let key = todo.keys[sender.section!]
        let text = sender.text ?? ""
        todo.setValue(text, forKey: key)
    }
}

extension ToDoItemTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let sectionPicker = picker as? SectionImagePickerController else { return }
        guard let section = sectionPicker.section else { return }
        let key  = todo.keys[section]
        todo.setValue(image, forKey: key)
        let indexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension ToDoItemTableViewController: UINavigationControllerDelegate {}
