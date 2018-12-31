# Juliette is a Hugo API Theme Component

This [Hugo](https://gohugo.io) theme component will add API endpoints to your Hugo project.

Every formatting and transforming happens on the data level so template files of any output can rely on a consistent data model.

## Who's Juliette best for?

Juliette is best fit for any of the following use case:
- You have a have heavy need of highly customizable endpoints and some basic understanding of Hugo's templating magic, including but not limited to `.Scratch`.
- You don't need to customize your output and can rely on Juliette's default transformers.

If you need to customize your output but do no want to get involved in coding __and__ all you need is JSON,I recommand this great alternative to Juliette by [DJ Walker](https://github.com/dwalkr/): [Hugo JSON API Theme component](https://github.com/dwalkr/hugo-json-api-component). There's some basic output transforming with zero coding involved!

## This is JSON right?

Yes. But not limited to! 
Juliette focuses on helping you buid a consistent data object for each page with `.Scratch` and outputs it out of the box using `jsonify`. 
Adding another output format is therefor limited to creating a few new templates files from this consistent data model.

## Getting Started

1. `git submodule add https://github.com/regisphilibert/juliette-api-component themes/juliette-api-component`
2. Add `juliette-api-component` as your theme or to your list of themes.
  ```
  theme:
    - that-theme-i-have
    - juliette-api-component
  ```
3. Add JSON as an Output format for the desired page kind:
  ```
  outputs:
    home:
      - HTML
      - JSON
    page:
      - HTML
      - JSON
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
If a `slug` is given Juliette will prepend every URL with the given string, redirect accordingly and modify any references to the urls throughout your project.

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

**Warning**
Hugo does not currently allow pagination to work on multiple Output Formats, pagination will therfore only work on the Main Ouput format, the first in the list of outputs for any given page kind.

If you decide to go ahead and use Juliette's pagination by setting its output as the Main one, simply bear in mind the following:
1. Other Output Format pagination will be broken.
2. In your HTML templates, you should replace `.Permalink` with `(.OutputFormats.Get "html").Permalink`.

##### pagination_append [string | "index.json"]

```
params:
  juliette:
    pagination: 3
    pagination_append: index.xml
```

As mentionned earlier, if you are using Pagination, this means your Main Output format is rendered by Juliette.
Juliette cannot retrieve the `baseName` of your main Output Format file, and needs it in order to append it to Hugo's Pagination pagers' `.URL` returned value, which stops at the diretory (`/page/2/` instead of `/page/2/index.json`).


## Advanced customization

You're probably there because you won't content with some basic keys in your endpoints. With a bit of coding, Juliette lets you shape your data model through "transformers".

### Transformers

When rendering the output of an entry, be it from its single page or a list page, Juliette uses the entry type's transformer partial if available. 

`content/recipe/chocolate-cupcake.md` will use the transformer located at `layouts/partials/transformers/recipe.tpl`

Look inside [`/layouts/partials/transformers`](/layouts/partials/transformers) for the best way to create new transformers. You can use the default transformer as a base of key value pairs to be included in all of your transformers.

### Nested Transformers

If you need to use a content type transformer inside another content type transformer for say, listing related content, you can "cautiously" do it this way:

```
{{ partial "transformers/default.tmpl" . }}
{{- $rootScratch := .Scratch }}
{{ $related_recipes := where (.Site.RegularPages.Related) "Type" "recipe" }}
{{ $related := slice }}
{{ range $related_recipes }}
  {{- partial "getTransformer.tmpl" . -}}
  {{ $related = $related | append (.Scratch.Get "item") }}
  {{- .Scratch.Delete "item" -}}
{{ end }}
{{ .Scratch.SetInMap "item" "related" $related }}
```

**Warning**
Watch out of infinite depth objects.

### Built-in transformers

- `layouts/partials/transformers/default.tmpl`
- `layouts/partials/transformers/page.tmpl`

## Another JAMStack first name?
Yeah! Ain't it great to be on first name basis with a cool tool? Then you can write "Juliette does this", "Juliette does that"! It abstracts any blameable humans involved and replace them by a cute moniker. Perfect!

### Sure... who's Juliette?
[Juliette Drouet](https://en.wikipedia.org/wiki/Juliette_Drouet) was personnal secretary and lover to [Victor Hugo](https://en.wikipedia.org/wiki/Victor_Hugo). Just like an API endpoint, she lived in the shadow of a great <del>man</del> site.