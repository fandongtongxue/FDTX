//
//  WordPressArticleModel.swift
//  FDTX
//
//  Created by fandong on 2017/9/19.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import HandyJSON

class WordPressArticleModel: HandyJSON {
    var id:String!
    var url:String!
    var title:String!
    var modified:String!
    var content:String!
/*
 {
 "id": 49,
 "type": "post",
 "slug": "49",
 "url": "http://video.fandong.me/2017/09/19/49/",
 "status": "publish",
 "title": "Sam Tsui ft &#038; Christina Grimmie &#8211; Just A Dream",
 "title_plain": "Sam Tsui ft &#038; Christina Grimmie &#8211; Just A Dream",
 "content": "<div class=\"smartideo\">\n<div class=\"player\">\n                    <iframe src=\"//player.youku.com/embed/XMjQ5MDkxOTY4?client_id=d0b1b77a17cded3b\" width=\"100%\" height=\"100%\" frameborder=\"0\" allowfullscreen=\"true\"></iframe>\n                </div>\n</div>\n",
 "excerpt": "",
 "date": "2017-09-19 16:25:41",
 "modified": "2017-09-19 16:27:52",
 "categories": [
 {
 "id": 12,
 "slug": "%e9%9f%b3%e4%b9%90",
 "title": "音乐",
 "description": "",
 "parent": 0,
 "post_count": 2
 }
 ],
 "tags": [],
 "author": {
 "id": 1,
 "slug": "admin",
 "name": "范东同学",
 "first_name": "",
 "last_name": "",
 "nickname": "范东同学",
 "url": "",
 "description": ""
 },
 "comments": [],
 "attachments": [
 {
 "id": 50,
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392.jpg",
 "slug": "2017091916253392",
 "title": "2017091916253392",
 "description": "",
 "caption": "",
 "parent": 49,
 "mime_type": "image/jpeg",
 "images": {
 "full": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392.jpg",
 "width": 670,
 "height": 375
 },
 "thumbnail": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392-150x150.jpg",
 "width": 150,
 "height": 150
 },
 "medium": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392-300x168.jpg",
 "width": 300,
 "height": 168
 },
 "medium_large": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392.jpg",
 "width": 670,
 "height": 375
 },
 "large": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392.jpg",
 "width": 670,
 "height": 375
 }
 }
 }
 ],
 "comment_count": 0,
 "comment_status": "open",
 "thumbnail": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392-150x150.jpg",
 "custom_fields": {
 "single_himg_s": [
 "0"
 ],
 "lunbo_value": [
 "0"
 ],
 "lunbo_silde_value": [
 "0"
 ],
 "cc_value": [
 "4"
 ],
 "views": [
 "4"
 ]
 },
 "thumbnail_size": "thumbnail",
 "thumbnail_images": {
 "full": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392.jpg",
 "width": 670,
 "height": 375
 },
 "thumbnail": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392-150x150.jpg",
 "width": 150,
 "height": 150
 },
 "medium": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392-300x168.jpg",
 "width": 300,
 "height": 168
 },
 "medium_large": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392.jpg",
 "width": 670,
 "height": 375
 },
 "large": {
 "url": "http://video.fandong.me/wp-content/uploads/2017/09/2017091916253392.jpg",
 "width": 670,
 "height": 375
 }
 },
 "taxonomy_special": []
 }
 */

    required init() {
    
    }
}
