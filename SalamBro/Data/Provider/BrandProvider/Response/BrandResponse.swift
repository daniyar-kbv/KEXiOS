//
//  BrandResponse.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

// {
//    "data": {
//        "count": 2,
//        "next": null,
//        "previous": null,
//        "results": [
//            {
//                "id": 1,
//                "name": "Салам бро",
//                "images": {
//                    "image_square": "http://185.111.106.12:8000/media/frame_317.png",
//                    "image_short": "http://185.111.106.12:8000/media/Frame_318.png",
//                    "image_tall": "http://185.111.106.12:8000/media/Frame_319.png",
//                    "image_long": "http://185.111.106.12:8000/media/Frame_309.png"
//                },
//                "is_available": true
//            },
//            {
//                "id": 12,
//                "name": "Мармелад бар",
//                "images": {
//                    "image_square": "http://185.111.106.12:8000/media/frame_316.png",
//                    "image_short": "http://185.111.106.12:8000/media/halal_bite.png",
//                    "image_tall": "http://185.111.106.12:8000/media/Frame_310.png",
//                    "image_long": "http://185.111.106.12:8000/media/Frame_326.png"
//                },
//                "is_available": false
//            }
//        ]
//    },
//    "error": null
// }

struct BrandResponse: Decodable {
    let data: ResponseData
    let error: String?

    struct ResponseData: Decodable {
        let count: Int
        let next: Int?
        let previous: Int?
        let results: [String]
    }
}
