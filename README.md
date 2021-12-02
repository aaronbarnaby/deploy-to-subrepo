# Deploy to SubRepo

This GitHub Action was built to handle copying files/folders from the current repository to another location in a seperate repository.

# Example Workflow
    name: Workflow

    on: push

    jobs:
      copy:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout
          uses: actions/checkout@v2

        - name: Pushes test file
          uses: aaronbarnaby/deploy-to-subrepo@v1.0.1
          env:
            API_TOKEN: ${{ secrets.GITHUB_API_TOKEN }}
          with:
            source: 'folder'
            target_repo: 'username-or-org/repository-name'
            target_folder: 'target-folder'
            commit_email: 'actions@github.com'
            commit_name: 'actions'
            commit_message: 'message for target commit'

# Variables

The `GITHUB_API_TOKEN` needs to be set in the `Secrets` section of your repository options. You can retrieve the `GITHUB_API_TOKEN` [here](https://github.com/settings/tokens) (set the `repo` permissions).

* source: The file or directory to be copied.
* target_repo: The repository to place the file or directory in.
* target_folder: [optional] The folder in the destination repository to place the file in, if not the root directory.
* target_branch: [optional] The branch of the source repo to update, if not "main" branch is used.
* commit_email: [optional] Email address for the commit
* commit_name: [optional] Username for the commit
* commit_message: [optional] A message for the commit. Defaults to `Update from https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}`

# Behavior Notes
The action will create any destination paths if they don't exist. It will also overwrite existing files if they already exist in the locations being copied to. It will not delete the entire destination repository.
