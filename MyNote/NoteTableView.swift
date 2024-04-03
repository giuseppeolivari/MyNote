//
//  NoteTableView.swift
//  MyNote
//
//  Created by Giuseppe Olivari on 31/03/24.
//


import UIKit
import CoreData

var noteList = [Note]()

class NoteTableView: UITableViewController
{
    
    
    var firstLoad = true
    var selectedNote: Note? = nil
    
    func nonDeletedNotes() -> [Note]
    {
        var noDeleteNoteList = [Note]()
        for note in noteList
        {
            if(note.deletedDate == nil)
            {
                noDeleteNoteList.append(note)
            }
        }
        return noDeleteNoteList
    }
    
    override func viewDidLoad()
    {
        if(firstLoad)
        {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    noteList.append(note)
                }
            }
            catch
            {
                print("Loading failed")
            }
        }
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let noteElement = tableView.dequeueReusableCell(withIdentifier: "noteElementID", for: indexPath) as! NoteElement
        
        
        
        let thisNote: Note!
        
        thisNote = nonDeletedNotes()[indexPath.row]
        
        
        noteElement.titleLabel.text = thisNote.title
        noteElement.testoLabel.text = thisNote.testo
        
        return noteElement
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nonDeletedNotes().count
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "modifyNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "modifyNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? ViewController
            
            let selectedNote : Note!
            selectedNote = nonDeletedNotes()[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
                // Delete the current note 
                let noteToDelete = self.nonDeletedNotes()[indexPath.row]
                self.DeleteNote(noteToDelete)
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash.fill")
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }

        func DeleteNote(_ noteToDelete: Note) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            // Set the deletion date for the selected note
            noteToDelete.deletedDate = Date()
            do {
                
                try context.save()
                // Remove the note from the local list
                if let index = noteList.firstIndex(of: noteToDelete) {
                    noteList.remove(at: index)
                }
                
                self.tableView.reloadData()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    
    
    
}
