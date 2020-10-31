#  Block


>导语：使用weakSelf，strongSelf可以解决循环引用原理分析

***

在使用block过程中经常会出现循环引用的情况：

比如下面的代码：
```
  self.block = ^() {
          [self doSomething];
    };
```
因为block作为当前对象的一个属性，又强引用了该对象，导致循环引用。

解决方法一般：
```
 __weak __typeof(self) weakSelf = self;
    self.block = ^() {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf doSomething];
    };
```
但是该解决方式在block中又强引用了weakSelf，为什么没有导致循环引用呢？

之前也一直比较疑惑，后来分析了下block的源码，终于搞清楚了。

首先，我们看一下什么是block。

（1）新建一个文件，定义一个block并执行：
```
#include <stdio.h>

int main(){
    void (^blk)(void) = ^(){printf("Hello world!");};
    blk();
    return 0;
}
```
对于这个简单的block文件使用 clang -rewrite-objc hello.c 语句可以得到它对应的cpp文件，主要代码有：
```
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
printf("Hello world!");}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
int main(){
    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}
```
首先__block_impl结构体中有四个变量：其中isa表明block也有runntime的特性，isa是指向Class的指针；FuncPtr是函数指针，指向block实际执行的函数。

__main_block_impl_0结构体有两个变量：一个是__block_impl变量；一个是__main_block_desc_0变量，是对__main_block_impl_0的描述。

__main_block_func_0是一个方法，也就是调用block时执行的函数。

再看main()函数，可以看到block实际被转换成一个指向__main_block_impl_0结构体的指针，block()执行过程也就是blk->FuncPtr()的执行过程。
（2）修改一下文件中的代码：
```
#include <stdio.h>

int main(){
    int i = 0;
    void (^blk)(void) = ^(){printf("i is %d", i);};
    i++;
    blk();
    return 0;
}
```
转换成cpp文件：
```
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int i;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _i, int flags=0) : i(_i) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int i = __cself->i; // bound by copy
printf("i is %d", i);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

int main(){
    int i = 0;
    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, i));
    i++;
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}
```
和之前的代码比较可以发现，在__main_block_impl_0结构体中多了一个变量i，并且在创建block的时候i被赋值，注意int i = __cself->i; // bound by copy 所以block创建之后再修改i的值对于block的执行结果没有影响。
（3）继续修改：
```
#include <stdio.h>

int main(){
    int __block i = 0;
    void (^blk)(void) = ^(){printf("i is %d", i);};
    i++;
    blk();
    return 0;
}
```
cpp文件：
```
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

struct __Block_byref_i_0 {
  void *__isa;
__Block_byref_i_0 *__forwarding;
 int __flags;
 int __size;
 int i;
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_i_0 *i; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_i_0 *_i, int flags=0) : i(_i->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_i_0 *i = __cself->i; // bound by ref
printf("i is %d", (i->__forwarding->i));}

static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->i, (void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->i, 8/*BLOCK_FIELD_IS_BYREF*/);}
static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};

int main(){
    __Block_byref_i_0 i = {(void*)0,(__Block_byref_i_0 *)&i, 0, sizeof(__Block_byref_i_0), 0};
    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_i_0 *)&i, 570425344));
    (i.__forwarding->i)++;
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}
```
该block中包含可以修改的变量，情况相对比较复杂。只看变化比较明显的地方，此时i是通过__Block_byref_i_0 *i; // by ref 引用到外面的i值，也就是外面i值的改变是可以改变block中的i值。更深入的分析由于水平有限暂时不展开了。

所以：
```
self.block = ^() {
          [self doSomething];
    };
```

block中对于self的引用类似于上面第三种情况下block对于i值的引用，是强引用，从而导致循环引用。

回到最初的问题，为什么weakSelf，strongSelf的使用可以解决循环引用的问题：

weakSelf是对当前对象的弱引用，block中会引用weakSelf而避免强引用到当前对象，解决了循环引用，这点比较容易理解。

