<details>
<summary><h2>Uygulama İçeriği</h2></summary>

  <details>
    <summary><h2>Oyun İçeriği</h2></summary>
    Bu uygulama, kullanıcı etkileşimini ve temel iOS bileşenlerini kullanarak basit ama etkili bir kelime oyunu sunar. UITableViewController, UIAlertController ve UITextChecker gibi bileşenlerin entegrasyonu sayesinde, kullanıcı dostu bir deneyim sağlanmıştır. Kod yapısı temiz ve anlaşılır olup, genişletilebilir bir mimariye sahiptir
  </details> 

  <details>
    <summary><h2>Navigasyon Butonları</h2></summary>
    Sağ Buton Kullanıcıdan yeni bir kelime girmesini sağlamak için promptForAnswer metodunu tetikler.Sol Buton Yeni bir oyun başlatmak için startGame metodunu tetikler.
    
    ```s
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(startGame))

    ```
  </details> 

  <details>
    <summary><h2>startGame()</h2></summary>
    Yeni bir oyun başlatır.allWords dizisinden rastgele bir kelime seçerek başlık olarak ayarlar.Daha önce kullanılan kelimeler listesini temizler.Tablo görünümünü yenileyerek günceller.

    
    ```
    @objc func startGame(){
    title = allWords.randomElement()
    usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
    }

    ```
  </details> 

  <details>
    <summary><h2>promptForAnswer()</h2></summary>
    Kullanıcıdan yeni bir kelime girmesini isteyen bir uyarı penceresi (UIAlertController) oluşturur.Kullanıcı "Gönder" butonuna bastığında, girilen kelime submit metoduna iletilir.
    
    ```
    @objc func promptForAnswer(){
    let ac = UIAlertController(title: "Cevabı Gönder", message: nil, preferredStyle: .alert)
    ac.addTextField()
 
    let submitAction = UIAlertAction(title: "Gönder", style: .default) { [weak self, weak ac] action in
        guard let answer = ac?.textFields?[0].text else { return }
        self?.submit(answer)
    }
    ac.addAction(submitAction)
    present(ac, animated: true)
    }

    ```
  </details> 


  <details>
    <summary><h2>submit(_ answer: String)</h2></summary>
    Kullanıcının girdiği kelimeyi alır ve küçük harfe çevirir.Kelimenin belirli kriterlere (büyüklük, benzersizlik, mümkünlük, özgünlük, gerçeklik) uyup uymadığını kontrol eder.Tüm kriterler sağlanıyorsa, kelimeyi usedWords dizisine ekler ve tabloyu günceller.Herhangi bir kriter sağlanmıyorsa, uygun hata mesajını gösterir.
    
    ```
    func submit(_ answer: String) {
    let lowerAnswer = answer.lowercased()
    
    if isBig(word: lowerAnswer) {
        if isSame(word: lowerAnswer) {
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        usedWords.insert(answer, at: 0)
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
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


    ```
  </details> 



   
</details>
