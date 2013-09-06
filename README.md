
# PatternMatcher.cfc

by [Ben Nadel][1] (on [Google+][2])

ColdFusion is built on top of Java. And, while ColdFusion comes with some 
pretty decent Regular Expression support, it's not nearly as robust or as fast
as the Regular Expression libraries provided by the underlying Java code-base.
But, the Java layer is not the easiest to work with; there's a lot of ceremony
around type-casting and object creation. As such, I wanted to make a ColdFusion
component - PatternMatcher.cfc - that would encapsulate the Java interactions,
while still providing a powerful pattern-matching interface.

I [blogged about this idea][3] a few years ago; but, I have now rewritten the 
previous ColdFusion component using CFScript and move it over to GitHub. The 
component is intended to be instantiated with both a Regular Expression pattern
and an input:

* init( pattern, input )

... and, since it's using Java under the hood, it means that your Regular 
Expression patterns can use powerful constructs like negative look-behinds. 
Once instantiated, the PatternMatcher.cfc component provides three sets of 
methods: 

## Batch Replacement

Since the PatternMatcher.cfc required a Regular Expression pattern as part of
it's construction, the batch replacement methods only need a replacement value
- they will use the embedded pattern to find matches.

* replaceAll( replacement ) :: String
* replaceAllQuoted( replacement ) :: String
* replaceFirst( replacement ) :: String
* replaceFirstQuoted( replacement ) :: String

## Per-Match Replacement

If you want to iterate over each match and deal with the replacements on a
per-match basis, you can use the following methods:

* findNextMatch() :: Boolean
* group( index ) :: String
* groupCount() :: Numeric
* groups() :: Struct
* hasGroup( index ) :: Boolean
* replaceMatch( replacement ) :: Any
* replaceMatchQuoted( replacement ) :: Any
* result() :: String

## Batch Extraction

If you don't care about replacing values but, rather, want to extract values,
you can use the following methods:

* match() :: Array(String)
* matchGroups() :: Array(Struct)

Both of these methods gather all of the pattern matches within the given input;
however, the matchGroups() method returns each result as a struct, broken up by
group where as the match() method simply returns each result as a string.


[1]: http://www.bennadel.com
[2]: https://plus.google.com/108976367067760160494?rel=author
[3]: http://www.bennadel.com/blog/2097-PatternMatcher-cfc-A-ColdFusion-Component-Wrapper-For-The-Java-Regular-Expression-Engine.htm