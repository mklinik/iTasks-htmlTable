definition module TableData

import iTasks
import Text.HTML

class TableData a where
  htmlTable :: a -> HtmlTag

// Convenience function for viewing table data directly.
//
// If you need to transform your data to table data, do as follows.
//
//   viewInformation () [ViewUsing (htmlTable o myDataToTableData) (htmlView 'M'.newMap)] myData
//     where myDataToTableData = ...
//
// Or, for shared data:
//
//   viewSharedInformation () [ViewUsing (htmlTable o myDataToTableData) (htmlView 'M'.newMap)] myShare
//     where myDataToTableData = ...
viewAsTable :: !d !m -> (Task m) | toPrompt d & TableData m & iTask m

// A table without headers
instance TableData [[a]] | iTask a

// A table with headers
//  ( [a]   // column headers
//  , [[b]] // row data
//  )
instance TableData ([a], [[b]]) | iTask a & iTask b

// A table with headers where columns and rows can have css classes
//  ( [a]                // column headers
//  , [Maybe String]     // column classes
//  , [ ( [b]            // row data
//      , Maybe String   // row class
//      )
//    ]
//  )
instance TableData ([a], [Maybe String], [([b], Maybe String)]) | iTask a & iTask b
