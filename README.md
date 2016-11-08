# AJRealmDB
对Realm数据库的二次封装，方便使用

运行Demo需要导入 `Realm` 数据库的静态包 `Realm.framework`，从官网下载。


#### 使用文档

1. 所有需要写入数据库的类需要继承自：`AJDBObject` 。  并且必须要实现方法: `primaryKey`，用来定义主键。

2. 对应条件查询接口，可以根据断言条件语句查询、结果排序等，更多用法可以参考苹果官方文档: [NSPredicate](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html)

3. 对于一个数据模型中包含有另一个模型个数组，定义方法如下：

  ```objective-c
  1.在数组包含的那个模型里面添加宏定义: RLM_ARRAY_TYPE(ClassName)
  2.在包含数组的那个模型里面这样定义数组：@property RLMArray<ObjectType *><ObjectType> *arrayOfObjectTypes
  3.更多详细用法可以参考示例程序
  ```

4. 如果数据库需要加密，可以通过调用方法 `configSecurityKey:`,如果不配置，默认不加密。

5. 所有数据库事务操作通过 `AJDBManager` 类。接口有:

```objective-c
/**
 * 设置数据库加密Key,全局只需设置一次。如果不设置，默认不加密
 * 一个数据库只对应一个Key
 @param secKey 加密Key
 */
+ (void)configSecurityKey:(NSData *)secKey;

/**
 *  写入一条数据
 *
 *  @param obj 目标数据
 */
+ (void)writeObj:(__kindof AJDBObject *)obj;

/**
 *  批量写入
 *
 *  @param objs 数组
 */
+ (void)writeObjArray:(NSArray<__kindof AJDBObject *> *)objs;

/**
 *  更新一条数据，更新数据必须在block中执行
 *
 *  @param updateBlock 在block中更新数据
 */
+ (void)updateObj:(void (^)())updateBlock;

/**
 *  在数据库中删除目标数据
 *
 *  @param obj 目标数据
 */
+ (void)deleteObj:(__kindof AJDBObject *)obj;

/**
 *  在数据库中删除目标数组数据
 *
 *  @param objs 需要删除的数据数组
 */
+ (void)deleteObjs:(NSArray<__kindof AJDBObject *> *)objs;

/**
 *  查询目标数据模型的所有存储数据
 *
 *  @param clazz 需要查询的目标类
 *
 *  @return 数据库中存储的所有数据
 */
+ (NSArray<__kindof AJDBObject *> *)queryAllObj:(Class)clazz;

/**
 *  根据断言条件查询目标数据
 *
 *  @param predicate 查询条件
 *  @param clazz     需要查询的目标类
 *
 *  @return 查询结果
 */
+ (NSArray<__kindof AJDBObject *> *)queryObjWithPredicate:(NSPredicate *)predicate targetClass:(Class)clazz;

/**
 *  根据断言条件查询数据，并进行排序
 *
 *  @param predicate  查询条件
 *  @param clazz      需要查询的类
 *  @param sortFilter 排序配置
 *
 *  @return 查询结果
 */
+ (NSArray<__kindof AJDBObject *> *)queryObjWithPredicate:(NSPredicate *)predicate sortFilter:(AJSortFilter *)sortFilter targetClass:(Class)clazz;

/**
 *  根据主键查询目标数据
 *
 *  @param primaryKey 主键值
 *  @param clazz      需要查询的类
 *
 *  @return 查询结果
 */
+ (__kindof AJDBObject *)queryObjWithPrimaryKeyValue:(id)primaryKey targetClass:(Class)clazz;

/**
 *  清空数据库
 */
+ (void)clear;
```
