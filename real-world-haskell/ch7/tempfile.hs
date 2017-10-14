import System.IO
import System.Directory (getTemporaryDirectory, removeFile)
import System.IO.Error (catchIOError)
import Control.Exception (finally)

-- The main entry point. Work with a temp file in myAction
main :: IO ()
main = withTempFile "mytemp.txt" myAction

{- The guts of the program. Called with the path and handle of a temporary
   file. When this function exists, that file will be closed and deleted
   because myActon was called from withTempFile. -}
myAction :: FilePath -> Handle -> IO ()
myAction tempname temph = do --start by displaying a greeting
    putStrLn "Welcome to tempfile.hs"
    putStrLn $ "I have a temporary file at " ++ tempname

    -- Lets see what the initial position is
    pos <- hTell temph
    putStrLn $ "My initial position is " ++ show pos

    -- Now, write some data to the temporary file
    let tempdata = show [1..10]
    putStrLn $ "Writing one line containing " ++
               show (length tempdata) ++ "bytes: " ++
               tempdata
    hPutStrLn temph tempdata

    {- get our new position. This doesn't actually modify pos
       in memory, but makes the name "pos" correspond to a different
       value for the remainder of the do "do" block. -}
    pos <- hTell temph
    putStrLn $ "After writing, my new positio is " ++ show pos

    -- Seek to the beginning of the file and display it
    putStrLn $ "The file content is: "
    hSeek temph AbsoluteSeek 0

    -- hGetContents performs a lazy read of the entire file
    c <- hGetContents temph

    -- Copy the file byte-for-byte to stdout, followed by \n
    putStrLn c

    -- Let's also display it as a haskell literal
    putStrLn $ "Which could be expressed as this haskell literal:"
    print c

{- This function takes two parameters: a filename pattern and another
   function. It will create a temporary file, and pass the name and Handle
   of that file to the given funvtion.

   The temporary file is created with openTempFile. The directory is the one
   indicated by getTemporaryDirectory, or, if the system has no notion of
   a temporary directory, "." is used. The given pattern is passed to
   openTempFile.

    After the given function terminates, even if it terminates due to and
    exception, the Handle is closed and the file is deleted. -}
withTempFile :: String -> (FilePath -> Handle -> IO a) -> IO a
withTempFile pattern func = do
    -- The library ref says that getTemporary directory may raise an
    -- exception on systems that have no notion of a temporary directory.
    -- So, we run getTemporaryDirectory under catch. chatch takes
    -- two functions: one to run, and a different one to run if the
    -- first raised an exception. If getTemporaryDirectroy raised an exception
    -- just use "."
    tempdir <- catchIOError (getTemporaryDirectory) (\_ -> return ".")
    (tempfile, temph) <- openTempFile tempdir pattern

    -- Call (func tempfile temph) to perform the action on the temporary
    -- file. finally takes two actions. The first is the action to run.
    -- The second is an action to run after the first, regardless of
    -- whether the first action raised an exeption. This way, we ensure
    -- the temporary file is always deleted. The return value from finally
    -- is the first action's return value
    finally (func tempfile temph)
            (do hClose temph
                removeFile tempfile)
