# Memo

This is a Swift microframework providing `Memo<T>`, with implementations of `==`/`!=` where `T`: `Equatable`.

`Memo` is a convenient way to ensure that an expression producing a value is evaluated precisely once. It can be used to lazily load expensive resources or to delay and memoize recursive evaluation to avoid infinite loops.


## Use

Constructing a `Memo` is easy. Most of the time you just want to lazily memoize an expression, so you’ll want to use the default, unlabelled initializer:

```swift
var memos = 0
let closure = Memo { ++memos }
```

Sometimes you’ll want to pass in a function `() -> T`. In those cases, use the `unevaluated` initializer:

```swift
let preIncrementMemos = { ++memos }
let lazilyEvaluated = Memo(unevaluated: preIncrementMemos)
```

Sometimes you’ve already evaluated, or you want to force the evaluation to happen with the construction of the `Memo` for performance reasons. The `evaluated` initializer handles this:

```swift
let eagerlyEvaluated = Memo(evaluated: ++memos)
```

Extract the evaluated value via the `value` property:

```swift
let value = implicitClosure.value
```

## Implementation details

`Memo` is memoized even if you copy it around before it’s evaluated. It uses immutable value type semantics, but does not leak implementation details (i.e. you do not have to hold it in a `var` to retrieve its value). It does this by means of a [private, unobservably-mutable reference type](http://intersections.tumblr.com/post/99634084704/unobservable-effects-with-value-types) which wraps the inner data.


## Documentation

API documentation is in the source.


## Integration

1. Add this repository as a submodule and check out its dependencies, and/or [add it to your Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile) if you’re using [carthage](https://github.com/Carthage/Carthage/) to manage your dependencies.
2. Drag `Memo.xcodeproj` into your project or workspace, and do the same with its dependencies (i.e. the other `.xcodeproj` files included in `Memo.xcworkspace`). NB: `Memo.xcworkspace` is for standalone development of Memo, while `Memo.xcodeproj` is for targets using Memo as a dependency.
3. Link your target against `Memo.framework` and each of the dependency frameworks.
4. Application targets should ensure that the framework gets copied into their application bundle. (Framework targets should instead require the application linking them to include Memo and its dependencies.)
