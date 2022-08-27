//
//  UserDiaryRepository.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/26.
//

import Foundation
import RealmSwift

// Realm의 테이블이 여러개가 되면 => CRUD는 가지고 있어야 한다.
// 제네릭을 사용해서 여러 테이블을 관리할 수 있음.
protocol UserDiaryRepositoryType {
    func fetch() -> Results<UserDiary>!
    func fetchSort(_ sort: String) -> Results<UserDiary>!
    func fetchFilter() -> Results<UserDiary>!
    func fetchDate(date: Date) -> Results<UserDiary>!
    func updateFavorite(item: UserDiary)
    func deleteColumn(item: UserDiary)
    func addItem(item: UserDiary)
   
}


// 디자인 패턴 중 레퍼지토리 패턴
class UserDiaryRepository: UserDiaryRepositoryType {
   
    let localRealm = try! Realm()
    
    func fetch() -> Results<UserDiary>! {
        
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "updatedDate", ascending: true)
    }
    // 매개변수를 설정해서 정렬
    func fetchSort(_ sort: String) -> Results<UserDiary>! {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: sort, ascending: true)
    }
    // 매개변수를 설정해서 필터
    func fetchFilter() -> Results<UserDiary>! {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle CONTAINS[c] '6'", ascending: true)
        //.filter("diaryTitle = '가오늘의 일기316'")
    }
    
    func addItem(item: UserDiary) {
        do{
            try localRealm.write{
                localRealm.add(item) // Create(실제로 추가되는 것)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchDate(date: Date) -> Results<UserDiary>! {
        //NSPredicate
        return localRealm.objects(UserDiary.self).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date))
    }
    
    func updateFavorite(item: UserDiary){
        
        //realm data update -> 한가지 값만 업데이트
        try! localRealm.write{
            
            //1하나의 record에서 특정 컬럼 하나만 변경
            item.favorite.toggle()
            
            //2하나의 테이블에 특정 컬럼 전체 값을 변경
            //self.tasks.setValue(true, forKey: "favorite")
            
            //3하나의 레코드에서 여러 컬럼들이 변경
            //self.localRealm.create(UserDiary.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경 테스트", "diaryTitle": "제목임"], update: .modified)
        }
    }
    
    func deleteColumn(item: UserDiary){
       
        do {
            try localRealm.write{
                localRealm.delete(item)
                
                removeImageForDocument(fileName: "\(item.objectId)")
            }
        } catch let error {
            print(error)
        }
    }
    
    func removeImageForDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
        
    }
}
