TableData
=========

An iTasks viewer for tabular data.

How to use
----------

- Copy `TableData.icl`, `TableData.dcl` and `WebPublic` to your project.
- import TableData
- Use `viewAsTable` like in the example `Main.icl`

      simpleData =
        [ [ 10, 20, 30 ]
        , [ 11, 21, 31 ]
        , [ 12, 22, 32 ]
        , [ 13, 23, 33 ]
        ]
      main = viewAsTable "simple table" simpleData
      Start world = startEngine main world

- To customize table style, modify `WebPublic/css/customTable.css`
