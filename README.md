# set-me-up

set-me-up aims to simplify the dull setup and maintenance of macOS development environments.
It does so by automating the process through a collection of dotfiles and shell scripts [bundled into modules](#available-modules).

## Usage

**Note:** set-me-up is work in progress. A more standalone and versioned customization process is planned. 

No matter how you obtain smu, as a sane developer you should take a look at the provided modules and dotfiles to verify that no shenanigans are happening.

### Installing set-me-up

1. Clone this repository **into** your home directory.

       git@github.com:omares/set-me-up.git ~/

2. Use the smu script, which you find in your home directory, to run the base module. Check the [base module documentation](#base) for more insights.

       smu -p -m base
       
   After running the base module moving the source folder is not recommended due to the usage of symlinks.  
    
3. Afterwards provision your machine with [further modules](#available-modules) via the smu script. Repeat the `-m` switch to specify more then one module.
  
       smu -p -m essentials -m terminal -m php
       
   As a general rule of thumb only pick the modules you need, running all modules can take quite some time.
   Fear not, all modules can be installed to a later point of time when you need it.
    
### Customize set-me-up

set-me-up will favor your version of a file, when you provide one, through the power of [rcm tags](http://thoughtbot.github.io/rcm/rcup.1.html).
This mitigates the need to adjust the files that come with set-me-up and gives high customizability: 

1. Fork the repository
2. Create a new rcm tag, by creating a new folder prefixed `tag-` inside the [`.dotfiles`](.dotfiles) directory: `.dotfiles/tag-mydiary`
3. Add your tag to the [`.rcrc`](.rcrc) configuration file infront of the current defined tags. Resulting in `TAGS="mydiary smu"`
4. Copy the file you want to change to your tag directory and apply your changes. It is important to preserve the file name and path. 
5. Clone your fork and [use the `smu` script](#installing-set-me-up) to run the desired modules.


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

### Available modules

#### [base](.dotfiles/base)

The base module is the only module that is required to run at least once on your system to ensure the minimum required constraints for set-me-up to work. 

If not available it will install `brew` and then `rcm`. Afterwards `rcup` will be executed to symlink the dotfiles from the `.dotfiles` folder into your home directory. 

This is the only module that is not overwritable via rcm tag management. It is always sourced from the smu installation directory.

#### [essentials](.dotfiles/tag-smu/modules/essentials)

Installs a multitude of brew packages, casks and Mac App Store applications. Check the [brewfile](.dotfiles/tag-smu/modules/essentials/brewfile) to get an overview. 

#### [macos](.dotfiles/tag-smu/modules/macos)

Sets a bunch of macOS settings. The file is based on macos. None macos related setup calls have been removed. 

**It is highly recommended to work with a copy that is adapted to your needs!**

#### [macosupdate](.dotfiles/tag-smu/modules/macosupdate)

Runs the macOS updater via console call. 

Should your system require a system restart due to an `macosupdate` caused update, rerun the smu script after rebooting. The update module should be satisfied by the previous run and result in no action.

#### [terminal](.dotfiles/tag-smu/modules/terminal)

Configures zsh as your default shell with sane zsh options and provides you with a list of useful plugins managed via [zplugin](https://github.com/zdharma/zplugin).

For flexibility and speed reasons set-me-up does not rely on any of the popular frameworks but picks a few plugins from these. To keep the console snappy all plugins are [loaded asynchronously](https://github.com/zdharma/zplugin#turbo-mode-zsh--53). 

Some of the plugins are:

* zsh-autosuggestions
* zsh-completions
* zsh-you-should-use
* fast-syntax-highlighting
* fasd
* fzf
* ... and more. Take a look at the [zplugin file](.dotfiles/tag-smu/zsh/zplugin.zsh) for a full overview.

The terminal module does not come with any theme or fancy prompt. A separate theme module is planned to satisfy this. 

#### [editor](.dotfiles/tag-smu/modules/editor)

The editor module comes with [neovim](https://neovim.io/) and [vim](https://www.vim.org/), although neovim is considered to be used over vim. Should you enjoy using vi outside your terminal you can use [oni](https://www.onivim.io/). [SpaceVim](https://spacevim.org/) provides a good configuration base and is referenced in all three vi editors.

For tasks you don't want to solve in vi you can use [Intellij IDEA ultimate](https://www.jetbrains.com/idea/) or [Sublime3](https://www.sublimetext.com/). The Sublime configuration comes with a few [useful plugins](.dotfiles/tag-smu/modules/editor/editor.sh#L8-L19) that are managed via [Package Control](https://packagecontrol.io/).
  
[Macdown](https://macdown.uranusjr.com/) for Markdown editing, [p4merge](https://www.perforce.com/products/helix-core-apps/merge-diff-tool-p4merge) for merging/diffing and [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) as default git difftool are also part of the editor module.

Apart from theme and font all editors come preconfigured, except Intellij. ([SpaceVim](.dotfiles/tag-smu/SpaceVim.d), [Oni](.dotfiles/tag-smu/config/oni), [Sublime](.dotfiles/tag-smu/modules/editor/sublime)). To synchronize your Intellij configuration i recommend using the official [Settings Sync plugin](https://www.jetbrains.com/help/idea/sharing-your-ide-settings.html#IDE_settings_sync) 

Why no atom or Visual Studio Code?  
The above editors fulfil my daily needs and neither atom or Visual Studio Code were able to handle **large** files in multiple attempts. Not having an incentive to switch i continue using Sublime.


#### [php](.dotfiles/tag-smu/modules/php)

Installs PHP5, PHP7 and [composer](https://getcomposer.org/) for package management via brew. PHP7 will be defined as global version.  
For each version the apcu, amqp, igbinary and xdebug extensions are installed via pecl, memcached is installed from source.
 
The [phpswitch script](https://github.com/philcook/brew-php-switcher) enables you to switch between the installed versions.

#### [ruby](.dotfiles/tag-smu/modules/ruby)

Installs [rbenv](https://github.com/rbenv/rbenv) for version management and [bundler](http://bundler.io/) for package management. ruby2 is installed and defined as global version via rbenv. 

When the terminal module is used the ruby installation will work out of the box as the required rbenv code is already in place. 

#### [python](.dotfiles/tag-smu/modules/python)

Installs [pyenv](https://github.com/pyenv/pyenv) for version management and [pipenv](https://github.com/pypa/pipenv) for package management. python2 and python3 are installed using pipenv. python3 will be defined as global version.

When the terminal module is used the python installation will work out of the box as the required pyenv code is already in place. 

#### [java](.dotfiles/tag-smu/modules/java)

Installs [sdkman](http://sdkman.io/) to manage all java-world related packages. java8, java10, kotlin1, maven3 and gradle4 are installed via sdkman. **java8** will be defined as global version. Android Studio is installed via brew cask.

#### [go](.dotfiles/tag-smu/modules/go)

Installs [goenv](https://github.com/syndbg/goenv) for version management and [dep](https://github.com/golang/dep) for package management. go1 is installed and defined as global version via goenv. 

When the terminal module is used the go installation will work out of the box as the required goenv code is already in place.

#### [web](.dotfiles/tag-smu/modules/web)

Installs [nodenv](https://github.com/nodenv/nodenv) for version management, npm comes with node for package management. node8 and node10 are installed using nodenv. node10 will be defined as global version.

When the terminal module is used the node installation will work out of the box as the required nodenv code is already in place. 

### Other components 

#### [The smu script](smu)

The `smu` script is wrapped with auto-generated [argbash.io](https://argbash.io/) code. It aims to make the usage of set-me-up as pleasant as possible.
It runs the given modules by sourcing the appropriate script and ensuring a few constraints: always run the base module and prioritize the macOS update to the beginning of the list. 
 
#### [update.sh](.dotfiles/tag-smu/modules/update.sh)

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
