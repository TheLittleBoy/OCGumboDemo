//
//  main.m
//  GumboDemo
//
//  Created by Mac on 2023/5/31.
//

#import <Foundation/Foundation.h>
#import "OCGumbo+Query.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        OCGumboDocument *document =
        [[OCGumboDocument alloc] initWithHTMLString:
         @"<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'> \
         <head> \
            <title>Hello OCGumbo</title> \
         </head> \
         <body class=\"main othermain\" id=\"testID\"> \
            <select id=\"select\"> \
                <option class='abc efg'>A</option> \
                <option id=\"select\" class='abc'>B</option> \
                <option >C</option> \
                <option ></option> \
            </select> \
            <b>你是谁?</b> \
            <b><p>不知道</p></b> \
            <div> \
                <div id=\"theId\"> hello <div> \
            </div>\
            <div class=\"theCls\">world</div> \
            <p>text in p</p>\
            <!-- comment --> \
            <select> \
                <option class='abc efg'>A</option> \
                <option class='abc'>B</option> \
                <option>C</option> \
            </select> \
         </body>\
         "];
    
        //Basic Usage:
        NSLog(@"\n==================Basic Usage=====================");
        NSLog(@"document:%@", document);
        NSLog(@"has doctype: %d", document.hasDoctype);
        NSLog(@"publicID: %@", document.publicID);
        NSLog(@"systemID:%@", document.systemID);
        NSLog(@"title:%@", document.title);
        NSLog(@"childNodes:%@", document.body.childNodes);
        NSLog(@"documentElement:%@", document.rootElement);
        NSLog(@"head:%@", document.head);
        NSLog(@"body:%@", document.body);

        //Extension Query:
        NSLog(@"\n\n===============Extension Query==================");
        NSLog(@"options: %@", document.Query(@"body").find(@"#select").find(@"option").text());
        
        NSArray *titles = document.Query(@"b");
        for (OCGumboNode *node in titles) {
            NSLog(@"b: %@", node.text());
        }
        
        NSLog(@"title: %@", document.Query(@"title").text());
        NSLog(@"attribute: %@", document.Query(@"select").first().attr(@"id"));
        NSLog(@"class: %@", document.Query(@"#select").parents(@".main othermain"));
        NSLog(@"tag.class: %@", document.Query(@"div.theCls"));
        NSLog(@"tag#id : %@", document.Query(@"div#theId"));
        
        NSLog(@"\n\n=============== Body ==================");
        NSLog(@"%@",document.Query(@"body").first().html());
        NSLog(@"%@",document.Query(@"body").first().text());
        
        //Fetching from the website:
        NSLog(@"\n\n=============== Web ==================");
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.baidu.com"]
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil];
        if (html) {
            OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
            NSArray *images = doc.Query(@"img");
            for (OCGumboElement *img in images) {
                NSLog(@"attributes:%@", img.attributes);
                NSLog(@"%@", img.html());
            }
        }
    }
    return 0;
}
