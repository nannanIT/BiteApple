#  相关资料

## 源码
[Apple源码官网](https://opensource.apple.com/source/objc4/)

```
#if !OBJC_TYPES_DEFINED
/// An opaque type that represents an Objective-C class.
typedef struct objc_class *Class;

/// Represents an instance of a class.
struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
};

/// A pointer to an instance of a class.
typedef struct objc_object *id;
#endif

/// An opaque type that represents a method selector.
typedef struct objc_selector *SEL;

/// A pointer to the function of a method implementation. 
#if !OBJC_OLD_DISPATCH_PROTOTYPES
typedef void (*IMP)(void /* id, SEL, ... */ ); 
#else
typedef id _Nullable (*IMP)(id _Nonnull, SEL _Nonnull, ...); 
#endif

struct class_rw_ext_t {
    const class_ro_t *ro;
    method_array_t methods;
    property_array_t properties;
    protocol_array_t protocols;
    char *demangledName;
    uint32_t version;
};

struct method_t {
    SEL name;
    const char *types;
    MethodListIMP imp;

    struct SortBySELAddress :
        public std::binary_function<const method_t&,
                                    const method_t&, bool>
    {
        bool operator() (const method_t& lhs,
                         const method_t& rhs)
        { return lhs.name < rhs.name; }
    };
};

struct ivar_t {
#if __x86_64__
    // *offset was originally 64-bit on some x86_64 platforms.
    // We read and write only 32 bits of it.
    // Some metadata provides all 64 bits. This is harmless for unsigned 
    // little-endian values.
    // Some code uses all 64 bits. class_addIvar() over-allocates the 
    // offset for their benefit.
#endif
    int32_t *offset;
    const char *name;
    const char *type;
    // alignment is sometimes -1; use alignment() instead
    uint32_t alignment_raw;
    uint32_t size;

    uint32_t alignment() const {
        if (alignment_raw == ~(uint32_t)0) return 1U << WORD_SHIFT;
        return 1 << alignment_raw;
    }
};

struct property_t {
    const char *name;
    const char *attributes;
};

struct protocol_t : objc_object {
    const char *mangledName;
    struct protocol_list_t *protocols;
    method_list_t *instanceMethods;
    method_list_t *classMethods;
    method_list_t *optionalInstanceMethods;
    method_list_t *optionalClassMethods;
    property_list_t *instanceProperties;
    uint32_t size;   // sizeof(protocol_t)
    uint32_t flags;
    // Fields below this point are not always present on disk.
    const char **_extendedMethodTypes;
    const char *_demangledName;
    property_list_t *_classProperties;
}

struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags

    class_rw_t *data() const {
        return bits.data();
    }
}

struct category_t {
    const char *name;
    classref_t cls;
    struct method_list_t *instanceMethods;
    struct method_list_t *classMethods;
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
    // Fields below this point are not always present on disk.
    struct property_list_t *_classProperties;

    method_list_t *methodsForMeta(bool isMeta) {
        if (isMeta) return classMethods;
        else return instanceMethods;
    }

    property_list_t *propertiesForMeta(bool isMeta, struct header_info *hi);
    
    protocol_list_t *protocolsForMeta(bool isMeta) {
        if (isMeta) return nullptr;
        else return protocols;
    }
};
```
```
/*
objc_msgSend的C语言版本伪代码实现.
receiver: 是调用方法的对象
op: 是要调用的方法名称字符串
*/
id  objc_msgSend(id receiver, SEL op, ...)
{

    //1............................ 对象空值判断。
    //如果传入的对象是nil则直接返回nil
    if (receiver == nil)
        return nil;
    
   //2............................ 获取或者构造对象的isa数据。
    void *isa = NULL;
    //如果对象的地址最高位为0则表明是普通的OC对象，否则就是Tagged Pointer类型的对象
    if ((receiver & 0x8000000000000000) == 0) {
        struct objc_object  *ocobj = (struct objc_object*) receiver;
        isa = ocobj->isa;
    }
    else { //Tagged Pointer类型的对象中没有直接保存isa数据，所以需要特殊处理来查找对应的isa数据。
        
        //如果对象地址的最高4位为0xF, 那么表示是一个用户自定义扩展的Tagged Pointer类型对象
        if (((NSUInteger) receiver) >= 0xf000000000000000) {
            
            //自定义扩展的Tagged Pointer类型对象中的52-59位保存的是一个全局扩展Tagged Pointer类数组的索引值。
            int  classidx = (receiver & 0xFF0000000000000) >> 52
            isa =  objc_debug_taggedpointer_ext_classes[classidx];
        }
        else {
            
            //系统自带的Tagged Pointer类型对象中的60-63位保存的是一个全局Tagged Pointer类数组的索引值。
            int classidx = ((NSUInteger) receiver) >> 60;
            isa  =  objc_debug_taggedpointer_classes[classidx];
        }
    }
    
   //因为内存地址对齐的原因和虚拟内存空间的约束原因，
   //以及isa定义的原因需要将isa与上0xffffffff8才能得到对象所属的Class对象。
    struct objc_class  *cls = (struct objc_class *)(isa & 0xffffffff8);
    
   //3............................ 遍历缓存哈希桶并查找缓存中的方法实现。
    IMP  imp = NULL;
    //cmd与cache中的mask进行与计算得到哈希桶中的索引，来查找方法是否已经放入缓存cache哈希桶中。
    int index =  cls->cache.mask & op;
    while (true) {
        
        //如果缓存哈希桶中命中了对应的方法实现，则保存到imp中并退出循环。
        if (cls->cache.buckets[index].key == op) {
              imp = cls->cache.buckets[index].imp;
              break;
        }
        
        //方法实现并没有被缓存，并且对应的桶的数据是空的就退出循环
        if (cls->cache.buckets[index].key == NULL) {
             break;
        }
        
        //如果哈希桶中对应的项已经被占用但是又不是要执行的方法，则通过开地址法来继续寻找缓存该方法的桶。
        if (index == 0) {
            index = cls->cache.mask;  //从尾部寻找
        }
        else {
            index--;   //索引减1继续寻找。
        }
    } /*end while*/

   //4............................ 执行方法实现或方法未命中缓存处理函数
    if (imp != NULL)
         return imp(receiver, op,  ...); //这里的... 是指传递给objc_msgSend的OC方法中的参数。
    else
         return objc_msgSend_uncached(receiver, op, cls, ...);
}

/*
  方法未命中缓存处理函数：objc_msgSend_uncached的C语言版本伪代码实现，这个函数也是用汇编语言编写。
*/
id objc_msgSend_uncached(id receiver, SEL op, struct objc_class *cls)
{
   //这个函数很简单就是直接调用了_class_lookupMethodAndLoadCache3 来查找方法并缓存到struct objc_class中的cache中，最后再返回IMP类型。
  IMP  imp =   _class_lookupMethodAndLoadCache3(receiver, op, cls);
  return imp(receiver, op, ....);
}
```
