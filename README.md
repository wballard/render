# Overview #

Render! Turn those pesky yaml and json files into other exciting strings
from your command line by running them through a template language.

# Templates Supported #

The most basic usage, `render` will figure out what to do based on the
extension of the template. And will try to parse as yaml, which will
accept json as well.

## Handlebars ##

Render a template, nice and easy.

```
cat some.yaml | render some.handlebars
```

And, supports helper functions, telling it the name of a module to
`require`.

```
cat some.yaml | render --require helpers withhelpers.handlebars
```

This will search for _helpers_ with a normal node `require` statements,
so you can feed it relative paths. Supports JavaScript and CoffeeScript
modules. Inside the module, all exported functions will be sent along to
`Handlebars.registerHelper` by name. Saves you typing,
`Handlebars.registerHelper` so much. Doh!, I just typed it twice ...
