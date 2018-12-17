# Juliette is a Hugo API Theme Component

This [Hugo](https://gohugo.io) theme component will add API endpoints your Hugo project.

Every formatting and transforming happens on the data level so template files of any output can rely on a consistent data model.

## Who's Juliette best for?

Juliette is best fit if 
1. You have a have heavy need of highly customizable endpoints and some basic understanding of Hugo's templating magic, including but not limited to `.Scratch`.
2. You don't need to customize your output and can rely on Juliette's default transformers.

If you need to customize your output but do no want to get involved in coding __and__ all you need is JSON,I recommand this great alternative to Juliette by [DJ Walker](https://github.com/dwalkr/): [Hugo JSON API Theme component](https://github.com/dwalkr/hugo-json-api-component). There's some basic output transforming with zero coding involved!

## This is JSON right?

Yes. But not limited to! 
Juliette focuses on helping you buid a consistent data object for each page with `.Scratch` and outputs it out of the box using `jsonify`. 
Adding another output format is therefor limited to creating a few new templates files from this consistent data model.

## Getting Started

1. `git submodule add https://github.com/regisphilibert/juliette-api-component`
2. Add `juliette-api-component` or whatever you may have renamed Juliette's directory
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

Go get that endpoint at `your-page/index.json`

### Options

Juliette options live under your `.Site.Params` under the `juliette` object as such:

```
params:
  juliette:
    slug: 'api'
    pagination: 3
```

#### slug

Using the site params' `juliette.slug`, Juliette will prepend urls using the set value by adding a redirection file to your `publishDir` thanks to Hugo's Custom Output Format and modify your page's URL reference throughout.

Available redirect solution:
- Netlify: Using `redirect_netlify` output format on the homepage, Juliette will create a `_redirect` file.
- Apache: Using `redirect_apache`output format on the homepage, Juliette will create a `.htaccess` file.

If you need to overwrite those, add your own `layouts/_default/index.redirect_netlify` or `layouts/_default/index.redirect_apache.htaccess` to your project to overwrite Juliette's.

Ex. The following configuration:

```
params:
  juliette:
    slug: 'api/v1.0'

outputs:
  home:
    - html
    - json
    - redirect_netlify
```

Will make `/recipes/choco-cupcakes/index.json` available at `/api/v1.0/recipes/choco-cupcakes/index.json` on a Netlify hosted project.

**Warning**
Not available on live server, for obvious reasons.

#### pagination

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
  "page":1,
  "pages":2,
  "self":"http://localhost:1313/page/3/index.json"
}
```

**Warning***
Hugo does not currently allow pagination to work on serveral Output Format. Only the main one can handle pagination. 
I'm afraid this Juliette's Pagination Feature is therefor limited to projects with only one Output from Juliette, meaning API only projects. 

You can try and fight this by making the desired Juliette Output Format on the top of your output list for a given page kind. But bear in mind that by doing so, your risk encountering issues in this page's other template files. (ex. `.Permalink` will output the main output format's permalink from `single.html` 🤷‍♂️)

## Advanced customization

You're probably there because you won't content with some basic keys in your endpoints. With a bit of coding, Juliette lets you shape your data model through "transformers".

### Transformers

When rendering the output of an entry, be it from its single page or a list page, Juliette uses the entry type's transformer partial if available. 

`content/recipe/chocolate-cupcake.md` will use the transformer located at `layouts/partials/transformers/recipe.tpml`

Look inside [`/layouts/partials/transformers`](/layouts/partials/transformers) for the best way to create new transformers. You can use the default transformer as a base of key value pairs to be included in all of your transformers. 

### Nested Transformers

If you need to use a content type transformer inside another content type transformer for say, listing related content, you can "cautiously" do it this way:
```
{{ partial "transformers/default.tmpl" . }}
{{- .Scratch.SetInMap "item" "year" .Params.year -}}
{{- $rootScratch := .Scratch }}
{{ $related := where (.Site.RegularPages.Related) "Type" "recipe" }}
{{ $s := newScratch }}
{{ $s.Add "related" (slice) }}
{{ range $related }}
  {{- partial "getTransformer.tmpl" . -}}
  {{ $s.Add "related" (.Scratch.Get "item") }}
  {{- .Scratch.Delete "item" -}}
{{ end }}
{{ .Scratch.SetInMap "item" "related" ($s.Get "related") }}

**Warning**
Watch out of infinite depth objects.

### Built-in transformers

- `layouts/partials/transformers/default.tmpl`
- `layouts/partials/transformers/page.tmpl`

## Another JAMStack first name?
Yeah! Ain't it great to be on first name basis with a cool tool? Then you can write "Juliette does this", "Juliette does that"! It abstracts any blameable humans involved and replace them by a cute moniker. Perfect!

### Sure... who's Juliette?
[Juliette Drouet](https://en.wikipedia.org/wiki/Juliette_Drouet) was personnal secretary and lover to [Victor Hugo](https://en.wikipedia.org/wiki/Victor_Hugo). Just like an API endpoint, she lived in the shadow of a great <del>man</del>site.