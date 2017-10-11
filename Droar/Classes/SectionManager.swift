//
//  SectionManger.swift
//  Pods
//
//  Created by Nathan Jangula on 9/1/17.
//
//

import Foundation

//#import "FactoryManager.h"
//#import "BasicSectionFactory.h"
//#import "IDebugController.h"
//
//@interface SectionMapping : NSObject
//
//@property (strong, nonatomic) Class<ISectionSourceFactory> factoryClass;
//@property (strong, nonatomic) id<IDrawerSectionSource> sectionSource;
//@property (nonatomic) PositionInfo positioning;
//
//@end
//
//@implementation SectionMapping
//
//@end
//
//@interface FactoryManager ()
//
//@property (strong, nonatomic) NSMutableArray<Class<ISectionSourceFactory> > *factoryClasses;
//@property (strong, nonatomic) NSArray<SectionMapping *> *sortedSectionMappings;
//
//@end
//
//@implementation FactoryManager

class SectionManager {
    
    static let sharedInstance = SectionManager()
    public private(set) var sources = [ISectionSource]()
    
    private init() {
        sources.append(BuildInfoSource())
        sources.append(DeviceInfoSource())
        sources.append(LogSource())
        sortSources()
    }
    
    public func registerSource(source: ISectionSource) {
        if (!sources.contains(where: { (existingSource) -> Bool in
            return existingSource.sectionTitle() == source.sectionTitle()
        })) {
            cacheSources(newSource: source)
        }
    }
    
    private func cacheSources(newSource: ISectionSource) {
        sources.append(newSource)
        sortSources()
    }
    
    private func sortSources() {
        sources.sort { (source1, source2) -> Bool in
            let position1 = source1.sectionPosition()
            let position2 = source2.sectionPosition()
            
            if (position1.position != position2.position)
            {
                return position1.position.rawValue >= position2.position.rawValue
            }
            
            return position1.priority.rawValue >= position2.priority.rawValue
        }
    }
    
