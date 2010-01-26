= munkres

http://github.com/pdamer/munkres

== DESCRIPTION:

A ruby implementation of the kuhn-munkres or 'hungarian' algorithm for bipartite matching.

== FEATURES/PROBLEMS:

Match groups together 1 to 1 

== SYNOPSIS:

Create a 2d matrix joining your two groups to match with each entry 
being the cost of matching the corresponding members of the groups

  require 'munkres'

  cost_matrix = [[4,3],
                 [3,0]]
                 
  m = Munkres.new(cost_matrix)
  p m.find_pairings


== REQUIREMENTS:

Uses test/spec for testing.

== INSTALL:

sudo gem install munkres

== DEVELOPERS:

After checking out the source, run:

  $ rake test

== LICENSE:

(The MIT License)

Copyright (c) 2010

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
