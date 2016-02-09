# Installation

From the repository root:

````
npm install
bower install
````
 
## Modifying ad

Each ad has it's own folder in the [`/ads/`](/ads/) directory. Contained in here should be a `main.coffee`, `mains.sass`, and `main.tpl` file.

These scripts and styles are compiled using browserify, mostly through a combination of [https://github.com/davidguttman/sassify](https://github.com/davidguttman/sassify) and [https://github.com/substack/coffeeify](https://github.com/substack/coffeeify).

You can put whatever you want in the files, the main function that you probably want to call is `render`, which you can call like so:



````
render = require '../../scripts/render'

render
  name: __dirname.split('/').slice(-1)[0]
  template: require './main.tpl'
  style: require './main.sass'
  maximize: true
  , (err, element) ->
````

Template is the underscore `template` file, `style` is the SASS file, and `maximize` means to expand the ad to the width of the viewport (using this library [https://github.com/britco/maximus](https://github.com/britco/maximus)). Any of these keys are optional.

When you run this, it will append the styles as well as html to the parent document.

## Testing ad

After you have made modifications, you probably want to test it.

Run `npm start --open`. This will start the ad server that you will need to keep around for development.

It will open a directory listing of all the ad units. When you clickthrough, a sample page with the ad will render. If you don't want this open to happen, run just `npm start ` instead.

The other way is to view the ad on the site. To do this, set `sp_ad` to the location of the script for the ad. I.E.
* [http://www.brit.co/?sp_ad=http://localhost:3000/ads/intel/main.js](http://www.brit.co/?sp_ad=http://localhost:3000/ads/intel/main.js
)
* [http://local.brit.co/?sp_ad=http://localhost:3000/ads/intel/main.js](http://local.brit.co/?sp_ad=http://localhost:3000/ads/intel/main.js).

You can add it to local or production since it works by inserting the script specified into the page. The logic to handle this is in the `storyplate ad` tag in Google Tag Manager.

# Deploying the ad

First you need to upload static files to S3

````
gulp deploy
````

Then add the following code to DFP:
@TODO

## Deploying to Test

To deploy to the test bucket:

````
gulp deploy -t
````

The ad URL will be http://adtest.britcdn.com/ads/[ad_name]/main.js