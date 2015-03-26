import templates
#import cmdargsopts
import unittest

#parseCmdArgsOpts()

template outer(name: string, outerBody: stmt): stmt {.immediate.} =
  block:
    var oName {.inject.} = name

    # The implementation of outerSetup/Teardown when invoked by inner
    template outerSetupImpl*: stmt = discard
    template outerTeardownImpl*: stmt = discard

    # Allow overriding of outerSetup/TeardownImpl
    template outerSetup*(setupBody: stmt): stmt {.immediate.} = # {.immediate.} makes {.inject.}'s availabe to setupBody
      template outerSetupImpl*: stmt = setupBody
    template outerTeardown*(teardownBody: stmt): stmt {.immediate.} = # {.immediate.} makes {.inject.}'s available to teardownBody
      template outerTeardownImpl*: stmt = teardownBody

    # The inner template runs innerBody and supports optional setup/teardown. It
    # also catches exceptions
    template inner(innerName: string, innerBody: stmt): stmt {.immediate, dirty.} = # {.dirty.} is needed so outerSetup/TeardownImpl are invokable???
      block:
        var iName {.inject.} = innerName # This must be {.inject.} to be available to innerBody even with {.dirty.}???
        try:
          echo oName, ".", iName
          outerSetupImpl()
          innerBody
        except:
          echo "except: ", oName, ".", iName, "e=", getCurrentExceptionMsg()
        finally:
          outerTeardownImpl()

    outerBody

echo ""
# Define outerSetup/Teardown
outer "outer1-here":
  outerSetup:
    echo "outer1Setup: ", oName, ".", iName
  outerTeardown:
    echo "outer1Teardown: ", oName, ".", iName
  inner "inner1-here":
    echo "inner1-here: ", oName, ".", iName
echo ""

# Redefine outerSetup/Teardown
outer "outer2-here":
  outerSetup:
    echo "inner2Setup"
  outerTeardown:
    echo "inner2Teardown"
  inner "inner2-here":
    echo "do'n inner2"
echo ""

# Should default to no outerSetup/Teardown
outer "outer3-here":
  inner "inner3-here":
    echo "do'n inner3"
echo ""

suite "test1Suite":
  setup:
    echo "test1Setup"
  teardown:
    echo "test1Teardown"
  test "test1":
    echo "test1"
echo ""

suite "test2Suite":
  teardown:
    echo "test2Teardown"
  test "test2":
    echo "test2"
echo ""

test "test3-outer-standalone":
  echo "test3"

when true:
  # Ordinary templates do NOT make any items available to the body or
  # outside without the use of {.inject.} or {.dirty.}
  template ordinaryTemplate(name: string, body: stmt): stmt =
    block:
      var strg0 = name
      body

  ordinaryTemplate "ordinaryTemplate":
    echo "ordinaryTemplate: from inside NOT available, strg0"

  echo "ordinaryTemplate: from top-level NOT available, strg0"

when true:
  # Ordinary templates with {.inject.} or {.dirty.} inject into outer scope
  # but not into the body: stmt
  template ordinaryTemplateWithInject(name: string, body: stmt): stmt =
    var strg1 {.inject.} = "ok"
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
  # Immediate templates with inject and block are available internally and body: stmt
  # but NOT available to outer
  template immediateTemplateWithInjectBlock(name: string, body: stmt): stmt {.immediate.} =
    block:
      var strg4 {.inject.} = "ok"
      body

  immediateTemplateWithInjectBlock "immediateTemplateWithInjectBlock":
    echo "immediateTemplateWithInjectBlock: from inside is available, strg4=", strg4

  echo "immediateTemplateWithInjectBlock: from top-level NOT available, strg4"