stongSelf也确实会导致对当前对象的强引用，但是注意strongSelf只有在block的执行过程中有效！！！也就是strongSelf是防止在block执行过程中对象被销毁，避免引发一些问题。当block执行结束后，strongSelf也就被释放了，从而也不会导致循环引用，有点类似临时变量的效果。当然，如果block没有执行，则strongSelf也不会存在。

比如A对象中有一个block，并且使用weakSelf，strongSelf解决循环引用：

（1）A对象要释放，此时block没有执行：A可以很自然的释放，没有任何压力；

（2）A对象要释放，此时block正在执行：A在block执行中还被强引用着，导致不能被释放，block执行结束，最后强引用到A的变量strongSelf被释放，A也被释放。


# 补充

Hello.h
```
typedef void(^HelloBlock)(void);

@interface Hello : NSObject

@property(nonatomic, copy) HelloBlock block;
@property(nonatomic, copy) NSString *name;

@end
```

main.m
```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Hello *hello = [[Hello alloc] init];
//        __weak __typeof(hello) weakHello = hello;
        hello.block = ^{
//            __strong __typeof(hello) strongHello = weakHello;
            NSLog(@"Hello world.%@", hello.name);
        };
        hello.block();
    }
    return 0;
}
```

```
clang -rewrite-objc main.m

weak 需要运行时环境的支持。（weak的原理可以探究一下）
clang -rewrite-objc -fobjc-arc -fobjc-runtime=macosx-10.15 main.m
```

## normal
```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {

            NSLog((NSString *)&__NSConstantStringImpl__var_folders_9n__36yg7qd5vj3gq4ck3m57nxh0000gn_T_main_695e09_mi_0);
        }

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        Hello *hello = ((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Hello"), sel_registerName("alloc")), sel_registerName("init"));
        ((void (*)(id, SEL, HelloBlock _Nonnull))(void *)objc_msgSend)((id)hello, sel_registerName("setBlock:"), ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA)));
        ((HelloBlock (*)(id, SEL))(void *)objc_msgSend)((id)hello, sel_registerName("block"))();
    }
    return 0;
}
```


## strong
```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  Hello *sHello;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Hello *_sHello, int flags=0) : sHello(_sHello) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  Hello *sHello = __cself->sHello; // bound by copy

            NSLog((NSString *)&__NSConstantStringImpl__var_folders_9n__36yg7qd5vj3gq4ck3m57nxh0000gn_T_main_cc0e51_mi_0, sHello);
        }
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->sHello, (void*)src->sHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->sHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        Hello *hello = ((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Hello"), sel_registerName("alloc")), sel_registerName("init"));
        Hello *sHello = hello;
        ((void (*)(id, SEL, HelloBlock _Nonnull))(void *)objc_msgSend)((id)hello, sel_registerName("setBlock:"), ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, sHello, 570425344)));
        ((HelloBlock (*)(id, SEL))(void *)objc_msgSend)((id)hello, sel_registerName("block"))();
    }
    return 0;
}
```

