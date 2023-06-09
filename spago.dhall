{ name = "spec-golden"
, dependencies =
  [ "aff"
  , "either"
  , "foldable-traversable"
  , "maybe"
  , "node-execa"
  , "node-path"
  , "prelude"
  , "spec"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
}
