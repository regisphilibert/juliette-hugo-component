# Juliette is a Hugo API Theme Component

This [Hugo](https://gohugo.io) theme component will add API endpoints to your Hugo project.

Every formatting and transforming happens on the data level so template files of any output can rely on a consistent data model.

⚠️ Using custom transformers? You might follow this migration guide before upgrading to 3.0.0

## Who's Juliette best for?

Juliette is best fit for any of the following use case:
- You have a heavy need of highly customizable endpoints and some basic understanding of Hugo's templating magic, including but not limited to `.Scratch`.
- You don't need to customize your output and can rely on Juliette's default transformers.

If you need to customize your output but do no want to get involved in coding __and__ all you need is JSON,I recommand this great alternative to Juliette by [DJ Walker](https://github.com/dwalkr/): [Hugo JSON API Theme component](https://github.com/dwalkr/hugo-json-api-component). There's some basic output transforming with zero coding involved!

## What are the supported Output Formats?

Out of the box, Juliette can produce JSON and XML.

But this is not a limit. Juliette focuses on helping you buid a consistent data object for each page. 
Adding your own output format is therefor limited to creating a few new templates files pulling from this consistent data model.

## Getting Started

1. `git submodule add https://github.com/regisphilibert/juliette-hugo-component themes/juliette-hugo-component`
2. Add `juliette-hugo-component` as your theme or to your list of themes.
  ```
  theme:
    - that-theme-i-have
    - juliette-api-component
  ```
3. Add JSON and/or XML as an Output format for the desired page kind:
  ```
  outputs:
    home:
      - HTML
      - JSON
    section:
      - HTML
      - JSON
    page:
      - HTML
      - JSON
      - XML
  ```

You're done! Go get that endpoint at `my-perfect-website.com/index.json`

## Options

Juliette options live in your `.Site.Params` under the `juliette` object as such:

```
params:
  juliette:
    slug: 'api'
    pagination: 3
```

### Permalinks

#### beautify [bool]:

If `beautify` is set to true, Juliette will get rid of this ulgy `index.json` at the end of your urls, redirect accordingly and modify any reference to the urls throughout.

#### slug [string]:
If a `slug` is given Juliette will prepend every URL with the given string, redirect accordingly and modify any reference to the urls throughout your project.

Is is greatly recommanded to use a `slug` in conjunction with `beautify` if your project sports more than one output per page. Otherwise both HTML and JSON output will use the same URL thereof.

#### How does that work?

Juliette, creates redirect files with the generated rules and add them to your project.

Available redirect solution:
- Netlify: With `redirect_netlify` output format set on the homepage, Juliette will create a `_redirect` file.
- Apache: With `redirect_apache` output format set on the homepage, Juliette will create a `.htaccess` file.

Add your own `layouts/_default/index.redirect_netlify` or `layouts/_default/index.redirect_apache.htaccess` to your project to overwrite Juliette's.

Ex. The following configuration:

```
params:
  juliette:
    beautify: true
    slug: 'api/v1.0'

outputs:
  home:
    - html
    - json
    - redirect_netlify
```

Will make `/recipes/choco-cupcakes/index.json` available at `/api/v1.0/recipes/choco-cupcakes/` on a Netlify hosted project.

**Warning**
Not available on live server, for obvious reasons.

### Pagination

#### pagination [int]

Note that this option can be set on the site or page level, either underneath your `config.yaml` `params.juliette` object or right in your list page's Front Matter.

With the following site configuration:

```
params:
  juliette:
    pagination: 3
```

Juliette will paginate your list pages with 3 entries per page and output a nice pagination object:

```
"pagination": {
  "first":"http://juliette.api/index.json",
  "last":"http://juliette.api/page/7/index.json",
  "next":"http://juliette.api/page/3/index.json",
  "page":3,
  "pages":7,
  "self":"http://localhost:1313/page/3/index.json"
}
```

## Advanced customization

You're probably here because you won't content with some basic keys in your endpoints. With a bit of coding, Juliette lets you shape your data model through "transformers".

### Transformers

When rendering the output of an entry, be it from its single page or a list page, Juliette uses the entry type's transformer partial if available. 

`content/recipe/chocolate-cupcake.md` will use the transformer located at `layouts/partials/juliette/transformers/recipe.html`

You can look inside [`/layouts/partials/juliette/transformers`](/layouts/partials/juliette/transformers) for code examples. 

You can use the default transformer as a base of key value pairs to be included in all of your transformers.

Transformers uses the newly `return` directive from Hugo partial, so you don't need to worry about printing line breaks or whitespace in your markup.

The most explicit one being the Page Transformer:

```
{{/*
  Page Transformer

  @author @regisphilibert

  @context Page (.)

  @access public

  @return Map
      - ...transformers/default
      - menu: String
      - Description: String
*/}}

{{/* We use local Scratch in order to conveniently manipulate our map before returning it. */}}
{{ $s := newScratch }}

{{/*  Each custom transformers can use "juliette/transformers/default" as a base of key/value pairs. 
      Let's create our a map and store the default transformer's data. */}}
{{ $s.Set "item" (partial "juliette/transformers/default" .) }}

{{/* 
  Now we can use Scratch's .SetInMap to add key/value pairs to our local Scratch's "item" map.  */}}

{{/* Menu */}}
  {{ $s.SetInMap "item" "weight" .Weight }}

{{/* Description */}}
{{ with .Description }}
  {{ $s.SetInMap "item" "description" . }}
{{ end }}

{{/*  Finally, we return the map. 
      Voilà! */}}
{{ return $s.Get "item" }}
```
### Using transformers.

Juliette deal with those under the hood. But if you have to build your own Output Format templates, you will need to grab access those yourself. The `juliette/transform` partial determine which transformer to use on any given content file, so providing that dot is your Page's context:

```
{{ with partial "juliette/transform" . }}
  [... Handle data...]
{{ end }}
```

It the logic does not suit, then you can go and bypass "transform" by calling that transformer yourself:
```
{{ with partial "juliette/transformers/my-transformer" . }}
  [... Handle data...]
{{ end }}
```


### Nested Transformers

If you need to use a content type transformer inside another content type transformer for say, listing related content, you can "cautiously" do it this way:

```
{{ $s := newScratch }}
{{ $s.Set "item" (partial "juliette/transformers/default" .) }}
{{ $related_recipes := where (.Site.RegularPages.Related) "Type" "recipe" }}
{{ $related := slice }}
{{ range $related_recipes }}
  {{ $related = $related | append (partial "juliette/transform .) }}
{{ end }}
{{ $s.SetInMap "item" "related" $related }}
{{ return $s.Get "item" }}
```

**Warning**
Watch out of infinite depth objects. If your pizzas list their toppings, and your toppings list their pizzas: 🍕 🌶️ 🔥 🤯

### Built-in transformers

- `layouts/partials/juliette/transformers/default.html`
- `layouts/partials/juliette/transformers/page.html`

### Migrating your custom transformers to Juliette 3.0

Juliette's public partials have moved to a reserved location to avoid collision with other Hugo Component's partials. So your custom transformers needs to move to `partials/juliette/transformers/my-transformer.html` in order to be accessible by Juliette. Also they now use the `html` extension so the extension can be ommited from the partial's path argument.

| Before | After |
| ---- | ---- |
| `/layouts/partials/transformers/my-transformer.tpl` | `/layouts/partials/juliette/transformers/my-transformer.html` |
| `{{ partial "transformers/my-transformer.tpl }}` | `{{ partial "juliette/transformers/my-transformer" }}` |

Page's Scratch is dropped in favor of `return` partials to manipulate data. As local Scratch is still heavily used. This should not create too much changes in your code. Go another read to the new [Advanced Customization section](#advanced-customization)

## Another JAMStack first name?
Yeah! Ain't it great to be on first name basis with a cool tool? Then you can write "Juliette does this", "Juliette does that"! It abstracts any blameable humans involved and replace them by a cute moniker. Perfect!

### Sure... who's Juliette?
[Juliette Drouet](https://en.wikipedia.org/wiki/Juliette_Drouet) was personnal secretary and lover to [Victor Hugo](https://en.wikipedia.org/wiki/Victor_Hugo). Just like an API endpoint, she lived in the shadow of a great <del>man</del> site.
