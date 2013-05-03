Main command line entry point.

    docopt = require 'docopt'
    path = require 'path'
    handlebars = require 'handlebars'
    yaml = require 'js-yaml'
    fs = require 'fs'
    _ = require 'lodash'

Actual command line processing via docopt.

    require.extensions['.docopt'] = (module, filename) ->
        doc = fs.readFileSync filename, 'utf8'
        module.exports =
            options: docopt.docopt doc, version: require('../package.json').version
            help: doc
    cli = require './cli.docopt'

Full on help.

    if cli.options['--help']
        console.log cli.help

Read the template, returning a template function to use in rendering.

    renderer = (templatepath) ->
        if not fs.existsSync templatepath
            console.error "No template #{templatepath}"
            process.exit 2
        #mapping factory
        extension = path.extname(templatepath).toLowerCase().substr(1)
        factory =
            handlebars: (context) ->
                template = handlebars.compile fs.readFileSync(templatepath, 'utf8')
                template(context)
        template = factory[extension] or (context) ->
            console.error "No template renderer for #{templatepath}"
            process.exit 1

Helper functions? Load em up via require!

    if cli.options['--require']
        helperpath = path.join process.cwd(), cli.options['--require']
        helpers = require helperpath
        for name, helper of helpers
            handlebars.registerHelper name, helper

Read standard in, sending this along as a context to the template. This just
buffers in a string, the input is expected to not be shocking huge.

    buffers = []
    process.stdin.on 'data', (chunk) ->
        buffers.push chunk
    process.stdin.on 'end', ->
        context = yaml.safeLoad(Buffer.concat(buffers).toString())

I love environment variables, so I'm merging them in here.

        context = _.extend process.env, context
        process.stdout.write renderer(cli.options['<template>'])(context)

Start it up!

    process.stdin.resume()
