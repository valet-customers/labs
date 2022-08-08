# Valet labs for GitLab

This lab bootstraps a Valet environment using GitHub Codespaces and enables you to run the Valet CI/CD migration tool against an isolated GitLab instance running in Docker. 

- [Use this Repo as a template](#repo-template)
- [Prerequisites](#prerequisites)
- [Codespace secrets](#codespace-secrets)
- [Use Valet with a codespace](#use-valet-with-a-codespace)
- [Labs for GitLab](#labs-for-gitlab)

## Repo template

1. Verify you are in your own Repository created from the [Valet Labs](https://github.com/valet-customers/labs) template.

## Prerequisites
1. Create a GitHub personal access token. 
    - Navigate to your GitHub `Settings` - click your profile photo and click `Settings`.
    - Go to `Developer Settings`
    - Go to `Personal Access Tokens` -> `Legacy tokens (if present)`
    - Click `Generate new token` -> `Legacy tokens (if present)`. If required, provide your password.
    - Select at least these scopes: `read packages` and `workflow`. Optionally, provide a text in the **Note** field and change the expiration.
    - Click `Generate token`
    - Copy the PAT somewhere safe and temporary.

## Codespace secrets
Add the following Codespace secrets.
- `VALET_GHCR_PASSWORD`: Add `VALET_GHCR_PASSWORD` as the `Name` and the GitHub personal access token created above as the value.

Steps to create the codespace secrets. Complete for secret noted above:

- Navigate to the `Settings` tab in this repo
- Find `Secrets` and click the down arrow
- Click `Codespaces`
- Click `New Repository Secret` to create a new secret
- Name the secret as noted above
- Paste in the value noted above
- Click `Add Secret`

## Use Valet with a codespace

1. Start the codespace
    - Click the `Code` button down arrow above repository on the repository's landing page.
    - Click the `Codespaces` tab
    - Click `Create codespaces on main` to create the codespace. If you are in another branch then the `main` branch, the codespace will button will have the current branch specified.
    - Wait a couple minutes, then verify that the codespace starts up. Once it is fully booted up, the terminal should be present.
2. Verify Valet CLI is installed and working. More information on the [GitHub Valet CLI extension](https://github.com/github/gh-valet)
    -  Run `gh valet version` in the codespace terminal and verify it returns results like below, actual versions will vary
    ```
        gh version 2.14.3 (2022-07-26)
        gh valet        github/gh-valet v0.1.12
        valet-cli       v0.1.0.13392
    ```
    if results do not match try manually installing the valet extension, using the [troubleshooting](#troubleshooting) section
    
3. Run the GitLab setup script.  This script will setup GitLab and ensure it is ready to use.  In general, this script should be run first if you are starting a new codespace or restarting an existing one.  
   -  from the codespace terminal run `source gitlab/setup.sh`

4. Verify you can login to the GitLab Server.
   - Click the `PORTS` tab in the codespace terminal
   - In the row that starts with `80` click the globe icon under the column heading `Local Address`
   - Verify a new browser tab opened to the GitLab login screen
   - Login in with the username and password printed in the terminal after step 3, if that is not available anymore you can run the command again in the terminal to get it `source gitlab/setup.sh`
   - Verify that you can see the auto populated projects in GitLab, under the `valet` namespace by clicking the `Menu` icon, then `Your projects`

## Labs for GitLab
Perform the following labs to test-drive Valet
- TBD

## Troubleshooting
-  **GitHub CLI Valet extension is not installed**. More information on the [GitHub Valet CLI extension](https://github.com/github/gh-valet)
   -  Verify you are in the codespace terminal
   -  Run `gh extension install github/gh-valet`
   -  Verify the result of the command is: `✓ Installed extension github/gh-valet`
   -  If you get a similar error to the following, click the link to authorize the token
      ![linktolcickauth](https://user-images.githubusercontent.com/26442605/169588015-9414404f-82b6-4d0f-89d4-5f0e6941b029.png)
   - Restart the codespace after clicking the link
- **Port 80 is not being forwarded for GitLab server**. This should be auto detected by codespaces, but can be manually setup by:
  - In the codespace terminal click the PORTS tab
  - Click the "Add Port" button
  - Enter 80 and hit enter
