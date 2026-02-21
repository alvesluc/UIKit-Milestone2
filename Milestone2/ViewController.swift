//
//  ViewController.swift
//  Milestone2
//
//  Created by Macedo on 20/02/26.
//

import UIKit

class ViewController: UITableViewController {
    private var shoppingList: [String] = [
        "Bittersweet Chocolate",
        "White Chocolate",
        "Nutella",
        "Condensed Milk",
        "Strawberries"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .systemBackground
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Item")
        
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        let clearAction = UIAction { [weak self] _ in
            self?.presentClearListAlert()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Clear", primaryAction: clearAction
        )
        
        let addAction = UIAction { [weak self] _ in
            self?.presentAddItemAlert()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: addAction
        )
    }
    
    func presentClearListAlert() {
        let ac = UIAlertController(
            title: "Clear list",
            message: "Are you sure that you want to clear your shopping list?",
            preferredStyle: .actionSheet
        )
        
        let clearListAction = UIAlertAction(
            title: "Yes, clear list",
            style: .destructive
        ) { [weak self] _ in
            self?.shoppingList.removeAll()
            self?.tableView.reloadData()
        }
        
        ac.addAction(clearListAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func presentAddItemAlert() {
        let ac = UIAlertController(
            title: "Add item",
            message: nil,
            preferredStyle: .alert
        )
        
        ac.addTextField { textField in
            textField.placeholder = "Enter item name"
        }
        
        let addItemAction = UIAlertAction(
            title: "Create item",
            style: .default
        ) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            
            self?.addItem(text)
        }
        
        ac.addAction(addItemAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func addItem(_ text: String) {
        let newIndex = shoppingList.count
        shoppingList.append(text)
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return shoppingList.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = shoppingList[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
