implementation module TableData

import TableData
import iTasks.UI.Editor.Builtin
import qualified Data.Map as M

// A table without headers
instance TableData [[a]] | iTask a where
  htmlTable data = TableTag [ClassAttr "customTable"]
    [ TrTag []
        [ TdTag [] [Text (toSingleLineText element)]
        \\ element <- row
        ]
    \\ row <- data
    ]
  appendTable left right = [ lRow ++ rRow \\ lRow <- left & rRow <- right ]

// A table with headers
instance TableData ([a], [[b]]) | iTask a & iTask b where
  htmlTable (headers, data) = TableTag [ClassAttr "customTable"] (headerTags ++ rowTags)
    where
    headerTags =
      [ TrTag []
          [ ThTag [] [Text (toSingleLineText header)]
          \\ header <- headers
          ]
      ]
    rowTags =
      [ TrTag []
          [ TdTag [] [Text (toSingleLineText element)]
          \\ element <- row
          ]
      \\ row <- data
      ]
   appendTable (leftHeaders, leftRows) (rightHeaders, rightRows) = (bothHeaders, bothRows)
     where
     bothHeaders = leftHeaders ++ rightHeaders
     bothRows = [ lRow ++ rRow \\ lRow <- leftRows & rRow <- rightRows ]

// A table with headers where columns and rows can have css classes
instance TableData ([a], [Maybe String], [([b], Maybe String)]) | iTask a & iTask b where
  htmlTable (headers, columns, rows) = TableTag [ClassAttr "customTable"]
    (colTags ++ headerTags ++ rowTags)
    where
    colTags =
      [ ColTag (maybe [] (\columnClass -> [ClassAttr columnClass]) mColumnClass) []
      \\ mColumnClass <- columns
      ]
    headerTags =
      [ TrTag []
          [ ThTag [] [Text (toSingleLineText header)]
          \\ header <- headers
          ]
      ]
    rowTags =
      [ TrTag (maybe [] (\rowClass -> [ClassAttr rowClass]) mRowClass)
          [ TdTag [] [Text (toSingleLineText element)]
          \\ element <- row
          ]
      \\ (row, mRowClass) <- rows
      ]
   appendTable (lHeaders, lColClasses, lRows) (rHeaders, rColClasses, rRows) =
     (bothHeaders, bothColClasses, bothRows)
     where
     bothHeaders = lHeaders ++ rHeaders
     bothColClasses = lColClasses ++ rColClasses
     bothRows =
       [ (lRow ++ rRow, combineRowClasses lClass rClass)
       \\ (lRow, lClass) <- lRows
        & (rRow, rClass) <- rRows
       ]
     combineRowClasses Nothing Nothing = Nothing
     combineRowClasses l=:(Just _) Nothing = l
     combineRowClasses Nothing r=:(Just _) = r
     combineRowClasses (Just lClass) (Just rClass) = Just (lClass +++ " " +++ rClass)

viewAsTable :: !d !m -> (Task m) | toPrompt d & TableData m & iTask m
viewAsTable desc data = viewInformation desc [ViewUsing htmlTable (htmlView 'M'.newMap)] data
