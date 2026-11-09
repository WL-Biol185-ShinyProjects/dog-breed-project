DOG BREED EXPLORER — SPLIT INTO SOURCE FILES

The original app.R is preserved unchanged as original_app_backup.R.
The original UI tabItem expressions, server blocks, and data setup code have been copied into separate files without changing their logic.
Only the app.R wiring was changed to load the files using source().

To run:
1. Extract the ZIP as a complete folder.
2. Open that folder as your RStudio project / working directory.
3. Put breed_temperament.csv in Data/ (or in the app root).
   It was referenced by the original app but was not included among the files provided for this conversion.
4. Run app.R as before.

To edit:
- ui/*.R: page layouts. Each contains the original tabItem() expression.
- server/*.R: the corresponding server observers, reactives and render functions.
- R/data_setup.R: the original data loading and preprocessing.
- app.R: the original dashboard shell and the source() calls.

The existing input/output IDs and computations have NOT been changed.
The existing warnings/bugs are intentionally NOT fixed.

The source(..., local=TRUE)$value pattern for UI evaluates each original tabItem() expression and returns it to tabItems(). The server source(..., local=TRUE) statements execute inside the existing server function, retaining the same input, output and session environment.

If using GitHub, merge this restructuring first and ask collaborators to pull it before editing separate pages.
