# AJRealmDB
对Realm数据库的二次封装，方便使用

#### 使用文档

1. 所有需要写入数据库的类需要继承自：`AJDBObject` 。  并且必须要实现方法: `primaryKey`，用来定义主键。

2. 对应条件查询接口，可以根据断言条件语句查询、结果排序等，更多用法可以参考苹果官方文档: [NSPredicate](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html)

3. 对于一个数据模型中包含有另一个模型个数组，定义方法如下：

  ```objective-c
  1.在数组包含的那个模型里面添加宏定义: RLM_ARRAY_TYPE(ClassName)
  2.在包含数组的那个模型里面这样定义数组：@property RLMArray<ObjectType *><ObjectType> *arrayOfObjectTypes
  3.更多详细用法可以参考示例程序
  ```

4. 如果数据库需要加密，可以通过调用方法 `setupConfigInfo:`,如果不配置，默认不加密。`AJDBConfig` 类包含了所需的配置。

5. 所有数据库事务操作通过 `AJDBManager` 类。接口有:

```objective-c
/**
 *  写入一条数据
 *
 *  @param obj 目标数据
 *
 *  @return 执行结果
 */
+ (BOOL)writeObj:(__kindof AJDBObject *)obj;

/**
 *  批量写入
 *
 *  @param objs 数组
 *
 *  @return 执行结果
 */
+ (BOOL)writeObjs:(NSArray<__kindof AJDBObject *> *)objs;

/**
 *  更新一条数据，更新数据必须在block中执行
 *
 *  @param updateBlock 在block中更新数据
 *
 *  @return 执行结果
 */
+ (BOOL)updateObj:(void (^)(void))updateBlock;

/**
 *  在数据库中删除目标数据
 *
 *  @param obj 目标数据
 *
 *  @return 执行结果
 */
+ (BOOL)deleteObj:(__kindof AJDBObject *)obj;

/**
 *  在数据库中目标主键数据
 *
 * @param primaryKey 主键
 * @param clazz 目标类
 *
 * @return 执行结果
 */
+ (BOOL)deleteObjWithPrimaryKey:(id)primaryKey targetClass:(Class)clazz;

/**
 *  在数据库中删除目标数组数据
 *
 *  @param objs 需要删除的数据数组
 *
 *  @return 执行结果
 */
+ (BOOL)deleteObjs:(NSArray<__kindof AJDBObject *> *)objs;

/**
 * 在数据库中删除所有目标类对应的数据
 *
 * @param clazz 目标类
 *
 * @return 执行结果
 */
+ (BOOL)deleteAllTargetObjs:(Class)clazz;

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
+ (NSArray<__kindof AJDBObject *> *)queryObjsWithPredicate:(NSPredicate *)predicate targetClass:(Class)clazz;

/**
 *  根据断言条件查询数据，并进行排序
 *
 *  @param predicate  查询条件
 *  @param clazz      需要查询的类
 *  @param sortFilter 排序配置
 *
 *  @return 查询结果
 */
+ (NSArray<__kindof AJDBObject *> *)queryObjsWithPredicate:(NSPredicate *)predicate sortFilter:(AJSortFilter *)sortFilter targetClass:(Class)clazz;

/**
 *  根据主键查询目标数据
 *
 *  @param primaryKey 主键值
 *  @param clazz      需要查询的类
 *
 *  @return 查询结果
 */
+ (__kindof AJDBObject *)queryObjWithPrimaryKey:(id)primaryKey targetClass:(Class)clazz;

/**
 *  清空数据库
 *
 *  @return 执行结果
 */
+ (BOOL)clear;
```
