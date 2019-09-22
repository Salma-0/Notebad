//
//  ViewController.swift
//  Notebad
//
//  Created by Salma on 14/09/2019.
//  Copyright © 2019 Salma. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedNote : Note?
    
    @IBOutlet weak var NoteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let content = selectedNote?.content?.string
                if content != nil {
                    NoteTextView?.attributedText = selectedNote?.content
                }
        NoteTextView.allowsEditingTextAttributes = true

    }
    



    @IBAction func saveButtonPressed(_ sender: Any) {
        let text = NoteTextView.attributedText
        if(NoteTextView.text != ""){
            selectedNote!.content = text
        }
        else{
            context.delete(selectedNote!)
        }
        do{
          try context.save()
        }catch{
            print("Error while saving context, \(error)")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
   
    
    
}

