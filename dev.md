---
layout: default
title: Development
---

This document outlines how to contribute code to the CNDP project.

## Getting the code

The CNDP code can be cloned from the repository on GitHub:

``` bash
git clone https://github.com/CloudNativeDataPlane/cndp.git
```

## Submitting Patches

Use Github Pull requests to change CNDP.

## Coding Guidelines

C code should follow the CNDP coding standards.

A .clang-format is available in the CNDP repo and can be run with ``clang-format``
or ``ninja clang-format``. A pre-commit hook is also available and can be used to
apply the clang format to modified files in a commit. The pre-commit hook also runs
``gofmt`` for modified .go files, and runs ``tools/check_json.py`` for modified
.jsonc files.

Install clang-format:

``` bash
sudo apt-get install -y clang-format
```

A .clang-format file is available in the CNDP repo and can be run with ninja:

``` bash
ninja -C builddir clang-format
```

Or with git clang-format if it is installed, for example:

``` bash
git clang-format --diff
```

If committing changes to the .go or .jsonc files:

``` bash
sudo apt-get -y golang
pip install jsonc-parser jsonschema
```

Install the pre-commit hook before committing changes:

``` bash
cp .githooks/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```

Guidelines for public or private APIs is to hide as much of the internal API
from the developer. Which means we need to label function prototypes as public
using the CNDP_API macro. The macro is defined as

``` c
#define CNDP_API __attribute__((visibility("default")))
```

And used in this way:

``` c
CNDP_API int cne_init();
```

We also use function versioning macros to allow for build time function
linking using the following APIs:

``` c
#ifdef CNE_BUILD_SHARED_LIBS
#define FUNCTION_VERSION(internal, api, ver) __asm__(".symver " #internal ", " #api "@" #ver)
#define DEFAULT_VERSION(internal, api, ver)  __asm__(".symver " #internal ", " #api "@@" #ver)
#else
#define FUNCTION_VERSION(internal, api, ver)
#define DEFAULT_VERSION(internal, api, ver)
#endif
```

To hide internal APIs we have public and private headers. The public headers are installed
in the system, but the private headers are not. The public headers should use typedefs
to hide the internal structures by:

``` c
typedef void foo_t;
foo_t *foo;
```

where the structure may be

``` c
struct foo {
  int bar;
};
```

Do not hide the '\*' type inside the typedef.

This requires the public APIs to only return void pointers and the public functions are passed
these void types and must cast the void pointer into the private structure pointer i.e.

{% highlight c linenos %}
int foobar(foo_t *foo) {
    struct foo *f = foo;    // Cast of foo is not required as *foo is a void *

    return 0;
}
{% endhighlight %}

Naming header files as xyz\_private.h and cne\_xyz.h is preferred. The .c files should be named
xyz.c or cne\_xyz.c.

Braces for single line statements: do not use braces where a single statement (if, while, for,
...) will do, for example:

``` c
if (foo)
    do_this();
else
    do_that();
```
