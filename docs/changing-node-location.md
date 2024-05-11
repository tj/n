# Switching To `n` Managed Node.js

If you already have Node.js installed to a different root than `n` uses, you can easily end up with multiple copies of node (and npm, and npx, and globally installed packages!). Some common situations are you already had Node.js installed  using your Linux package manager, or using another node version manager, or using say Homebrew. The two main ways you might resolve this are:

- uninstall from the old directory and reinstall to the new directory
- put the `bin` directory that `n` uses early in the `PATH` environment variable, so the `n` installed node is found first

The simplest setup to understand is the first one. Just have one version of `node` installed.

Let's walk-through the process of switching over from using Homebrew as an example. Let's start off with Node.js installed, `npm` updated, and an example global npm package. The key point is there are two install prefixes involved:

- old: `/opt/homebrew`
- new: `/usr/local`

```console
% brew install node
% npm install --global npm@latest
% npm install --global @shadowspawn/forest-arborist
% brew list node
/opt/homebrew/Cellar/node/21.7.3/bin/node
/opt/homebrew/Cellar/node/21.7.3/bin/npm
/opt/homebrew/Cellar/node/21.7.3/bin/npx
/opt/homebrew/Cellar/node/21.7.3/etc/bash_completion.d/npm
/opt/homebrew/Cellar/node/21.7.3/include/node/ (107 files)
/opt/homebrew/Cellar/node/21.7.3/libexec/bin/ (2 files)
/opt/homebrew/Cellar/node/21.7.3/libexec/lib/ (2012 files)
/opt/homebrew/Cellar/node/21.7.3/share/doc/ (2 files)
/opt/homebrew/Cellar/node/21.7.3/share/man/man1/node.1
% command -v node
/opt/homebrew/bin/node
% command -v npm 
/opt/homebrew/bin/npm
% npm prefix --global
/opt/homebrew
```

Before we start transferring, list the global npm packages in the "old" location. We will refer back to this list.

```console
% npm list --global
/opt/homebrew/lib
├── @shadowspawn/forest-arborist@12.0.0
└── npm@10.5.0
```

We could clean out the old location first, but let's install `n` and another copy of node and see what that looks like. We end up with two versions of node, and the active one is still the Homebrew managed version.

```console
% brew install n
% n lts
  installing : node-v20.12.2
       mkdir : /usr/local/n/versions/node/20.12.2
       fetch : https://nodejs.org/dist/v20.12.2/node-v20.12.2-darwin-arm64.tar.xz
     copying : node/20.12.2
   installed : v20.12.2 to /usr/local/bin/node
      active : v21.7.3 at /opt/homebrew/bin/node
% command -v node
/opt/homebrew/bin/node
% which -a node
/opt/homebrew/bin/node
/usr/local/bin/node
% command -v npm
/opt/homebrew/bin/npm
% command -v npx
/opt/homebrew/bin/npx
% n doctor
<...>

CHECKS

Checking n install destination is in PATH...
good

Checking n install destination priority in PATH...
⚠️ There is a version of node installed which will be found in PATH before the n installed version.

Checking npm install destination...
⚠️ There is an active version of npm shadowing the version installed by n. Check order of entries in PATH.
   installed : /usr/local/bin/npm
      active : /opt/homebrew/bin/npm

<...>
```

Now let's switch over. Delete everything from the old location. Delete all the global npm packages _except_ npm itself, then delete npm, then delete node.

```console
npm uninstall --global @shadowspawn/forest-arborist

npm uninstall --global npm

brew uninstall node
```

Check the active binaries are now the ones installed by `n`:
```console
% command -v node
/usr/local/bin/node
% command -v npm 
/usr/local/bin/npm
% command -v npx
/usr/local/bin/npx
```

And lastly, reinstall the global npm packages you started with:
```
% npm prefix --global
/usr/local
% npm install --global npm@latest
% npm install --global @shadowspawn/forest-arborist
% npm list -g
/usr/local/lib
├── @shadowspawn/forest-arborist@12.0.0
└── npm@10.5.0
```
