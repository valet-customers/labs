# Migrate an Azure DevOps pipeline to GitHub Actions 
In this lab, you will use the Valet `migrate` command to migrate an Azure DevOps pipeline to GitHub Actions. The `migrate` subcommand can be used to convert a pipeline to its GitHub Actions equivalent and then create a pull request with the contents.

- [Prerequisites](#prerequisites)
- [Identify the Azure DevOps pipeline ID to use](#identify-the-azure-devops-pipeline-id-to-use)
- [Perform a migration](#perform-a-migration)
- [View the pull request](#view-the-pull-request)

## Prerequisites

1. Follow all steps [here](/labs/azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)
3. Completed the [Valet audit lab](valet-audit-lab.md).
4. Verify or add the following values to the `./valet/.env.local` file. All values were created [here](/labs/azure_devops#readme)
```
GITHUB_ACCESS_TOKEN=<GithHub PAT generated>
GITHUB_INSTANCE_URL=https://github.com/

AZURE_DEVOPS_PROJECT=<Project identified>
AZURE_DEVOPS_ORGANIZATION=<Org identified>
AZURE_DEVOPS_INSTANCE_URL=<DevOps instance>
AZURE_DEVOPS_ACCESS_TOKEN=<Token Generated>
```
### Example ###

![envlocal](https://user-images.githubusercontent.com/26442605/169069638-0bfa8f89-eaa9-423b-b2b7-447248e63e2b.png)

## Identify the Azure DevOps pipeline ID to use
You will need a pipeline ID to perform the migration
1. Go to the `valet/ValetBootstrap/pipelines` folder
2. Open the `valet/ValetBootstrap/pipelines/valet-pipeline1.config.json` file
3. Look for the `web - href` link
4. At the end of the link is the pipeline ID. Copy or note the ID.

### Example
![Screen Shot 2022-05-10 at 8 50 06 AM](https://user-images.githubusercontent.com/26442605/167670536-b46aa383-74bd-4e22-a782-0de5d0ce64a5.png)


## Perform a migration
You will use the codespace preconfigured in this repository to perform the migration.

1. Navigate to the codespace Visual Studio Code terminal 
2. Verify you are in the valet directory
3. Copy the following command and replace:
   - `GITHUB-ORG` with the name of your organization. 
   - `GITHUB-REPO` with the name of your repository. 
   - `PIPELINE-ID` with your pipeline ID.
4. Now, from the `./valet` folder in your repository, run `valet migrate` to migrate the pipeline to GitHub Actions. 
```
cd valet
gh migrate azure-devops pipeline --target-url https://github.com/GITHUB-ORG/GITHUB-REPO --pipeline-id PIPELINE-ID
```

### Example
![migrate-command](https://user-images.githubusercontent.com/26442605/161110277-45d9fff0-9d45-4946-a2a7-8f82fbb5d43f.png)

5. Valet will create a pull request directly to your GitHub repository.
6. Click the green pull request link in the output of the migrate command. See below.

### Example
![migrateoutput](https://user-images.githubusercontent.com/26442605/167672012-0580a215-29d4-4aff-a730-3e769414b1b7.png)

## View the pull request
The migrate output will show you the pull request on GitHub.

### Example
![migrate-pr](https://user-images.githubusercontent.com/26442605/161110724-f39d9cb9-1992-44c5-bea5-da2fcebb074c.png)
