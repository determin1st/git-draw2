# Git Draw 2

Allows you to draw in your GitHub heatmap.  
Inspired by [git-draw](https://github.com/ben174/git-draw)  

## Requirements

* [GitHub account](https://github.com/join)
* [git](https://git-scm.com/downloads)
* [node.js](https://nodejs.org)
* [Chrome](https://www.google.com/chrome)
* this extention (un-published)
  * [download](https://github.com/determin1st/git-draw2/blob/master/git-draw2.7z) and unpack the archive
  * open Chrome and goto extentions, ***chrome://extensions***
  * switch to developer mode
  * install unpacked extention
  * if you manage to publish it, [drop me a link](https://t.me/determin1st), pls

## How to draw

* [Create new](https://github.com/new), disposable repository on GitHub.
  * *prefer **git-drawing** name as it's set as default*
  * *it should be the one you can delete without regrets*
  * *it may be empty*
* Go to your GitHub account overview.
  * *the extention will inject controls for drawing*
  * *it will work only with owner's account*
* Use extention to **Draw**.
  * *select color from the legend and draw with your pointer*
  * *if some color doesn't apply properly, apply it incrementally*
  * *button works as a reset switch*
* When you finish, **Get script**.
  * *the download of **git-draw.js** should start*
* Run script with node.js.
  * *it will ask for the repo's name*
  * *it will ask for confirmation*
  * *git makes only empty commits*
  * *git should be configured to push the change*
* Done.
  * *reload the page to see changes*
  * *it changes instantly, but GitHub says it may take some time*

## How to erase drawing

* Delete the repository with the drawing.
  * *goto repository settings, at the bottom*
  * *confirm*
* Done.



