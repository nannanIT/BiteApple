#  RunLoop

https://juejin.im/post/6844903981924220936
https://www.jianshu.com/p/aa0fae8c491b

__CFRunLoopRun

does NSThread create autoreleasepool automaticly now?。我再来简单阐述下，在子线程你创建了 Pool 的话，产生的 Autorelease 对象就会交给 pool 去管理。如果你没有创建 Pool ，但是产生了 Autorelease 对象，就会调用 autoreleaseNoPage 方法。在这个方法中，会自动帮你创建一个 hotpage（hotPage 可以理解为当前正在使用的 AutoreleasePoolPage，如果你还是不理解，可以先看看 Autoreleasepool 的源代码，再来看这个问题 ），并调用 page->add(obj)将对象添加到 AutoreleasePoolPage 的栈中，也就是说你不进行手动的内存管理，也不会内存泄漏。
