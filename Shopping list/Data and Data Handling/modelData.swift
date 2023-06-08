import SwiftUI
import Foundation

struct Items: Codable, Hashable {
    let id = UUID()
    var itemName: String
    var isCompleted: Bool
}


//var itemsList: [Items] = loadFromJSON("itemsData.json")
var itemsList: [Items] = checkAndLoadJSON("itemsData.json", sourceFile: "itemsData.json", destinationFile: "itemsData.json")
var defaultItemList: [Items] = checkAndLoadJSON("quickAddItems.json", sourceFile: "quickAddItems.json", destinationFile: "quickAddItems.json")


func copyFileFromBundleToDocumentsFolder(sourceFile: String, destinationFile: String) {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first

    if let documentsURL = documentsURL {
        let sourceURL = Bundle.main.bundleURL.appendingPathComponent(sourceFile)
        let destURL = documentsURL.appendingPathComponent(!destinationFile.isEmpty ? destinationFile : sourceFile)

        if fileManager.fileExists(atPath: destURL.path) {
            print("File already exists at destination. Doing nothing.")
            return
        }
        
        do {
            try fileManager.copyItem(at: sourceURL, to: destURL)
            print("\(sourceFile) was copied successfully.")
        } catch let error {
            print("Error copying file: \(error)")
        }
    }
}


func writeJSON(items: [Items], destinationFile: String) {
    do {
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(destinationFile)
        
        let encoder = JSONEncoder()
        try encoder.encode(items).write(to: fileURL)
    } catch {
        print(error.localizedDescription)
    }
}

func listDocumentDirectoryFiles() {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    if let url = documentsURL {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: url.path)
            print("\(contents.count) files inside the document directory:")
            for file in contents {
                print(file)
            }
        } catch {
            print("Could not retrieve contents of the document directory.")
        }
    }
}

func copyJSON(sourceFile: String, destinationFile: String) {
    
    copyFileFromBundleToDocumentsFolder(sourceFile: sourceFile, destinationFile: destinationFile)
    print("WE chilling now")
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func checkAndLoadJSON<T: Decodable>(_ filename: String, sourceFile: String, destinationFile: String) -> T {
    let data: Data
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    
    if let documentsURL = documentsURL {
        let sourceURL = Bundle.main.bundleURL.appendingPathComponent(sourceFile)
        let destURL = documentsURL.appendingPathComponent(!destinationFile.isEmpty ? destinationFile : sourceFile)
        
        if fileManager.fileExists(atPath: destURL.path) {
            print("File already exists at destination. Doing nothing.")
        }
        else {
            do {
                try fileManager.removeItem(at: destURL)
                print("Removed existing file at destination")
            } catch let error {
                print("Error removing file at destination: \(error)")
            }
            
            do {
                try fileManager.copyItem(at: sourceURL, to: destURL)
                print("\(sourceFile) was copied successfully.")
            } catch let error {
                print("Error copying file: \(error)")
            }
        }
    }
    
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        fatalError("Couldn't access the documents directory.")
    }
    
    let fileURL = documentsDirectory.appendingPathComponent(filename)

    do {
        copyJSON(sourceFile: sourceFile, destinationFile: destinationFile)
        data = try Data(contentsOf: fileURL)
    } catch {
        copyJSON(sourceFile: sourceFile, destinationFile: destinationFile)
        fatalError("Couldn't load \(filename) from the documents directory:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

/*
 For use for later
 ToolbarItem(placement: .bottomBar) {
 Toggle("", isOn: $darkMode)
     .toggleStyle(SwitchToggleStyle(tint: .red))
}*/
