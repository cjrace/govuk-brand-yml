# govuk-brand-yml

A [`_brand.yml`](https://posit-dev.github.io/brand-yml/) theme based on the
[GOV.UK Design System](https://design-system.service.gov.uk/), for
Bootstrap-based sites and apps in the R / Python / Quarto ecosystem that want a GOV.UK
look (or something to fork from and customise) for minimal effort - built primarily for:

- pkgdown documentation sites
- Simple Quarto documents

But also works with:

- Shiny apps built with `bslib`
- Quarto slides
- Python projects

**Live showcase: <https://cjrace.github.io/govuk-brand-yml/>**

## When to use this vs. the alternatives

Use this for a speedy GOV.UK feel on a pkgdown site, or a Quarto
project where standard Bootstrap components are fine.

In line with the [`_brand.yml`](https://posit-dev.github.io/brand-yml/)
philosophy, this is intended only as 'good enough' theming.

Use the other existing projects when you need actual GOV.UK components and
more detailed styling.

| Project | Fidelity | Scope |
|---|---|---|
| **This repo** | Approximate simple re-theme | Any Bootstrap / bslib site |
| [shinyGovstyle](https://github.com/dfe-analytical-services/shinyGovstyle) | Full component library | R Shiny apps |
| [quarto-govuk](https://github.com/rossbowen/quarto-govuk) | Detailed Quarto GOV.UK styling | Standalone Quarto HTML |

## Usage

### 1. Add the files to your project

Copy the file/s into your own project.

[Download `_brand.yml`](https://raw.githubusercontent.com/cjrace/govuk-brand-yml/main/_brand.yml)
and save it in your project's main folder. If you also want the GOV.UK
crest available to use, copy the [`logo`
folder](https://github.com/cjrace/govuk-brand-yml/tree/main/logo) in too
(see [Logo and crest](#logo-and-crest) below for how to show it).

If you're adding this to an R package (for example, to theme a pkgdown
site), put `_brand.yml` inside the package's `inst/` folder instead, so
that checking the package doesn't produce a note.

### 2. Point your project at it

**Quarto:**

```yaml
# _quarto.yml
brand: _brand.yml
```

Quarto can also find a `_brand.yml` in your project's main folder
automatically, so you can try skipping this.

**Shiny apps (using bslib):**

```r
bslib::bs_theme(brand = TRUE) # finds ./_brand.yml automatically, needs bslib 0.9.0 or later
```

**pkgdown sites:**

```yaml
# _pkgdown.yml
template:
  bootstrap: 5
  bslib:
    brand: inst/_brand.yml
```

**pkgdown's navbar doesn't inherit these colours automatically.** pkgdown
adds its own navbar/dropdown/TOC Sass *after* `_brand.yml`'s rules are
compiled in, and that Sass dilutes or overrides them (its navbar background
is a light `color-mix()` tint of `$primary`, not `$primary` itself) - so this
can't be fixed from inside `_brand.yml`. Fix it with a
[`pkgdown/extra.scss`](https://pkgdown.r-lib.org/articles/customise.html#sass)
file in your package instead, which pkgdown compiles in last. The navbar rule
needs `!important` - pkgdown puts a `bg-light` utility class directly on the
navbar element, and Bootstrap's `.bg-light` sets `background-color` with
`!important`, which otherwise wins regardless of cascade order:

```scss
// pkgdown/extra.scss
.navbar {
  background-color: $primary !important;
}

.navbar-brand,
.navbar-nav .nav-link,
.navbar-nav .dropdown-toggle {
  color: #fff;
}

.navbar .nav-text.text-muted {
  color: rgba(255, 255, 255, 0.75) !important;
}

.navbar-toggler-icon {
  filter: invert(1);
}

.navbar-toggler {
  border-color: rgba(255, 255, 255, 0.5);
}

.navbar-brand:hover,
.navbar-brand:focus,
.navbar-nav .nav-link:hover,
.navbar-nav .nav-link:focus,
.navbar-nav .dropdown-toggle:hover,
.navbar-nav .dropdown-toggle:focus,
.dropdown-menu .dropdown-item:hover,
.dropdown-menu .dropdown-item:focus,
#toc > .nav a.nav-link:hover,
#toc > .nav a.nav-link:focus {
  color: $body-color;
  background-color: $warning;
}
```

This gives the navbar a solid GOV.UK blue background, white nav links and
GitHub icon (pkgdown auto-generates that one; brand.yml has no opinion on
it), a visible mobile nav toggler, and GOV.UK's black-on-yellow highlight on
hover/focus for the site title, nav links, the Articles dropdown menu, and
the "On this page" TOC sidebar.

## No GDS Transport font

GOV.UK's typeface, GDS Transport, is licensed for `*.gov.uk` services only -
it's deliberately not included here, not even as a fallback reference. The
font stack is the plain `Arial, sans-serif` GOV.UK Frontend itself falls
back to.

## Logo and crest

`logo/govuk-crest.svg` and `logo/favicon.ico` come from
[GOV.UK Frontend](https://github.com/alphagov/govuk-frontend) (MIT).

The crest is **hidden by default** in a Quarto website navbar (via a
`.navbar-logo { display: none }` rule in `_brand.yml`) and isn't shown
anywhere in this repo's own showcase page. This follows the [GOV.UK Design
System's own
guidance](https://design-system.service.gov.uk/components/header/#when-not-to-use-this-component):
the GOV.UK header is reserved for services actually hosted on a
`gov.uk` domain - if that's not you, don't show it there either.

### Showing the crest

Internal government documents (a departmental style guide, an internal
Quarto report, an internal pkgdown site) are a reasonable case for wanting
the crest even off a `gov.uk` domain. To show it, copy the logo folder in and 
override the rule in your own site's CSS - e.g. in `_quarto.yml`:

```yaml
format:
  html:
    css: my-overrides.css
```

```css
/* my-overrides.css */
.navbar-logo { display: inline-block !important; }
```

Or drop it in inline, anywhere in the page, if you just want it on that one
document:

```markdown
![](logo/govuk-crest.svg){width="35px"}
```

**pkgdown doesn't use any of this.** Its navbar logo is a separate, older
convention - it auto-detects `logo.svg`/`man/figures/logo.svg`/`logo.png`/
`man/figures/logo.png` in your package and shows that, regardless of
`_brand.yml`. To add the crest there, copy it in yourself:

```bash
cp path/to/govuk-brand-yml/logo/govuk-crest.svg man/figures/logo.svg
```

## Quarto slides (revealjs)

Colours, fonts and code-block styling apply correctly to `revealjs`
presentations too, since those come from `_brand.yml`'s `color:`/
`typography:` sections, which Quarto maps onto reveal.js's own theme
variables. Simple slides will likely look on brand, slides with more 
features in them may not and will want more dedicated theming than a
`_brand.yml` file can offer.

## Forking for another organisation

Want a similarly GOV.UK-inspired brand with different colours (e.g. for a
department)? Fork this repo and change:

- **`_brand.yml:`** name, link, description, your own colour hex values.
- **`logo:`** - point `images:` at your own crest/logo instead of
  `logo/govuk-crest.svg`.
- **`typography:`** - if you want to change away from Arial.
- **`scripts/update-tokens.sh`** - this pulls specifically from
  govuk-frontend's published npm package, so either update or drop it.

## Keeping this repo up to date

Colours are static, copied from a specific GOV.UK Frontend version, not
tracked automatically. I run the following to overwrite
`_brand.yml`'s palette, and the matching swatches in `index.qmd`'s
showcase.

```bash
scripts/update-tokens.sh
```

## Running the showcase locally

```bash
quarto preview
```

Renders `index.qmd` and opens it at `localhost` with live reload. Edit
`_brand.yml` and the page updates automatically, so this is also how to
check any brand change before committing.

## License

MIT - see [LICENSE](LICENSE). Colour tokens and logo / favicon assets
originate from [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend).
