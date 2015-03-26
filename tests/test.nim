import templates, cmdargsopts, unittest

parseCmdArgsOpts()

when true:
  # Ordinary templates do NOT make any items available to the body or
  # outside without the use of {.inject.} or {.dirty.}
  template ordinaryTemplate(name: string, body: stmt): stmt =
    var strg0 : string
    strg0 = "ok"
    body

  ordinaryTemplate "ordinaryTemplate":
    echo "ordinaryTemplate: from inside NOT available, strg0"

  echo "ordinaryTemplate: from top-level NOT available, strg0"

when true:
  # Ordinary templates with {.inject.} or {.dirty.} inject into outer scope
  # but not into the body: stmt
  template ordinaryTemplateWithInject(name: string, body: stmt): stmt =
    var strg1 {.inject.} : string
    strg1 = "ok"
    body

  ordinaryTemplateWithInject "ordinaryTemplateWithInject":
    echo "ordinaryTemplateWithInject: from inside NOT available, strg1"

  echo "ordinaryTemplateWithInject: from top-level is available, strg1=", strg1


when true:
  # Immediate without inject is the same as ordinary templates
  # and items are NOT available either outer or body: stmt
  template immediateTemplate(name: string, body: stmt): stmt {.immediate.} =
    var strg2 = "ok"
    body

  immediateTemplate "immediateTemplate":
    echo "immediateTemplate: from inside NOT available, strg2"

  echo "immediateTemplate: from top-level NOT available, strg2"

when true:
  # Immediate with inject items are available in both
  # outer and body: stmt
  template immediateTemplateWithInject(name: string, body: stmt): stmt {.immediate.} =
    var strg3 {.inject.} = "ok"
    body

  immediateTemplateWithInject "immediateTemplateWithInject":
    echo "immediateTemplateWithInject: from inside is available, strg3", strg3

  echo "immediateTemplateWithInject: from top-level is available, strg3=", strg3

when true:
  # Immediate templates with inject and block are available to body: stmt
  # but NOT available to outer
  template immediateTemplateWithInjectBlock(name: string, body: stmt): stmt {.immediate.} =
    block:
      var strg4 {.inject.} = "ok"
      body

  immediateTemplateWithInjectBlock "immediateTemplateWithInjectBlock":
    echo "immediateTemplateWithInjectBlock: from inside is available, strg4=", strg4

  echo "immediateTemplateWithInjectBlock: from top-level NOT available, strg4"

