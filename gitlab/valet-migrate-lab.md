# Migrate an Azure DevOps pipeline to GitHub Actions 
In this lab, we will use the Valet `migrate` command to migrate a GitLab pipeline to GitHub Actions. 
All of the previous commands we have been using, such as `audit` and `dry-run` have been preparing us to run the `migrate` command.
The `migrate` command is what will generate the GitHub Actions workflow files, like the `dry-run`, and create a pull request with the files.  
The pull request will also contain a checklist of `Manual Tasks` if required. These tasks are changes that Valet could not do on our behalf, like creating a runner or adding a secret to a repository.

- [Prerequisites](#prerequisites)
- [Preparing for migration](#preparing-for-migration)
- [Performing the migration](#performing-a-migration)
- [Reviewing the pull request](#reviewing-the-pull-request)
- [Next Lab](#next-lab)

## Prerequisites
1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md)

## Preparing for migration
Before running the command we need to collect some information:
  1. What is the project we want to migrate? TBD
  2. What is the namespace for that project? __Valet.  In this case the namespace is the same as the group the project is in__
  3. Where do we want to store the logs? __./tmp/migrate__. 
  4. What is the URL for GitHub Repository we want to add the workflow too? __We can use this repo__. *When constructing the value for the migrate command it should match the the url https://github.com/GITHUB-ORG-USERNAME-HERE/GITHUB-REPO-NAME-HERE with `GITHUB-ORG-USERNAME` and `GITHUB-REPO-NAME` substitued with your values*

## Performing a migration
1. Run `migrate` command using the information collected above, make sure to update the `--target-url` value with the information from step 4 above
```
gh valet migrate gitlab --target-url https://github.com/GITHUB-ORG-USERNAME-HERE/GITHUB-REPO-NAME-HERE --output-dir ./tmp/migrate --namespace valet --project rails-example
```
2. Valet will create a pull request directly in the target GitHub repository.
3. Open the pull request by clicking the green pull request link in the output of the migrate command. See below.
  ![pr-screen-shot](https://user-images.githubusercontent.com/18723510/184953133-9bafd9a1-c3f0-40b3-8414-f23cea698c8e.png)

## Reviewing the pull request
- Lets first look at the `Conversation` tab of the PR. Its telling us we have a manual task to perform before the GitHub Actions workflow is functional.  We need to a secret. We can use the GitHub [documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) for secrets and add a `actions` secret for `PASSWORD` with any value. 

- Next, lets review the workflow we are adding by clicking on `Files changed` tab. This is where you would double check everything looks good. 
- Now we want to go back to the `Conversation` tab and click `Merge pull request`
- Once the PR is merged the new workflow should start and we can view this by clicking `Actions` in the top navigation
  <img width="1119" alt="actions-screen-shot" src="https://user-images.githubusercontent.com/18723510/184960870-590b1a28-422f-4350-9ec0-0423bf7ad445.png">

### Next Lab
[Forecast GitLab Usage](../gitlab/valet-forecast-lab.md)