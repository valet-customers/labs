# Configure credentials for Valet

In this lab, you will use the `configure` CLI command to set the required credentials and information for Valet to use when working with GitLab and GitHub.

You will need to complete all of the setup instructions [here](./readme.md#configure-your-codespace) prior to performing this lab.

## Configuring credentials

1. Run the setup script in the codespace terminal to ensure the GitLab server is ready:
    ```bash
    ./gitlab/bootstrap/setup.sh
    ```

2. Open the GitLab server in a new browser tab:
    - Click the `PORTS` tab in the codespace terminal window.
    - In the `PORTS` tab find the row for port 80.
    - Hover over the address under the `Local Address` column and click the globe to "open in browser".

3. Create a GitLab personal access token (PAT):
    - Authenticate with the GitLab server using the following credentials:
      - Username: `root`
      - Password: `valet-labs!`
    - Follow the GitLab [instructions](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#create-a-personal-access-token) to generate a PAT.
      - Ensure the token has the `read_api` scope.
    - Copy the generated token and save it in a safe location.

4. Create a GitHub personal access token (PAT):
    - Open github.com in a new browser tab.
    - In the top right corner of the UI, click your profile photo and click `Settings`.
    - In the left panel, click `Developer Settings`.
    - Click `Personal access tokens` and then `Legacy tokens` (if present).
    - Click `Generate new token` and then `Generate new legacy token`. You may be required to authenticate with GitHub during this step.
    - Select the following scopes: `workflow` and `read:packages`.
    - Click `Generate token`.
    - Copy the generated PAT and save it in a safe location.

5. Run the `configure` CLI command:
    - Select the `TERMINAL` tab from within the codespace terminal window.
    - Run the following command: `gh valet configure`.
    - Use the down arrow key to highlight `GitLab CI`, press the spacebar to select, and then press enter to continue.
    - At the prompt, enter your GitHub username and press enter.
    - At the GitHub Container Registry prompt, enter the GitHub PAT generated in step 4 and press enter.
    - At the GitHub PAT prompt, enter the GitHub PAT generated in step 4 and press enter.
    - At the GitHub URL prompt, enter the GitHub instance URL or press enter to accept the default value (`https://github.com`).
    - At the GitLab CI token prompt, enter the GitLab CI access token from step 3 and press enter.
    - At the GitLab CI URL prompt, enter `http://localhost` and press enter.

    ![img](https://user-images.githubusercontent.com/18723510/183990474-d0b2559c-d2bf-40d9-ac43-19af53e45329.png)

## Verify your environment

To verify your environment is configured correctly, run the `update` CLI command. The `update` CLI command will download the latest version of Valet to your codespace.

1. In the codespace terminal run the following command:

   ```bash
   gh valet update
   ```

2. You should see a confirmation that you were logged into the GitHub Container Registry and Valet was updated to the latest version.

   ```bash
   Login Succeeded
   latest: Pulling from valet-customers/valet-cli
   Digest: sha256:a7d00dee8a37e25da59daeed44b1543f476b00fa2c41c47f48deeaf34a215bbb
   Status: Image is up to date for ghcr.io/valet-customers/valet-cli:latest
   ghcr.io/valet-customers/valet-cli:latest
   ```

### Next lab

[Perform an audit of a GitLab server](./2-audit.md)
