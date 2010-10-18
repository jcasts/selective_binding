= selective_binding

* http://github.com/yaksnrainbows/selective_binding

== DESCRIPTION:

Create Bindings with selective mappings to an object's methods and attributes.

== SYNOPSIS:

Creates a selective binding instance for self and returns
the newly created binding:

  selective_binding :attr1, :method1
  #=> <#Binding>

Passing a hash as the last argument allows for setting custom attributes.
These override any previously defined forwarded methods:

  selective_binding :attr1 => "custom value"
  #=> <#Binding>

Passing a block is also supported to set the default value for undefined
attributes or methods:

  selective_binding do
    "default value"
  end
  #=> <#Binding>

== INSTALL:

* sudo gem install selective_binding

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2010 Jeremie Castagna

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
