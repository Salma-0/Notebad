//
//  TableViewController.swift
//  Notebad
//
//  Created by Salma on 14/09/2019.
//  Copyright © 2019 Salma. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {


    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let FilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FilePath)
      loadNotes()

    }
    

    
    // MARK: - Table view data source

   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        // Configure the cell...
         cell.textLabel?.text = notes[indexPath.row].content
        return cell
    }
    
    
    //MARK: - CoreData Stack
    
    
    func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()){
        do{
            try notes = context.fetch(request)
        }catch{
            print("Error loading the notes! \(error)")
        }
        tableView.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NoteViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = notes[indexPath.row]
        }else{
            let newNote = Note(context: context)
            newNote.content = ""
            newNote.date = Date()
            notes.append(newNote)
            destinationVC.selectedNote = newNote
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNote", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    @IBAction func composeNote(_ sender: Any) {
       
        performSegue(withIdentifier: "goToNote", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            notes.remove(at: indexPath.row)
            context.delete(notes[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveContext()
        }   
    }
    
    func saveContext(){
        do{
            try context.save()
        }catch{
            print("ERROR while saving context, \(error)")
        }
    }
    


}
