//
//  DetailViewController.swift
//  JhTabProject
//
//  Created by Jh's MacbookPro on 2019/12/20.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
    
    // MARK: share
    @IBAction func share(_ sender: Any) {
        
        guard let memo = memo?.content else{return}
        
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: delete
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "delete", message: "本当にこのメモを削除しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive){[weak self] (action) in
            DataManager.shared.deleteMemo(self?.memo)
            self?.navigationController?.popViewController(animated: true)
            
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.edittarget = memo
        }
    }
    
    var token : NSObjectProtocol?
    
    deinit{
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    var memo : Memo?

    override func viewDidLoad() {
        super.viewDidLoad()

        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChanged, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in self?.memoTableView.reloadData()})
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

    extension DetailViewController: UITableViewDataSource{
        
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              // #warning Incomplete implementation, return the number of rows
              return 2
          }

          
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.row {
            case 0:
                 let cell = tableView.dequeueReusableCell(withIdentifier: "memoDetailCell", for: indexPath)
                 
                 cell.textLabel?.text = memo?.content
                 
                return cell
                
            case 1:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
                cell.textLabel?.text = formatter.string(for: memo?.insertDate)
                return cell
            default:
                fatalError()
            }
             
          }
        
    

}
