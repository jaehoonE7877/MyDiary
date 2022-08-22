//
//  RealmModel.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/22.
//

import Foundation
import RealmSwift

//UserDiary: 테이블 이름
//@Persisted: 컬럼 이름
//제목(필수), 작성 날짜(필수), 등록 날짜(필수), 즐겨찾기(필수), 사진url(옵션), 내용(옵션)
class UserDiary: Object {
    @Persisted var diaryTitle: String
    @Persisted var diaryContent: String?
    @Persisted var diaryDate = Date()
    @Persisted var updatedDate = Date()
    @Persisted var favorite: Bool
    @Persisted var imageURL: String?
    
    //PK(중복이 안되는 필수 값 -> 일기 마다 고유한 번호를 부여하기 위해서): Int, UUID, ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(diaryTitle: String, diaryContent: String?, diaryDate: Date, updatedDate: Date, imageURL: String?) {
        self.init()
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryDate = diaryDate
        self.updatedDate = updatedDate
        self.favorite = false
        self.imageURL = imageURL
    }
}
