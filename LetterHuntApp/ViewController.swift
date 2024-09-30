//
//  ViewController.swift
//  LetterHuntApp
//
//  Created by Eren Elçi on 30.09.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigasyonItem sağ button ekleme
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(promptForAnswer))
        
        //navigasyonItem sol button ekleme
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fastForward, target: self, action: #selector(startGame))
        
        // dosya okuma işlemleri
        if let startWordsURL = Bundle.main.url(forResource: "star", withExtension: "txt") {
            // dosyayı okuduk ve daha sonra değişkene atadık
            if let startWords = try? String(contentsOf: startWordsURL) {
                // değişkendeki okunan değeri her satırı bölcek şekilde all words ekledik
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["boşgeldi"]
        }
        
        startGame()
        
    }
    
   @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        var contex = cell.defaultContentConfiguration()
        contex.text = usedWords[indexPath.row]
        cell.contentConfiguration = contex
        return cell
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Cevabı Gönder", message: nil, preferredStyle: .alert)
        ac.addTextField()
     
        let submitAction = UIAlertAction(title: "Gönder", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
            
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isBig(word: lowerAnswer) {
            if isSame(word: lowerAnswer) {
                if isPossible(word: lowerAnswer) {
                    if  isOriginal(word: lowerAnswer) {
                        if   isReal(word: lowerAnswer) {
                            // kullanılan arraye ekleme 0  indexe ekleme yapıyoruz liste kayıyor
                            usedWords.insert(answer, at: 0)
                            let indexPath = IndexPath(row: 0, section: 0) // indexpath 0 satır 0 hücre
                            tableView.insertRows(at: [indexPath], with: .automatic) // satır ekleme işlemi
                            
                            return
                        } else {
                            showErrorMessage(title: "Kelime tanınmadı", message: "Onları öylece uyduramazsın, biliyorsun!")
                            
                        }
                    } else {
                        showErrorMessage(title: "Zaten kullanılan kelime", message: "Daha orjinal olun")
                    }
                } else {
                    showErrorMessage(title: "Kelime mümkün değil", message: "Bu kelimeyi heceleyemezsin. \(title!.lowercased()).")
                    
                }
            } else {
                showErrorMessage(title: "Aynı kelimeyi girdin", message: "Bu kelimeyi giremessin. '\(title!.lowercased())'.")
            }
        } else {
            showErrorMessage(title: "Kendini biraz zorla 3 den büyük bir kelime bul", message: "Bu kelimeyi giremessin.")
        }
       
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return  false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    func isOriginal(word: String) -> Bool {
        for wordInArray in usedWords {
        if wordInArray.lowercased() == word {
             return false
        }
    }
        return true
        
    }
    func isReal(word: String) -> Bool {
        let chacker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = chacker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "tr")
        return misspelledRange.location == NSNotFound
    }
    
    func isSame(word: String) -> Bool {
        if word == self.title! {
            return false
        } else {
            return true
        }
        
    }
    
    func isBig(word: String) -> Bool {
        if word.count <= 3 {
            return false
        } else {
            return true
        }
    }
    
    func showErrorMessage(title: String , message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default))
        present(ac, animated: true)
    }


}

