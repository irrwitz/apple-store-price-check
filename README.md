# apple-store-price-check

To run
```
elm-reactor
```

and then start browser (example Chrome on OS X)
```
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome -disable-web-security
```

(-disable-web-security because otherwise cross-domain requests are not allowed.
Needs later changed to JSONP)

and visit [PriceCheck](http://localhost:8000/PriceCheck.elm)

