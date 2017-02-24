## Export all localization strings

1. Go to this directory in `Terminal`.
2. Execute the following.
````
find ./ -name "**.m" -print0 | xargs -0 genstrings -s PWLocalizedString -a -o .
````
3. The `Localizable.strings` should be generated in current directory.