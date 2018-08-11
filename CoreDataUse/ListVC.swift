//
//  ListVC.swift
//  CoreDataUse
//
//  Created by NoDack on 11/08/2018.
//  Copyright © 2018 zuzero. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UITableViewController {
    
    // 네비게이션 바의 오른쪽 바 버튼 아이템을 클릭하면 호출될 메소드 (Selector Method)
    @objc func add(_ sender: Any) {
        // 타이틀 과 내용을 입력받을 수 있는 대화상자를 생성
        let alert: UIAlertController = UIAlertController(title: "제목", message: "제목을 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { $0.placeholder = "제목" })
        alert.addTextField(configurationHandler: { $0.placeholder = "내용" })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: { (_) in
            
            guard let title = alert.textFields?[0].text else {
                return
            }
            
            guard let content = alert.textFields?[1].text else {
                return
            }
            
            
            if self.save(title: title, content: content) {
                self.tableView.reloadData()
            }
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    // MARK: CoreData Logic
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()
    
    lazy var viewContext = { () -> NSManagedObjectContext in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
    
    
    // title 과 contents 를 매개변수로 받아서 저장하는 메소드
    func save(title: String, content: String) -> Bool {
        
        let context = self.viewContext
        
        let board = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        
        board.setValue(title, forKey: "title")
        board.setValue(content, forKey: "content")
        board.setValue(Date(), forKey: "regdate")
        
        try! context.save()
        
        self.list.insert(board, at: 0)
        
        return true
    }
    
    
    
    func fetch() -> [NSManagedObject] {
//        // AppDelegate 가져오기
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        // DAO 역할의 ViewContext
//        let context = appDelegate.persistentContainer.viewContext
//        // 데이터 가져올때 필요한 Query

        let context = self.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")
        // 데이터 가져오기
        let result: [NSManagedObject] = try! context.fetch(fetchRequest)
        
        return result
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        
        self.title = "게시판"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    /**
     테이블 뷰의 섹션 개수를 설정하는 메소드
     이 메소드는 선택적으로 구현하면됩니다.
     구현하지 않으면 1을 return 합니다.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /**
     테이블 뷰 필수 메소드
     섹션 별 행의 개수를 설정하는 메소드
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 리스트에서 행 번호에 해당하는 데이터 가져오기
        let record: NSManagedObject = self.list[indexPath.row]
        
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "content") as? String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = contents

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