## weak

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  Hello *__weak weakHello;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Hello *__weak _weakHello, int flags=0) : weakHello(_weakHello) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  Hello *__weak weakHello = __cself->weakHello; // bound by copy

            NSLog((NSString *)&__NSConstantStringImpl__var_folders_9n__36yg7qd5vj3gq4ck3m57nxh0000gn_T_main_e24bdb_mi_0, weakHello);
        }
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->weakHello, (void*)src->weakHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->weakHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        Hello *hello = ((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Hello"), sel_registerName("alloc")), sel_registerName("init"));
        __attribute__((objc_ownership(weak))) __typeof(hello) weakHello = hello;
        ((void (*)(id, SEL, HelloBlock _Nonnull))(void *)objc_msgSend)((id)hello, sel_registerName("setBlock:"), ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, weakHello, 570425344)));
        ((HelloBlock (*)(id, SEL))(void *)objc_msgSend)((id)hello, sel_registerName("block"))();
    }
    return 0;
}
```

## weak && strong
```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  Hello *__weak weakHello;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Hello *__weak _weakHello, int flags=0) : weakHello(_weakHello) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  Hello *__weak weakHello = __cself->weakHello; // bound by copy

            __attribute__((objc_ownership(strong))) __typeof(hello) strongHello = weakHello;
            NSLog((NSString *)&__NSConstantStringImpl__var_folders_9n__36yg7qd5vj3gq4ck3m57nxh0000gn_T_main_3e2ec0_mi_0, strongHello);
        }
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->weakHello, (void*)src->weakHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->weakHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        Hello *hello = ((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Hello"), sel_registerName("alloc")), sel_registerName("init"));
        __attribute__((objc_ownership(weak))) __typeof(hello) weakHello = hello;
        ((void (*)(id, SEL, HelloBlock _Nonnull))(void *)objc_msgSend)((id)hello, sel_registerName("setBlock:"), ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, weakHello, 570425344)));
        ((HelloBlock (*)(id, SEL))(void *)objc_msgSend)((id)hello, sel_registerName("block"))();
    }
    return 0;
}
```

## unsafe
```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  typeof (hello) weakHello;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, typeof (hello) _weakHello, int flags=0) : weakHello(_weakHello) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  typeof (hello) weakHello = __cself->weakHello; // bound by copy

            NSLog((NSString *)&__NSConstantStringImpl__var_folders_9n__36yg7qd5vj3gq4ck3m57nxh0000gn_T_main_9e5bf0_mi_0, weakHello);
        }
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->weakHello, (void*)src->weakHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->weakHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        Hello *hello = ((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Hello"), sel_registerName("alloc")), sel_registerName("init"));
        __attribute__((objc_ownership(none))) __typeof(hello) weakHello = hello;
        ((void (*)(id, SEL, HelloBlock _Nonnull))(void *)objc_msgSend)((id)hello, sel_registerName("setBlock:"), ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, weakHello, 570425344)));
        ((HelloBlock (*)(id, SEL))(void *)objc_msgSend)((id)hello, sel_registerName("block"))();
    }
    return 0;
}
```
## strong with a object's property

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  Hello *hello;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Hello *_hello, int flags=0) : hello(_hello) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  Hello *hello = __cself->hello; // bound by copy


            NSLog((NSString *)&__NSConstantStringImpl__var_folders_9n__36yg7qd5vj3gq4ck3m57nxh0000gn_T_main_3ea756_mi_0, ((NSString *(*)(id, SEL))(void *)objc_msgSend)((id)hello, sel_registerName("name")));
        }
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->hello, (void*)src->hello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->hello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        Hello *hello = ((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Hello"), sel_registerName("alloc")), sel_registerName("init"));

        ((void (*)(id, SEL, HelloBlock _Nonnull))(void *)objc_msgSend)((id)hello, sel_registerName("setBlock:"), ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, hello, 570425344)));
        ((HelloBlock (*)(id, SEL))(void *)objc_msgSend)((id)hello, sel_registerName("block"))();
    }
    return 0;
}
```

## strong && weak with a object's property
```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  Hello *__weak weakHello;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Hello *__weak _weakHello, int flags=0) : weakHello(_weakHello) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  Hello *__weak weakHello = __cself->weakHello; // bound by copy

            __attribute__((objc_ownership(strong))) __typeof(hello) strongHello = weakHello;
            NSLog((NSString *)&__NSConstantStringImpl__var_folders_9n__36yg7qd5vj3gq4ck3m57nxh0000gn_T_main_335f09_mi_0, ((NSString *(*)(id, SEL))(void *)objc_msgSend)((id)strongHello, sel_registerName("name")));
        }
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->weakHello, (void*)src->weakHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->weakHello, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 
        Hello *hello = ((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)((Hello *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Hello"), sel_registerName("alloc")), sel_registerName("init"));
        __attribute__((objc_ownership(weak))) __typeof(hello) weakHello = hello;
        ((void (*)(id, SEL, HelloBlock _Nonnull))(void *)objc_msgSend)((id)hello, sel_registerName("setBlock:"), ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, weakHello, 570425344)));
        ((HelloBlock (*)(id, SEL))(void *)objc_msgSend)((id)hello, sel_registerName("block"))();
    }
    return 0;
}
```
