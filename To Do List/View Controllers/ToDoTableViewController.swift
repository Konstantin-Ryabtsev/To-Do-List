//
//  ToDoTableViewController.swift
//  To Do List
//
//  Created by Konstantin Ryabtsev on 18.02.2022.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    // MARK: - Properties
    var todos = [ToDo]()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        todos = [
            ToDo(title: "Купить хлеб", notes: "Батон", image: UIImage(named: "bread")),
            ToDo(title: "Записать ребенка в школу", image: UIImage(named: "school")),
            ToDo(title: "Подготовить питч", image: UIImage(named: "pitch")),
            ToDo(title: "Test wo image", isComplete: true, image: UIImage())
        ]
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Cell Content
    func configure(_ cell: ToDoCell, with todo: ToDo) {
        guard let stackView = cell.stackView else { return }
        guard stackView.arrangedSubviews.count == 0 else { return }
        
        for index in 0 ..< todo.keys.count {
            let key = todo.capitalizedKeys[index]
            let value = todo.values[index]
            
            if let stringValue = value as? String {
                let label = UILabel()
                label.text = "\(key): \(stringValue)"
                stackView.addArrangedSubview(label)
                
            } else if let dateValue = value as? Date {
                let label = UILabel()
                label.text = "\(key): \(dateValue.formatedShortDate)"
                stackView.addArrangedSubview(label)
                
            } else if let boolValue = value as? Bool {
                let label = UILabel()
                label.text = "\(key): \(boolValue ? "🟢" : "⚪️")"
                stackView.addArrangedSubview(label)
                
            } else if let imageValue = value as? UIImage, imageValue.size.width != 0 {
                let imageView = UIImageView(image: imageValue)
                imageView.contentMode = .scaleAspectFit
                let heightConstraint = NSLayoutConstraint(
                    item: imageView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .height,
                    multiplier: 1,
                    constant: 200)
                imageView.addConstraint(heightConstraint)
                stackView.addArrangedSubview(imageView)
                
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AddItemSegue":
            let destination = segue.destination as! ToDoItemTableViewController
            destination.todo = ToDo(image: UIImage())
            print(#line, #function, todos)
            
        case "EditItemSegue":
            guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
            let destination = segue.destination as! ToDoItemTableViewController
            destination.todo = todos[selectedIndex.row].copy() as! ToDo
            print(#line, #function, todos)
        
        case .none:
            break
        
        case .some(_):
            break
        }
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveSegue" else { return }
        
        let source = segue.source as! ToDoItemTableViewController
        let todo = source.todo
        
        if let selectedIndex = tableView.indexPathForSelectedRow {
            todos[selectedIndex.row] = todo
            tableView.reloadRows(at: [selectedIndex], with: .automatic)
        } else {
            let indexPath = IndexPath(row: todos.count, section: 0)
            todos.append(todo)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        /*
        if let toDoCell = tableView.cellForRow(at: selectedIndex) as? ToDoCell {
            if let stackView = toDoCell.stackView {
                stackView.arrangedSubviews.forEach { subview in
                    stackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            }
        }
        */
        print(#line, #function, todos)
    }
    
}

// MARK: - UITableViewDataSource
extension ToDoTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        let todo = todos[indexPath.row]
        configure(cell, with: todo)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(#line, #function)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .none:
            break
        case .delete:
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(#line, #function, todos)
        case .insert:
            break
        @unknown default:
            print(#line, #function, "Unknown case in file \(#file)")
            break
        }
    }
}

// MARK: - UITableViewDelegate
extension ToDoTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
