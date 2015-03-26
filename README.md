# templates

Test the how {.immediate.}, {.inject.}, {.gensym.} work

{.dirty.} is the same as using {.inject.} for all items
in the template.

Here's what I know so far:
 ordinaryTemplate: from inside NOT available, strg0
 ordinaryTemplate: from top-level NOT available, strg0
 ordinaryTemplateWithInject: from inside NOT available, strg1
 ordinaryTemplateWithInject: from top-level is available, strg1=ok
 immediateTemplate: from inside NOT available, strg2
 immediateTemplate: from top-level NOT available, strg2
 immediateTemplateWithInject: from inside is available, strg3ok
 immediateTemplateWithInject: from top-level is available, strg3=ok
 immediateTemplateWithInjectBlock: from inside is available, strg4=ok
 immediateTemplateWithInjectBlock: from top-level NOT available, strg4
