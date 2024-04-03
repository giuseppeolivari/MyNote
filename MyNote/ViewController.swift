//
//  ViewController.swift
//  MyNote
//
//  Created by Giuseppe Olivari on 31/03/24.
//

import UIKit
import CoreData


class ViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
  
    
    @IBOutlet weak var testoTextField: UITextView!
   
   
    
    
    
    
    var selectedNote: Note? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedNote != nil)
        {
            titleTextField.text = selectedNote?.title
            testoTextField.text = selectedNote?.testo
        }
        // Do any additional setup after loading the view.
        testoTextField.layer.cornerRadius = 10.0 
            testoTextField.clipsToBounds = true
    }


    @IBAction func saveNote(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedNote == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = titleTextField.text
            newNote.testo = testoTextField.text
            do
            {
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch
            {
                print("Saving error!")
            }
        }
        else
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    if(note == selectedNote)
                    {
                        note.title = titleTextField.text
                        note.testo = testoTextField.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch
            {
                print("Error")
            }
        }
    }
    
    
}

