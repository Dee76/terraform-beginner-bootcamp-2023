## TerraHome AWS

```terraform
module "home_gfcake" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.gfcake_public_path
  content_version = var.content_version
}
```

The public directory expects the following:
- index.html
- error.html
- assets _(optinal)_
  * img _(optional)_
  * css _(optinal)_
  * js _(optional)_
  * fonts _(optinal)_

The `index.html` and `error.html` files will be explicitly copied.

Files in the `assets` sub-directories will be copied as follows:
- All image files in `assets/img` will be copied (jpg, jpeg, gif, png).
- All CSS files in `assets/css` will be copied (css).
- All Javascript files in `assets/js` will be copied (js).
- All fonts in `assets/fonts` will be copied (eot, svg, tff, woff).

Asset files not located in their proper sub-directory as indicated will be ignored.

:end:
