// SwimMate/ViewModel/Extensions/Manager+StorageManagement.swift

import Foundation

extension Manager 
{
    func getLocalStorageInfo() -> String
    {
        let documentsPath = getDocumentsDirectory()
        
        do 
        {
            let fileManager = FileManager.default
            let files = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: [.fileSizeKey])
            
            var totalSize: Int64 = 0
            for file in files 
            {
                if let fileSize = try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize 
                {
                    totalSize += Int64(fileSize)
                }
            }
            
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = [.useKB, .useMB]
            formatter.countStyle = .file
            
            return formatter.string(fromByteCount: totalSize)
        } 
        catch 
        {
            return "Unable to calculate"
        }
    }
    
    func calculateStorageUsed() -> String
    {
        return getLocalStorageInfo()
    }
    
    func deleteAllData()
    {
        self.swims.removeAll()
        self.totalDistance = 0.0
        self.averageDistance = 0.0
        self.totalCalories = 0.0
        self.averageCalories = 0.0
        self.favoriteSetIds.removeAll()
        
        updateStore()
        
        // Also clear the JSON file
        let url = getDocumentsDirectory().appendingPathComponent("store.json")
        try? FileManager.default.removeItem(at: url)
    }
}