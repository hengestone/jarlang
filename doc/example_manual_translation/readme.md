# Design Decisions & Explanations

The following conversion of a toy erlang program aims to demonstrate how
we could potentially model erlang style modules, exports and function
'overloading' or uniqueness based on argument cardinality.

Essentially, each module is saved to an object based on the modules name
so given the line:

```erlang
-module(test).
```

We create an object via the following form:

```javascript
const test = (function(){ 
    const exports = { ... };
    ... 
    return exports;
})();
```

This pattern in JavaScript creates a closure where we define functions. 
Functions within the closure will remain invisible to the public, mimicking
what is essentially a private method.

Public methods are exposed via the exports object which again is based off 
Erlang's export line:

```erlang
-export([funcone/1, functwo/3]).
```

Which may generate something which looks like this:

```javascript
const exports = {
    funcone: function() {
        switch(arguments.length) {
            case 0 : ...
            case 1 : ...
            ...
            default :
                throw ("** exception error: undefined function" + 
                        "test:funcone/arguments.length");
        }
    }
}
```

We do it in the form above because JavaScript doesn't support function
overloading and thus we must essentially make calls to hidden functions
based on the number of arguments provided. If more complex guards are
given such as via pattern matching then substituting the switch statement
for an if statement will work just as well as shown in some cases in the
test program.

It is important however, that the exports object not contain functions
meant to be exported, but instead functions which wrap the function
intended to be called. This is because private, non-exported functions
may also have overloaded forms.

For tidyness then, and because it seems like the most logical way of doing
it, the exports module should expose otherwise private functions in
a datastructure stored within our closure which should look like:

```javascript
const functions = {
    functionname: {
        1: function(A) { ... },
        2: function(A, B) { ... },
        5: function(A, B, C, D, E) { ... },
    }
}
```

Each entry in the functions object is keyed by function name, which itself
is keyed by cardinality. Each function keyed by cardinality should perform
additional guard tests and run the correct code based on said guards.

Functions defined within the functions object can reference other functions
via simply calling them manually via the reference to the functions object
like this:

```javascript
functions[functwo][2](arg1, arg2);
```

Lastly, for any additional information which isn't clear, raise an issue
or something :) Or simply read through the test program.

The test program utilises this datastructure rather successfully with
seemingly little overhead in Chrome and Firefox, with no optimisations
done to the recursion.

I'm unsure how we would logically manually remove the recursion and replace
with a loop cleanly at the moment but we can leave optimisations until later.


Anyhow, run the test program via the following for Erlang (in the shell):

```erlang 
c("nnbottles.erl").
nnbottles:sing().
```

Or for JavaScript (in the console):

```javascript
*run closure*
nnbottles.sing();
```

Thanks :)
Chris.
