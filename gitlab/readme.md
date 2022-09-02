# GitLab to Actions migrations powered by Valet
The instructions below will guide you through configuring a GitHub Codespace environment that will be used in subsequent labs that demonstrate how to use Valet to migrate GitLab pipelines to GitHub Actions.

These steps **must** be completed prior to starting other labs.

## Create your own repository for these labs
1. Ensure that you have created a repository using the [valet-customers/labs](https://github.com/valet-customers/labs) as a template.

## Configure your Codespace

1. Start the codespace

- Click the `Code` button down arrow above the repository on the repository's landing page.
- Click the `Codespaces` tab.
- Click `Create codespaces on main` to create the codespace.
- After the Codespace has initialized there will be a terminal present.

2. Verify the Valet CLI is installed and working. More information on the Valet extension for the official GitHub CLI can be found [here](https://github.com/github/gh-valet).

- Run the following command in the codespace's terminal:

  ```bash
  gh valet version
  ```

- Verify the output is similar to below.
  
  ```bash
  gh version 2.14.3 (2022-07-26)
  gh valet        github/gh-valet v0.1.12
  valet-cli       unknown
  ```

  - If `gh valet version` did not produce similar output then please follow the troubleshooting [guide](#troubleshoot-the-valet-cli).

## Bootstrap a GitLab Server

1. Execute the GitLab setup script that will start a container with a GitLab server running inside of it. The script should be executed when starting a new Codespace or restarting an existing one.

- Run the following command from the codespace's terminal
  
  ```bash
  source gitlab/bootstrap/setup.sh
  ```
  
2. Wait for the script to finish and then verify you can login to the GitLab Server.

- Click the `PORTS` tab in the codespace terminal window.
- In the row that starts with `80` mouse over the address under the column heading `Local Address`, and click the globe icon.
- Verify a new browser tab opened to the GitLab login screen.
- Login using the following credentials:
  - Username: `root` 
  - Password: `valet-labs!`
- Verify that you can see the auto populated projects in GitLab, under the `valet` namespace by clicking the `Menu` icon in GitLab, then `Your projects`.

## Labs for GitLab

Perform the following labs to test-drive Valet

1. [Configure credentials for Valet](1-configure.md)
2. [Perform an audit on GitLab pipelines](2-audit.md)
3. [Perform a dry-run of a GitLab pipeline](3-dry-run.md)
4. [Use custom transformers to customize Valet's behavior](4-custom-transformers.md)
5. [Forecast potential build runner usage](5-forecast.md)
6. [Perform a production migration of a GitLab pipeline](6-migrate.md)

## Troubleshoot the Valet CLI

The CLI extension for Valet can be manually installed by following these steps:

- Verify you are in the codespace terminal
- Run this command from within the codespace's terminal:

  ```bash
  gh extension install github/gh-valet
  ```

- Verify the result of the install contains:

  ```bash
  ✓ Installed extension github/gh-valet
  ```

- If you get an error similar to the image below, then click the link in the terminal output to authorize the token.
  - Restart the codespace after clicking the link.
  ![img](https://user-images.githubusercontent.com/26442605/169588015-9414404f-82b6-4d0f-89d4-5f0e6941b029.png)
- Verify Valet CLI extension is installed and working by running the following command from the codespace's terminal:

  ```bash
  gh valet version
  ```