## Overview

This is a template for a personal website created with grad students and postdocs in mind. However, others may find it a helpful template as well! We're hopeful that it will be relevant to those seeking industry as well as academic positions, however we are more familiar with academic websites.

This template uses quarto, you can learn more about quarto websites here: <https://quarto.org/docs/websites>.

This template is published via github pages. See below for a suggested publishing workflow which is essentially copied from the first suggested workflow in the [quarto github pages documentation](https://quarto.org/docs/publishing/github-pages.html). That page also lists other possible github pages workflows. There are many other options for publishing quarto websites, see [this page](https://quarto.org/docs/publishing/) for more information.

This template also allows for auto-updating of page content. You can use the template without enabling auto-updating, just delete/ignore the `auto_update.R` file and detele/ignore all blocks that start with `::: {.content-hidden unless-format="markdown"}`. For more information about auto-updating, see the last section of this readme.

This goal of this template is to provide several types of pages that might be relevant, but most personal websites don't have all of these pages!

## Suggested Github Pages Publication Workflow

1. (Already set up in template) Make sure that the readered pages go to a docs folder, by having `output-dir: docs` in the `quarto.yml` file.
2. Create a local git repository (for example with github desktop) in the same folder that contains the website R project.
    - A good option is to call the repository `your_github_username.github.io`, which gives it the URL `https://your_github_username.github.io`.
    - Otherwise, the URL will be `https://your_github_username.github.io/reponame/`.
4. (Already set up in template) Add a `.nojekyll` file to the root of your repository so that github pages doesn't attempt to use Jekyll to render the site. You can do this via the terminal command: `touch .nojekyll` (Mac/Linx) or `copy NUL .nojekyll` (Windows).
5. Commit the website to your local repository and then push it to github.
6. Go to the repository on the github website, then go to "Settings" and then click on the "Pages" section. Make sure the source is set to "Deploy from a Branch" and choose the "main" branch and the "/docs" folder.
7. Your site will now be updated and re-deployed anytime you push commits to the main branch. You can go the the "Actions" tab of the repository to see a record of these deployments and whether they ran successfully.
