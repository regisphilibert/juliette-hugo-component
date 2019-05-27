## [0.3.0] (unrelease)

This is a major release. 
If you're using custom transformers, it comes with pleasant **breaking changes**.

We drop Pages' `.Scratch` to handle data processing in favor of the new `return` syntax available for partials since Hugo 0.55.0

- [x] Rewrite transformers and "prepareSingle/prepareList" partials to use the new `return` syntax and local Scratch.
- [x] Move all the partials to a more "reserved" `juliette` directory
- [x] Rename partial and revert to using `.html` extension
- [x] Change tab size 2 spaces.
- [x] Add commenting
- [ ] Rewrite `formatURl.tpl`
- [ ] Improve Pagination logic now that output formats limitations have been lifted by .55.0
- [ ] Add an upgrade guide to the README

## [0.2.0] - 2019-03-08 (@regisphilibert)  

  - Add built-in XML output