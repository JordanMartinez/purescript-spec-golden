module Test.Spec.Assertions.Golden where

import Prelude

import Data.Either (blush)
import Data.Maybe (Maybe)
import Data.Traversable (for_)
import Effect.Aff (Aff)
import Node.Library.Execa (ExecaError, execa)
import Node.Path (FilePath)
import Test.Spec.Assertions (fail)

-- | Fails the test if the text content does not exactly equal the content stored in the file.
-- | Example: `"foo" `shouldEqual` "path/to/file/containing/foo.txt"`
-- |
-- | Note: uses `diff` under the hood.
shouldEqualFile :: String -> FilePath -> Aff Unit
shouldEqualFile actual expectedFilePath = do
  result <- shouldEqualFile' actual expectedFilePath
  for_ result \e -> fail $ "\n" <> e.stdout

-- | Fails the test if the first file's content does not equal the second file's content.
-- | Example: `"snapshot/foo.txt" `shouldEqual` "snapshot-out/foo.out"`
shouldEqualFixture :: FilePath -> FilePath -> Aff Unit
shouldEqualFixture left right = do
  result <- shouldEqualFixture' left right
  for_ result \e -> fail $ "\n" <> e.stdout

-- | A variant of `shouldEqualFile'`.
-- | - `Nothing` = contents are the same
-- | - `Just _` = contents are different / calling `diff` encountered a problem
shouldEqualFile' :: String -> FilePath -> Aff (Maybe ExecaError)
shouldEqualFile' actual expectedFilePath = do
  cp <- execa "diff" [ "-u", "-", expectedFilePath ] identity
  cp.stdin.writeUtf8End actual
  map blush cp.result

-- | A variant of `shouldEqualFixture'`.
-- | - `Nothing` = files' contents are the same
-- | - `Just _` = files' contents are different / calling `diff` encountered a problem
shouldEqualFixture' :: FilePath -> FilePath -> Aff (Maybe ExecaError)
shouldEqualFixture' left right = do
  cp <- execa "diff" [ "-u", left, right ] identity
  map blush cp.result
