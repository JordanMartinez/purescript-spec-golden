{ name = "spec-golden-tests"
, dependencies =
  [ "aff"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "maybe"
  , "node-buffer"
  , "node-execa"
  , "node-fs-aff"
  , "node-path"
  , "prelude"
  , "spec"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, license = "MIT"
}
