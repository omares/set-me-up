# set-me-up

set-me-up aims to simplify the dull setup and maintenance of macOS development environments.
It does so by automating the process through a collection of dotfiles and shell scripts.

These modules are currently available:

* `essentials` Installing brew, brew cask and App Store applications required to feel comfortable at your mac.
* `macosupdate` Runs the macOS software update. 
* `macos` Applies sane macOS defaults based on [mathiasbynens popular script](https://github.com/mathiasbynens/dotfiles/blob/master/.macos).
* `terminal` Provides a nice zsh setup.
* `base` Ensuring that a certain environment is given under which smu can operate.

## Usage

**Note:** set-me-up is work in progress. A more standalone and versioned customization process is planned. 

No matter how you obtain smu, as a sane developer you should take a look at the provided modules and dotfiles to verify that no shenanigans are happening.

### Use set-me-up as is

In case you are happy with what you will get, clone this repository and use the `smu` script. 
To provision all available modules you can run `smu -p -m all`. To specify a list of modules use the `-m` switch `smu -p -m essentials -m terminal`  

Once you ran the base setup moving the source folder is not recommended due to the nature of symlinks.

Should your system require a system restart due to an `macosupdate` caused update, rerun the smu script after rebooting. The update module should be satisfied by the previous run and result in no action. 
 
### Customize set-me-up

set-me-up will favor your version of a file, when you provide one, through the power of [rcm tags](http://thoughtbot.github.io/rcm/rcup.1.html).
This mitigates the need to adjust the files that come with set-me-up and gives high customizability: 

0. Fork the repository
1. Create a new rcm tag, by creating a new folder prefixed `tag-` inside the [`.dotfiles`](.dotfiles) directory: `.dotfiles/tag-mydiary`
2. Add your tag to the [`.rcrc`](.rcrc) configuration file infront of the current defined tags. Resulting in `TAGS="mydiary smu"`
3. Copy the file you want to change to your tag directory and apply your changes. It is important to preserve the file name and path. 
4. Clone your fork and [use the `smu` script](#use-set-me-up-as-is) to run the desired modules.


* At least duplicate the `update.sh` script and change the repository name.
* You can add new dotfiles and modules to your tag. rcm symlinks all files if finds to your home directory. 
* File contents are not merged between tags, your file simply has a higher precedence and will be used/symlinked instead.

## A closer look

### How does it work?

> Hamid: What's that?  
> Rambo: It's blue light.  
> Hamid: What does it do?  
> Rambo: It turns blue.

**TL;DR;** It symlinks all dotfiles and stupidly runs shell scripts. 



smu symlinks all dotfiles from the `.dotfiles` folder, which includes the modules, to your home directory. With the power of [rcm](https://github.com/thoughtbot/rcm), `.dotfiles/tag-smu/gitconfig` becomes `~/.gitconfig`. Using bash scripting the installation of brew is ensured. All this is covered by the base module and provides an opinionated base setup on which smu operates. 

Depending on the module further applications will be installed by "automating" their installation through other bash scripts.  
In most cases set-me-up delegates the legwork to tools that are meant to be used for the job. E.g. installing zplugin for zsh plugin management. 

Nothing describes the actual functionality better than code. It is recommended to check the appropriate module script to get the full insights. 
set-me-up is a plain collection of bash scripts and tools that you probably already worked with, therefor understanding what is happening will be easy. :)  

### [smu](smu)

The `smu` script is wrapped with auto-generated [argbash.io](https://argbash.io/) code. It aims to make the usage of set-me-up as pleasant as possible.
It runs the given modules by sourcing the appropriate script and ensuring a few constraints: always run the base module and prioritize the macOS update to the beginning of the list. 

### [modules/base](.dotfiles/base)

The base module is the only module that is required to run at least once on your machine to ensure the minimum required constraints for set-me-up to work. 

If not available it will install `brew` and then `rcm`. Afterwards `rcup` will be executed to symlink the dotfiles from the `.dotfiles` folder into your home directory. 

This is the only module that is not overwritable via rcm tag management. It is always sourced from the smu installation directory.

### [modules/essentials](.dotfiles/tag-smu/modules/essentials)

Installs a multitude of brew packages, casks and Mac App Store applications. Check the brewfile to get an overview. 

### [modules/macos](.dotfiles/tag-smu/modules/macos)

Sets a bunch of macOS settings. The file is based on macos. None macos related setup calls have been removed. 

**It is highly recommended to go through the file and work with a copy, that is adaptedto your needs!**

### [modules/macosupdate](.dotfiles/tag-smu/modules/macosupdate)

Runs the macOS updater via console call. 

### [modules/terminal](.dotfiles/tag-smu/modules/terminal)

Configures zsh as your default shell with sane zsh options and provides you with a list of useful plugins managed via [zplugin](https://github.com/zdharma/zplugin). 

For flexibility and speed reasons set-me-up does not rely on any of the popular frameworks but utilitizes a few plugins from these. 

The terminal module does not come with any theme or fancy prompt. A separate theming module is planned to satisfy this. 

### [modules/php](.dotfiles/tag-smu/modules/php)

Installs PHP5, PHP7 and [composer](https://getcomposer.org/) for package management via brew. PHP7 will be defined as active version.  
For each version the apcu, amqp, igbinary and xdebug extensions are installed via pecl, memcached is installed from source.
 
The [phpswitch script](https://github.com/philcook/brew-php-switcher) enables you to switch between the installed versions.

### [modules/ruby](.dotfiles/tag-smu/modules/ruby)

Installs [rbenv](https://github.com/rbenv/rbenv) for version management and [bundler](http://bundler.io/) for package management. ruby2 is installed and defined as global version via rbenv. 

When the terminal module is used the ruby installation will work out of the box as the required rbenv code is already in place. 

### [modules/python](.dotfiles/tag-smu/modules/python)

Installs [pyenv](https://github.com/pyenv/pyenv) for version management and [pipenv](https://github.com/pypa/pipenv) for package management. python2 and python3 is installed using pipenv. python3 will be defined as global version.

When the terminal module is used the python installation will work out of the box as the required pyenv code is already in place. 

### [modules/java](.dotfiles/tag-smu/modules/java)

Installs [sdkman](http://sdkman.io/) to manage all java-world related packages. java8, java10, kotlin1, maven3 and gradle4 are installed via sdkman. **java8** will be defined as global version. Android Studio is installed via brew cask. 
 
### [modules/update.sh](.dotfiles/tag-smu/modules/update.sh)

Tries it best to be useful as an updater of the provided sources. Work in progress ;)

## Credits

* [donnemartin/dev-setup](https://github.com/donnemartin/dev-setup)
  set-me-up was born as a fork of donnemartin/dev-setup and my curiosity to adapt it to my needs.
  As my PR was/is waiting to get merged i continued to rework most of the original code, thus set-me-up emerged.  
* [mathiasbynens](https://github.com/mathiasbynens/dotfiles) for his popular [macOS script](https://github.com/mathiasbynens/dotfiles/blob/master/.macos).   
* [argbash.io](https://argbash.io/) enabling library free and sane argument parsing.
* [brew](https://brew.sh/) and [brew bundle](https://github.com/Homebrew/homebrew-bundle) for the awesome package management.
* The great people who provide brew formulas and zsh plugins.  
* Especially [zimf](https://github.com/zimfw/zimfw), [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/) and [prezto](https://github.com/sorin-ionescu/prezto) as i utilize plugins from these frameworks. And zplugin that has a high every barrier but gives the highest flexibility when it comes to zsh plugin management.  
* [thoughtbot rcm](https://github.com/thoughtbot/rcm) for the easy dotfile management. 
* All authors of the installed applications via set-me-up, i am in no way connected to any of them.

Should i miss your name on the credits list please let me know :heart:

## Contributions

Yes please! This is a GitHub repo for reasons. :)
