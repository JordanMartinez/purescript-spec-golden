module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FSA
import Node.Path as Path
import Test.Spec (it)
import Test.Spec.Assertions (fail)
import Test.Spec.Golden.Assertions (shouldEqualFile, shouldEqualFixture, shouldEqualFixture')
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = do
  launchAff_ $ runSpec [ consoleReporter ] do
    let fixturesPath = Path.concat [ "test", "fixtures" ]
    it "A test that checks a file with itself succeeds" do
      let filePath = Path.concat [ fixturesPath, "foo.txt" ]
      content <- FSA.readTextFile UTF8 filePath
      content `shouldEqualFile` filePath
    it "A test that checks two equal files succeeds" do
      let filePath = Path.concat [ fixturesPath, "same.txt" ]
      filePath `shouldEqualFixture` filePath
    it "A test that checks two non-equal files fails" do
      let
        l = Path.concat [ fixturesPath, "same.txt" ]
        r = Path.concat [ fixturesPath, "different.txt" ]
      result <- l `shouldEqualFixture'` r
      case result of
        Just _ -> pure unit
        Nothing -> fail $ "Files should be different"

