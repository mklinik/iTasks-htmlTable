module Main

import iTasks
import TableData
import iTasks.UI.Editor.Builtin
import qualified Data.Map as M

Start world = startEngine viewSharedStoreAsTable world

simpleData =
  [ [ 10, 20, 30 ]
  , [ 11, 21, 31 ]
  , [ 12, 22, 32 ]
  , [ 13, 23, 33 ]
  ]

dataWithHeader =
  ( [ "A", "B", "C" ]
  , [ [ 10, 20, 30 ]
    , [ 11, 21, 31 ]
    , [ 12, 22, 32 ]
    , [ 13, 23, 33 ]
    ]
  )

dataWithClasses :: ([String], [Maybe String], [([Int], Maybe String)])
dataWithClasses =
  ( [ "A", "B", "C" ]
  , [Just "a", Just "b", Just "c"]
  , [ ([ 1234985253, 3409583045983, 30 ], Just "ruDarkRedBg")
    , ([ 1234985253, 3409583045983, 30 ], Just "ruDiepRedBg")
    , ([ 1234985253, 3409583045983, 30 ], Just "ruRedBg")
    , ([ 1234985253, 3409583045983, 31 ], Just "ruOrangeBg")
    , ([ 1234985253, 3409583045983, 32 ], Just "ruDarkYellowBg")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruBlueBg")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruBlueBg70")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPurpleBg")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPurpleBg70")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruGreenBg")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruGreenBg70")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPinkBg")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPinkBg70")

    , ([ 0, 0, 0 ], Nothing)

    , ([ 1234985253, 3409583045983, 30 ], Just "ruDarkRedBg whiteText")
    , ([ 1234985253, 3409583045983, 30 ], Just "ruDiepRedBg whiteText")
    , ([ 1234985253, 3409583045983, 30 ], Just "ruRedBg whiteText")
    , ([ 1234985253, 3409583045983, 31 ], Just "ruOrangeBg whiteText")
    , ([ 1234985253, 3409583045983, 32 ], Just "ruDarkYellowBg whiteText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruBlueBg whiteText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPurpleBg whiteText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruGreenBg whiteText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruGreenBg35 whiteText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPinkBg whiteText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPinkBg35 whiteText")

    , ([ 0, 0, 0 ], Nothing)

    , ([ 1234985253, 3409583045983, 30 ], Just "ruDarkRedText")
    , ([ 1234985253, 3409583045983, 30 ], Just "ruDiepRedText")
    , ([ 1234985253, 3409583045983, 30 ], Just "ruRedText")
    , ([ 1234985253, 3409583045983, 31 ], Just "ruOrangeText")
    , ([ 1234985253, 3409583045983, 32 ], Just "ruDarkYellowText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruBlueText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruBlueText35")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPurpleText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruGreenText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruGreenText35")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPinkText")
    , ([ 1234985253, 3409583045983, 33 ], Just "ruPinkText35")
    ]
  )

:: Burger =
  { bsn :: String
  , address :: Address
  }

:: Address =
  { postcode :: String
  , huisnummer :: Int
  }

derive class iTask Address, Burger

burgerData =
  [ {Burger|bsn="9342857154387", address={Address|postcode="1234AB", huisnummer=17} }
  , {Burger|bsn="1085034958209", address={Address|postcode="4567XY", huisnummer=182} }
  , {Burger|bsn="2457260345737", address={Address|postcode="8439DC", huisnummer=65535} }
  ]

burgersToTableData burgers =
  ( ["BSN", "Postcode", "Huisnummer"]
  , [ [bsn, postcode, toSingleLineText huisnummer ]
    \\ {bsn, address={postcode, huisnummer}} <- burgers
    ]
  )

main :: Task ()
main = (viewAsTable "simple table" simpleData)
  -&&- (viewAsTable "table with headers" dataWithHeader)
  -&&- (viewAsTable "data from records" (burgersToTableData burgerData))
  -&&- (viewAsTable "customizable rows and columns"
    ( ["BSN", "Postcode", "Huisnummer"]
    , [Just "smallColumn", Nothing, Just "huisnummerCol"]
    , [ ( [bsn, postcode, toSingleLineText huisnummer]
        , if (huisnummer > 100 && huisnummer < 2000) (Just "ruBlueBg70") Nothing
        )
      \\ {bsn, address={postcode, huisnummer}} <- burgerData
      ]
    ))
  -&&- (viewAsTable "The Radboud Rainbow" dataWithClasses)
  >>| return ()


burgers :: Shared [Burger]
burgers = sharedStore "burgers" burgerData

viewSharedStoreAsTable =
  viewSharedInformation () [ViewUsing (htmlTable o burgersToTableData) (htmlView 'M'.newMap)] burgers
  // Editing the table is not supported.
  -&&- updateSharedInformation () [] burgers