    public func initializeSections(tableView: UITableView) {
        for section in sources {
            section.performSetup(tableView: tableView)
        }
    }
//
//    - (void)cacheSectionsWithNewFactory:(Class<ISectionSourceFactory>)factoryClass
//{
//    [self.factoryClasses addObject:factoryClass];
//    
//    NSMutableArray<SectionMapping *> *sectionMappings = [NSMutableArray array];
//    
//    for (Class<ISectionSourceFactory> theClass in self.factoryClasses)
//    {
//        for (NSUInteger index = 0; index < [theClass numberOfDrawerSections]; index++)
//        {
//            SectionMapping *mapping = [[SectionMapping alloc] init];
//            [mapping setFactoryClass:theClass];
//            [mapping setSectionSource:[theClass drawerSectionForIndex:index]];
//            [mapping setPositioning:[theClass positionForDrawerSectionIndex:index]];
//            
//            if (mapping.sectionSource)
//            {
//                [sectionMappings addObject:mapping];
//            }
//        }
//    }
//    
//    [self setSortedSectionMappings:[self sortedMappings:sectionMappings]];
//    }
    
//    private func cacheSections(newFactoryClass)
    
//    
//    - (NSArray<SectionMapping *> *)sortedMappings:(NSArray<SectionMapping *> *)unsortedMappings
//{
//    return [unsortedMappings sortedArrayUsingComparator:^NSComparisonResult (SectionMapping *obj1, SectionMapping *obj2) {
//        NSComparisonResult sectionOrder = (obj1.positioning.position == obj2.positioning.position) ? NSOrderedSame : (obj1.positioning.position > obj2.positioning.position) ? NSOrderedDescending : NSOrderedAscending;
//        
//        if (sectionOrder == NSOrderedSame)
//        {
//        sectionOrder = (obj1.positioning.priority == obj2.positioning.priority) ? NSOrderedSame : (obj1.positioning.priority > obj2.positioning.priority) ? NSOrderedDescending : NSOrderedAscending;
//        }
//        
//        return sectionOrder;
//        }];
//    }
//    
//    - (void)initializeAllSectionsWithTableView:(UITableView *)tableView
//{
//    for (SectionMapping *mapping in self.sortedSectionMappings)
//    {
//        if ([mapping.sectionSource respondsToSelector:@selector(drawerSectionPerformSetupForTableView:)])
//        {
//            [mapping.sectionSource drawerSectionPerformSetupForTableView:tableView];
//        }
//    }
//    }
//    
//    - (BOOL)hasObservers
//        {
//            return self.observers && self.observers.count > 0;
//        }
//        
//        - (NSUInteger)numberOfSections
//            {
//                return self.sortedSectionMappings.count + [self hasObservers] + self.staticControllers.count;
//            }
//            
//            - (NSString *)titleForSection:(NSUInteger)section
//{
//    if ([self hasObservers])
//    {
//        if (section == 0)
//        {
//            id<IDebugController> observingObject = [self.observers[0] observingObject];
//            
//            if ([observingObject respondsToSelector:@selector(debugObserverSectionTitle)])
//            {
//                return [observingObject debugObserverSectionTitle];
//            }
//            else
//            {
//                return NSStringFromClass([observingObject class]);
//            }
//        }
//        else
//        {
//            section--;
//        }
//    }
//    
//    if (section < self.staticControllers.count)
//    {
//        if ([self.staticControllers[section] respondsToSelector:@selector(debugObserverSectionTitle)])
//        {
//            return [self.staticControllers[section] debugObserverSectionTitle];
//        }
//        else
//        {
//            return NSStringFromClass([self.staticControllers[section] class]);
//        }
//    }
//    else
//    {
//        section -= self.staticControllers.count;
//    }
//    
//    SectionMapping *mapping = self.sortedSectionMappings[section];
//    return [mapping.sectionSource drawerSectionTitle];
//    }
//    
//    - (NSUInteger)numberOfCellsForSection:(NSUInteger)section
//{
//    if ([self hasObservers])
//    {
//        if (section == 0)
//        {
//            return self.observers.count;
//        }
//        else
//        {
//            section--;
//        }
//    }
//    
//    if (section < self.staticControllers.count)
//    {
//        return [self.staticControllers[section] debugObserverCount];
//    }
//    else
//    {
//        section -= self.staticControllers.count;
//    }
//    
//    SectionMapping *mapping = self.sortedSectionMappings[section];
//    return [mapping.sectionSource drawerSectionNumberOfCells];
//    }
//    
//    - (UITableViewCell *)tableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self hasObservers])
//    {
//        if (indexPath.section == 0)
//        {
//            return [self.observers[indexPath.row] cell];
//        }
//        else
//        {
//            indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
//        }
//    }
//    
//    if (indexPath.section < self.staticControllers.count)
//    {
//        id<IDebugController> controller = self.staticControllers[indexPath.section];
//        
//        NSNumber *index = @(indexPath.section);
//        
//        NSMutableArray *observers = self.staticObserversByControllerIndex[index];
//        
//        if (!observers)
//        {
//            observers = [NSMutableArray array];
//            [self.staticObserversByControllerIndex setObject:observers forKey:index];
//        }
//        
//        id<IDebugObserver> observer;
//        
//        if (observers.count <= indexPath.row)
//        {
//            observer = [controller debugObserverForIndex:indexPath.row];
//            
//            [((NSObject *) observer) setValue:controller forKey:@"_observingObject"];
//            [((NSObject *) observer) setValue:@(indexPath.row) forKey:@"_index"];
//            
//            [observers addObject:observer];
//        }
//        else
//        {
//            observer = observers[indexPath.row];
//        }
//        
//        return [observer cell];
//    }
//    else
//    {
//        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - self.staticControllers.count];
//    }
//    
//    SectionMapping *mapping = self.sortedSectionMappings[indexPath.section];
//    return [mapping.sectionSource drawerSectionTableView:tableView cellForIndex:indexPath.row];
//    }
//    
//    - (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSIndexPath *originalIndexPath = indexPath;
//    
//    if ([self hasObservers])
//    {
//        if (indexPath.section == 0)
//        {
//            id <IDebugObserver> observer = self.observers[indexPath.row];
//            
//            if ([observer allowsSelection] && [[observer observingObject] respondsToSelector:@selector(debugObserver:wasSelectedAtIndex:)])
//            {
//                [[observer observingObject] debugObserver:observer wasSelectedAtIndex:[observer index]];
//            }
//            
//            [tableview deselectRowAtIndexPath:originalIndexPath animated:YES];
//            
//            return;
//        }
//        else
//        {
//            indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
//        }
//    }
//    
//    if (indexPath.section < self.staticControllers.count)
//    {
//        NSNumber *index = @(indexPath.section);
//        
//        NSMutableArray *observers = self.staticObserversByControllerIndex[index];
//        
//        id<IDebugObserver> observer = observers[indexPath.row];
//        
//        if ([observer allowsSelection] && [[observer observingObject] respondsToSelector:@selector(debugObserver:wasSelectedAtIndex:)])
//        {
//            [[observer observingObject] debugObserver:observer wasSelectedAtIndex:[observer index]];
//        }
//        
//        [tableview deselectRowAtIndexPath:originalIndexPath animated:YES];
//        
//        return;
//    }
//    else
//    {
//        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - self.staticControllers.count];
//    }
//    
//    SectionMapping *mapping = self.sortedSectionMappings[indexPath.section];
//    
//    BOOL shouldDeselect = YES;
//    
//    if ([mapping.sectionSource respondsToSelector:@selector(drawerSectionTableView:didSelectIndex:shouldDeselect:)])
//    {
//        [mapping.sectionSource drawerSectionTableView:tableview didSelectIndex:indexPath.row shouldDeselect:&shouldDeselect];
//    }
//    
//    if (shouldDeselect)
//    {
//        [tableview deselectRowAtIndexPath:originalIndexPath animated:YES];
//    }
//}
//
//@end

}
