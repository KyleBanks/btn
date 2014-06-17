//
//  BTNOpenURLView.m
//  btn
//
//  Created by Kyle Banks on 2014-06-17.
//  Copyright (c) 2014 Kyle W. Banks. All rights reserved.
//

#import "BTNOpenURLView.h"
#import "NSTextFieldCell+VerticalAlign.h"
#import "BTNCache.h"

NSString * const COLUMN_URL = @"COLUMN_URL";
NSString * const COLUMN_ACTION = @"COLUMN_ACTION";

CGFloat const ROW_HEIGHT = 40.0f;

@implementation BTNOpenURLView
{
    NSMutableArray *urls;
}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        urls = [BTNCache sharedCache].selectedURLs;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [self.tblURLs setDelegate:self];
    [self.tblURLs setDataSource:self];
    [self.tblURLs setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
    
    [self.cmdAddURL setTarget:self];
    [self.cmdAddURL setAction:@selector(addURL)];
}
#pragma mark - NSTableViewDatasource implementation
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return urls.count;
}
#pragma mark - NSTableViewDelegate implementation
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSView *view = [[NSView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, tableColumn.width, ROW_HEIGHT))];
    
    if([tableColumn.identifier isEqualToString:COLUMN_URL]) {
        NSTextField *txtDisplay = [[NSTextField alloc] initWithFrame:view.bounds];
        [txtDisplay setEditable:NO];
        [txtDisplay setBordered:NO];
        txtDisplay.backgroundColor = [NSColor clearColor];
        txtDisplay.stringValue = [urls objectAtIndex:row];

        [view addSubview:txtDisplay];
    } else if([tableColumn.identifier isEqualToString:COLUMN_ACTION]) {
        NSButton *imgRemove = [[NSButton alloc] initWithFrame:view.bounds];
        [imgRemove setImage:[NSImage imageNamed:@"delete-icon"]];
        [imgRemove setBordered:NO];
        [imgRemove setTarget:self];
        [imgRemove setTag:row];
        [imgRemove setAction:@selector(deleteURL:)];
        
        [view addSubview:imgRemove];
    }
    
    return view;
}
-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return ROW_HEIGHT;
}

#pragma mark - URL management
-(void)deleteURL:(NSButton *)sender {
    NSString *url = [urls objectAtIndex:sender.tag];
    NSLog(@"Deleting URL: %@", url);
    
    [urls removeObjectAtIndex:sender.tag];
    [self.tblURLs reloadData];
    
    [[BTNCache sharedCache] setSelectedURLS:urls];
}
-(void)addURL {
    NSString *url = self.txtURLInput.stringValue;
    if(url.length == 0) {
        return;
    }
    
    NSLog(@"Adding URL: %@", url);
    [urls addObject:url];
    [self.tblURLs reloadData];
    self.txtURLInput.stringValue = @"";
    
    [[BTNCache sharedCache] setSelectedURLS:urls];
}

@end
