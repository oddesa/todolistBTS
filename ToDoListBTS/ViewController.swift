//
//  ViewController.swift
//  ToDoListBTS
//
//  Created by Jehnsen Hirena Kane on 07/01/22.
//


import UIKit

class ViewController: UIViewController, UITableViewDataSource {
   
    var checklistItem = [ChecklistModel]()
    let baseURL = "http://94.74.86.174:8080/api"
    let token = "eyJhbGciOiJIUzUxMiJ9.eyJyb2xlcyI6W119.i2OVQdxr08dmIqwP7cWOJk5Ye4fySFUqofl-w6FKbm4EwXTStfm0u-sGhDvDVUqNG8Cc7STtUJlawVAP057Jlg"
    
    @IBOutlet weak var tableViewOtl: UITableView!
    
    @IBAction func tambahPressed(_ sender: Any) {
        var textField = UITextField()
        let titleText = "Item checklist baru"
        let messageText = "Silahkan tambahkan item checklist baru!"
        let alert = UIAlertController(title: titleText , message: messageText , preferredStyle: .alert)
        let action = UIAlertAction(title: "Tambahkan", style: .default) { [self] (_) in
            if let itemBaru = textField.text {
                if itemBaru != "" {
                    print("ini item baru \(itemBaru) -----------")
                    print ("masuk disini")
                    addNewChecklist(name: itemBaru) { checklist in
                        print(checklist.checklistName)
//                        fetchChecklist { itemsBaru in
//                            checklistItem = itemsBaru
//                            DispatchQueue.main.async {
//                                self.tableViewOtl.reloadData()
//                            }
//                        } failCompletion: { error in
//                            print(error)
//                        }

                    } failCompletion: { Error in
                        print(Error)
                    }

                }
                
            }
            
        }
        let action1 = UIAlertAction(title: "Kembali", style: .destructive) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Isi batas atas crypto disini"
            textField = alertTextField
        }

        alert.addAction(action1)
        alert.addAction(action)
        

        present(alert, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOtl.dataSource = self
        fetchChecklist { lists in
            self.checklistItem = lists
            DispatchQueue.main.async {
                self.tableViewOtl.reloadData()
            }
        } failCompletion: { error in
            print(error)
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if checklistItem.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checklistCell", for: indexPath)
            cell.textLabel?.text = checklistItem[indexPath.row].checklistName
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checklistCell", for: indexPath)
            cell.textLabel?.text = "checklist item masih kosong"
            return cell
        }
        
    }
    
    

}

extension ViewController {
    func fetchChecklist(successCompletion: @escaping ([ChecklistModel]) -> Void, failCompletion: @escaping (String) -> Void) {
        let urlString = "\(baseURL)/checklist"
        BaseRequest.getChecklist(url: urlString, header: token) { response in
            var dataModel = DataManager.checklist

            do {
                let json = try JSONSerialization.jsonObject(with: (response as? Data)!, options: .mutableContainers) as! [String: AnyObject]
                print(json)
                for item in json["data"] as! NSArray{
                    dataModel.append(ChecklistModel(checklistName: (item as! String)))
                }
                successCompletion(dataModel)
            } catch let error {
                failCompletion(error.localizedDescription)
            }
        }
    }
    
    func addNewChecklist(name: String,
                         successCompletion: @escaping (ChecklistModel) -> Void,
                         failCompletion: @escaping (String) -> Void) {
        let urlString = "\(baseURL)/checklist"
        BaseRequest.POST(url: urlString, header: token, name: name) { response in
            
            print("berhasil post data")
            print(response)
            successCompletion(ChecklistModel(checklistName: name))
        } failCompletion: { error in
            print(error)
        }

        
    }
    
}
