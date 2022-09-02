# Perform an audit on GitLab pipelines

In this lab, you will use Valet to `audit` a GitLab namespace. The `audit` command will scan the GitLab namespace for all projects with pipelines that have run at least once, perform a `dry-run` on each of those pipelines, and finally perform an aggregation of all of the transformed workflows. This aggregate summary can be used as a planning tool and help understand how complete of a migration is possible with Valet.
The goal of this lab is to performed an audit on the demo GitLab instance, and gain a good understanding of the components that make up an audit output.

- [Prerequisites](#prerequisites)
- [Perform an audit](#perform-an-audit)
- [Audit Files](#audit-files)
- [Review audit summary](#review-audit-summary)
- [Review the Pipelines Section](#review-the-pipelines-section)
- [Next Lab](#next-lab)

## Prerequisites

1. Follow all steps [here](../gitlab#readme) to set up your environment.
2. Follow all steps [here](../gitlab#valet-configure-lab) to configure Valet.

## Perform an audit

1. Collect information for constructing `audit` command:
- What namespace or group do we want to audit? __valet__
- Where do we want to store the result? __tmp/audit__

2. Navigate to the codespace terminal.

3. Run the Valet audit command using the answers from step 1:
  
```
gh valet audit gitlab --output-dir tmp/audit --namespace valet
```

4. Valet will print the locations of the audit results in the terminal when complete.

5. Verify the audit results are present in the explorer.
  
<img width="360" alt="Screen Shot 2022-08-16 at 9 57 36 AM" src="https://user-images.githubusercontent.com/18723510/184898037-1212493b-25e2-44b8-a3dc-2b6ef703daf3.png">

## Audit Files

The `audit` command outputs the following files:

| File Type  |  Naming Convention |  Description |
| ----------------- | ------------------------- | ---------------------------- |
| GitLab pipeline source | valet/PROJECT_NAME.source.yml | The `.gitlab-ci.yml` file in the GitLab Project |
| GitLab project configuration | valet/PROJECT_NAME.config.json | Contains meta data retrieved for the GitLab Project |
| Valet log file | log/valet-TIMESTAMP.log |  Log generated during an audit. Mainly used for troubleshooting |
| GitHub Actions workflows | valet/PROJECT_NAME.yml | GitHub Actions workflow that would be migrated to GitHub |
| Error file | valet/PROJECT_NAME.error.txt | Created when there is a error transforming the pipeline |
| Audit summary | audit_summary.md | Contains a summary of audit results and the main file of interest to understand the how complete of a migration can be done with Valet |
| GitHub Actions Reusable Workflows | .github/workflows/NAME_HERE.yml | Will only appear if Valet encountered a pipeline that would generated them. |
| GitHub Composite Actions | .github/actions/NAME_HERE.yml | Will only appear if Valet encountered a pipeline that would generated them. |

## Review audit summary

1. Under the `audit` folder find the `audit_summary.md`.

2. Right-click the `audit_summary.md` file and select `Open Preview`.

3. This file contains details about what can be migrated 100% automatically vs. what will need some manual intervention or aren't supported by GitHub Actions.

4. Review the file, it should match the `audit_summary` below:
<details>
<summary> Click to expand <code>audit_summary.md</code></summary>
  
```yaml
# Audit summary

Summary for [GitLab instance](http://localhost/valet)

- Valet version: **0.1.0.13413 (9623ae73787971925a4a05e83a947108291d2f15)**
- Performed at: **8/17/22 at 13:38**

## Pipelines

Total: **11**

- Successful: **10 (90%)**
- Partially successful: **0 (0%)**
- Unsupported: **1 (9%)**
- Failed: **0 (0%)**

### Job types

Supported: **10 (90%)**

- YAML: **10**

Unsupported: **1 (9%)**

- Auto DevOps: **1**

### Build steps

Total: **134**

Known: **133 (99%)**

- script: **62**
- checkout: **35**
- before_script: **19**
- artifacts: **5**
- after_script: **4**
- dependencies: **4**
- cache: **3**
- pages: **1**

Unsupported: **1 (0%)**

- artifacts.terraform: **1**

Actions: **135**

- run: **85**
- actions/checkout@v2: **35**
- actions/upload-artifact@v2: **5**
- actions/download-artifact@v2: **4**
- actions/cache@v2: **3**
- ./.github/workflows/a-.gitlab-ci.yml: **1**
- ./.github/workflows/b-.gitlab-ci.yml: **1**
- JamesIves/github-pages-deploy-action@4.1.5: **1**

### Triggers

Total: **30**

Known: **30 (100%)**

- manual: **10**
- merge_request: **10**
- push: **10**

Actions: **20**

- workflow_dispatch: **10**
- push: **10**

### Environment

Total: **0**

Actions: **2**

- PASSWORD: **1**
- ENVIRONMENT: **1**

### Other

Total: **10**

Known: **10 (100%)**

- auto_cancel_pending_pipelines: **10**

Actions: **53**

- image: **23**
- cancel_in_progress: **10**
- group: **10**
- GIT_SUBMODULE_STRATEGY: **3**
- docker:dind: **2**
- PLAN_JSON: **1**
- mysql:latest: **1**
- PLAN: **1**
- redis:latest: **1**
- postgres:latest: **1**

### Manual tasks

Total: **1**

Secrets: **1**

- `${{ secrets.PASSWORD }}`: **1**

### Successful

#### valet/included-files-example

- [valet/included-files-example.yml](valet/included-files-example.yml)
- [valet/included-files-example.config.json](valet/included-files-example.config.json)
- [valet/included-files-example.source.yml](valet/included-files-example.source.yml)

#### valet/terraform-example

- [valet/terraform-example.yml](valet/terraform-example.yml)
- [valet/terraform-example.config.json](valet/terraform-example.config.json)
- [valet/terraform-example.source.yml](valet/terraform-example.source.yml)

#### valet/child-parent-example

- [valet/child-parent-example.yml](valet/child-parent-example.yml)
- [.github/workflows/a-.gitlab-ci.yml](.github/workflows/a-.gitlab-ci.yml)
- [.github/workflows/b-.gitlab-ci.yml](.github/workflows/b-.gitlab-ci.yml)
- [valet/child-parent-example.config.json](valet/child-parent-example.config.json)
- [valet/child-parent-example.source.yml](valet/child-parent-example.source.yml)

#### valet/include-file-example

- [valet/include-file-example.yml](valet/include-file-example.yml)
- [valet/include-file-example.config.json](valet/include-file-example.config.json)
- [valet/include-file-example.source.yml](valet/include-file-example.source.yml)

#### valet/basic-pipeline-example

- [valet/basic-pipeline-example.yml](valet/basic-pipeline-example.yml)
- [valet/basic-pipeline-example.config.json](valet/basic-pipeline-example.config.json)
- [valet/basic-pipeline-example.source.yml](valet/basic-pipeline-example.source.yml)

#### valet/gatsby-example

- [valet/gatsby-example.yml](valet/gatsby-example.yml)
- [valet/gatsby-example.config.json](valet/gatsby-example.config.json)
- [valet/gatsby-example.source.yml](valet/gatsby-example.source.yml)

#### valet/android-example

- [valet/android-example.yml](valet/android-example.yml)
- [valet/android-example.config.json](valet/android-example.config.json)
- [valet/android-example.source.yml](valet/android-example.source.yml)

#### valet/dotnet-example

- [valet/dotnet-example.yml](valet/dotnet-example.yml)
- [valet/dotnet-example.config.json](valet/dotnet-example.config.json)
- [valet/dotnet-example.source.yml](valet/dotnet-example.source.yml)

#### valet/node-example

- [valet/node-example.yml](valet/node-example.yml)
- [valet/node-example.config.json](valet/node-example.config.json)
- [valet/node-example.source.yml](valet/node-example.source.yml)

#### valet/rails-example

- [valet/rails-example.yml](valet/rails-example.yml)
- [valet/rails-example.config.json](valet/rails-example.config.json)
- [valet/rails-example.source.yml](valet/rails-example.source.yml)

### Failed

#### valet/autodevops-example

- [valet/autodevops-example.error.txt](valet/autodevops-example.error.txt)
- [valet/autodevops-example.config.json](valet/autodevops-example.config.json)

```
  
</details>
   
## Review the Pipelines Section

The audit summary starts by giving a summary of the types of pipelines that were extracted.

```yaml
## Pipelines

Total: **11**

- Successful: **10 (90%)**
- Partially successful: **0 (0%)**
- Unsupported: **1 (9%)**
- Failed: **0 (0%)**
```
- It shows that there were a total of 11 pipelines extracted.
- 90% were successful. This means that Valet knew how to map **all** the constructs of the pipeline to a GitHub Actions equivalent.
- 0% were partially successful. If there were pipelines that fell into this category it would means that Valet knew how to map **less than 100%** of the constructs to a Github Actions equivalent.
- 9% were unsupported. This means that the pipeline is fundamentally unsupported by Valet. In this example it is because one of the projects has Auto DevOps enabled.
- 0% of these fail altogether. If there were pipelines that fall into this category, that would mean that those pipelines were misconfigured or there was an issue with Valet.

Under the `Job types` section, we can see that the `audit` command was able to transform 10 YAML pipelines and encountered a unsupported Auto Devops pipeline

```yaml
### Job types

Supported: **10 (90%)**

- YAML: **10**

Unsupported: **1 (9%)**

- Auto DevOps: **1**
```

- Under the `Build steps` section we can see a breakdown of the build steps that are used in the pipelines and what was `Known` and `Unsupported` by Valet.  In a later lab we will address the unsupported step `artifacts.terraform`.

```yaml
### Build steps

Total: **134**

Known: **133 (99%)**

- script: **62**
- checkout: **35**
- before_script: **19**
- artifacts: **5**
- after_script: **4**
- dependencies: **4**
- cache: **3**
- pages: **1**

Unsupported: **1 (0%)**

- artifacts.terraform: **1**
```

Under the `Actions` section in `Build Steps` we have the list of the Actions that were used in order to implement the transformation of all of these build steps. 

```yaml
Actions: **135**

- run: **85**
- actions/checkout@v2: **35**
- actions/upload-artifact@v2: **5**
- actions/download-artifact@v2: **4**
- actions/cache@v2: **3**
- ./.github/workflows/a-.gitlab-ci.yml: **1**
- ./.github/workflows/b-.gitlab-ci.yml: **1**
- JamesIves/github-pages-deploy-action@4.1.5: **1**
```

Valet is a planning tool that can help in facilitating the migration into GitHub Actions and this list of Actions is a great place to understand what dependencies you would be taking on third-party Actions after this migration.  For example, if you are doing things like setting up the allow list of third-party Actions in a GitHub Enterprise server instance this list of Actions is a fantastic place to begin security reviews and audits of what third-party actions to depend on.

Valet breaks down the pipeline components further into `Triggers`, `Environment`, `Other`, and `Manual tasks`. 
- Triggers are a list of pipeline trigger found
- Environment are a list of project variables found
- Manual tasks are a list of user tasks that needs to be done in order for a pipeline to be functional when migrating to GitHub, such as adding `secrets` for a masked project variable, like we see here for the variable `PASSWORD`.  In a later lab we will see how these manual tasks appear on a pull request when we do a migration.
  ```
  Secrets: **1**

  - `${{ secrets.PASSWORD }}`: **1**
  ```
- Other is a catch all for all other components

The remaining sections `Successful` and `Failed` are groupings of the generated audit files.  For example, the project `child-parent-example` was successfully transformed and can be found under the `Successful` section, with all of the associated file links listed under the project name.  

```yaml
#### valet/child-parent-example

- [valet/child-parent-example.yml](valet/child-parent-example.yml)
- [.github/workflows/a-.gitlab-ci.yml](.github/workflows/a-.gitlab-ci.yml)
- [.github/workflows/b-.gitlab-ci.yml](.github/workflows/b-.gitlab-ci.yml)
- [valet/child-parent-example.config.json](valet/child-parent-example.config.json)
- [valet/child-parent-example.source.yml](valet/child-parent-example.source.yml)
```
Note: this has files under the `.github` directory. This tells us that this pipeline generated reusable workflows from the `include` statements used in the source pipeline.  

### Next Lab
[Perform a dry-run of a GitLab pipeline](3-dry-run.md)