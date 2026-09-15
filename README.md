# govuk-brand-yml

A [`_brand.yml`](https://posit-dev.github.io/brand-yml/) theme that gives
Bootstrap-based sites and apps a GOV.UK look with minimal effort. Built
primarily for pkgdown sites and simple Quarto documents, but also works
with `bslib` Shiny apps, Quarto slides, and Python projects.

**Live showcase: <https://cjrace.github.io/govuk-brand-yml/>**

## When to use this vs. the alternatives

Use this for a quick GOV.UK feel on a pkgdown site or Quarto project where
standard Bootstrap components are fine, in line with `_brand.yml`'s own
philosophy, it is 'good enough' theming, not a full component library.

Use one of these instead when you need actual GOV.UK components:

| Project | Fidelity | Scope |
|---|---|---|
| **This repo** | Approximate simple re-theme | Any Bootstrap / bslib site |
| [shinyGovstyle](https://github.com/dfe-analytical-services/shinyGovstyle) | Full component library | R Shiny apps |
| [quarto-govuk](https://github.com/rossbowen/quarto-govuk) | Detailed Quarto GOV.UK styling | Standalone Quarto HTML |

## Usage

### 1. Add the files to your project

Copy the file/s into your own project.

[Download `_brand.yml`](https://raw.githubusercontent.com/cjrace/govuk-brand-yml/main/_brand.yml)
and save it in your project's main folder. Also copy the [`logo`
folder](https://github.com/cjrace/govuk-brand-yml/tree/main/logo) in, so
the GOV.UK crest it references is available (see [Logo and
crest](#logo-and-crest) below).

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
compiles its own navbar/dropdown/TOC Sass *after* `_brand.yml`, which
dilutes or overrides it (the navbar background ends up a light
`color-mix()` tint of `$primary`, not `$primary` itself). Fix it with a
[`pkgdown/extra.scss`](https://pkgdown.r-lib.org/articles/customise.html#sass)
file instead, like the one below. The navbar rule needs
`!important` because pkgdown's own `.bg-light` navbar class uses it too:

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
  background-color: $brand-focus-colour;
}
```

This gives the navbar a solid GOV.UK blue background, white nav links and
icons, a visible mobile nav toggler, and GOV.UK's black-on-yellow
hover/focus highlight on the site title, nav links, dropdown menu, and
"On this page" sidebar.

## No GDS Transport font

GOV.UK's typeface (GDS Transport) is `*.gov.uk`-only, so it's not included
here. This uses the plain `Arial, sans-serif` fallback GOV.UK Frontend
itself falls back to.

## Logo and crest

`logo/govuk-crest.svg` and `logo/favicon.ico` come from
[GOV.UK Frontend](https://github.com/alphagov/govuk-frontend) (MIT). Copy
the `logo` folder into your project and `_brand.yml` shows the crest in a
Quarto website navbar by default.

**Consider whether you should show it.** GOV.UK's [own
guidance](https://design-system.service.gov.uk/components/header/#when-not-to-use-this-component)
reserves the crest for services actually hosted on a `gov.uk` domain. If
that's not you, change the logo, or hide it in your own site's CSS instead:

```css
.navbar-logo { display: none !important; }
```

**pkgdown doesn't use any of this.** Its navbar logo is a separate, older
convention - it auto-detects `logo.svg`/`man/figures/logo.svg`/`logo.png`/
`man/figures/logo.png` in your package and shows that, regardless of
`_brand.yml`. To add the crest there, copy it in yourself. To hide it, don't.

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
