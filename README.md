
## images-dashboard

A simple [ruby](https://www.ruby-lang.org/en/) app for displaying
the Travis build status of all
* [cyber-dojo](https://github.com/cyber-dojo) service images
* [cyber-dojo-languages](https://github.com/cyber-dojo-languages) images.

Runs inside a docker-container
```
./pipe_build_up_test.sh
```

Runs locally
```
cd app
bundle install
./up.sh
```

![services](img/services.png?raw=true "services")
![languages](img/languages.png?raw=true "languages")
![test frameworks](img/test-frameworks.png?raw=true "test frameworks")
