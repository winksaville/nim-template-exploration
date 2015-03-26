import nake

const
  buildArtifacts = @["src/templates", "src/nimcache", "tests/test", "tests/nimcache", "nimcache"]
  buildFlags = "--hints:off --warnings:off"

task defaultTask, "Compile and run the tests":
  runTask "build-tests"
  runTask "run-tests"

task "build-tests", "Build the tests":
  if shell(nimExe, "c", buildFlags, "tests/test.nim"):
    echo "success"
  else:
    echo "error compiling"
    quit 1

task "run-tests", "Run the tests":
  discard shell("tests/test")

task "nake", "build the nakefile":
  if not shell("nim c", buildFlags, " nakefile"):
    echo "could not build nakefile"
    quit 1
  else:
    removeDir "nimcache"
    quit 0

task "clean", "clean build artifacts":
  for file in buildArtifacts:
    try:
      removeFile(file)
    except OSError:
      try:
        removeDir(file)
      except OSError:
        echo "Could not remove: ", file, " ", getCurrentExceptionMsg()

