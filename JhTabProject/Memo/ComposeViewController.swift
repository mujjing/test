//
//  ComposeViewController.swift
//  JhTabProject
//
//  Created by Jh's MacbookPro on 2019/12/19.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var edittarget: Memo?
    var originalMemoContent: String?
    
    @IBOutlet var memoTextView: UITextView!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text,
            memo.count > 0 else {
                alert(message: "メモを入力してください")
                return
        }
        
        if let target = edittarget {
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChanged, object: nil)
        }else {
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
//        let newMemo = Memo(content: memo ?? "")
//        Memo.dummyMemoList.append(newMemo)
       
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let memo = edittarget{
            navigationItem.title = "edit"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        }else{
            navigationItem.title = "new Memo"
            memoTextView.text = ""
        }
        
        memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentationController?.delegate = nil
    }

}

extension ComposeViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text{
            if #available(iOS 13.0, *){
                isModalInPresentation = original != edited
            }else{
                
            }
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "confirm", message: "編集したメモを保存しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default){
            [weak self] (action) in self?.save(action)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            [weak self] (action) in
            self?.close(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
extension ComposeViewController{
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChanged = Notification.Name(rawValue: "memoDidChanged")
}
