import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    enum Section { case main }
    private var dataSource: UITableViewDiffableDataSource<Section, String>!
    
    private var shoppingList: [String] = [
        "Bittersweet Chocolate",
        "White Chocolate",
        "Nutella",
        "Condensed Milk",
        "Strawberries"
    ]
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        configureNavigationBar()
        configureDataSource()
        updateUI(animated: false)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Item")
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: tableView
        ) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
            
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier
            content.textProperties.font = .preferredFont(forTextStyle: .body)
            
            cell.contentConfiguration = content
            
            return cell
        }
    }

    private func updateUI(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shoppingList, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func configureNavigationBar() {
        let clearAction = UIAction { [weak self] _ in
            self?.presentClearListAlert()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Clear",
            primaryAction: clearAction
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
        let ac = UIAlertController(title: "Clear list", message: "Are you sure?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Yes, clear list", style: .destructive) { [weak self] _ in
            self?.shoppingList.removeAll()
            self?.updateUI()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }

    func presentAddItemAlert() {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        ac.addTextField { $0.placeholder = "Enter item name" }
        ac.addAction(UIAlertAction(title: "Create item", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text, !text.isEmpty else { return }
            self?.addItem(text)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }

    func addItem(_ text: String) {
        shoppingList.append(text)
        updateUI()
    }
}
