# Perform an audit of CircleCI

In this lab, you will use the `audit` command to get a high-level view of all projects in CircleCI.

The `audit` command operates by fetching all of the projects defined in CircleCI , converting each to their equivalent GitHub Actions workflow, and writing a report that summarizes how complete and complex of a migration is possible with Valet.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your Codespace environment.
2. Completed the [configure lab](./1-configure.md#configure-credentials-for-valet).

## Perform an audit

We will be performing an audit against a organization in CircleCI created for the purpose of this lab. The name of this organization was already set during the configure lab.  The only question that remains to be answered is:

1. Where do we want to store the result?
    - __./tmp/audit__.  This can be any path within the working directory that Valet commands are executed from.

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh valet audit circle-ci --output-dir tmp/audit
    ```

3. The command will list all the files written to disk in green when the command succeeds.

## Inspect the output files

1. Find the `audit_summary.md` file in the file explorer.
2. Right-click the `audit_summary.md` file and select `Open Preview`.
3. This file contains details that summarizes what percentage of your pipelines were converted automatically.

### Review audit summary

#### Pipelines

The pipeline summary section contains high level statistics regarding the conversion rate done by Valet:

```md
UPDATE_ME
```

Here are some key terms in the “Pipelines” section in the above example:

- __Successful__ pipelines had 100% of the pipeline constructs and individual items converted automatically to their GitHub Actions equivalent.
- __Partially successful__ pipelines had all of the pipeline constructs converted, however, there were some individual items that were not converted automatically to their GitHub Actions equivalent.
- __Failed pipelines__ encountered a fatal error when being converted. This can occur for one of three reasons:
  - The pipeline was misconfigured and not valid in CircleCI.
  - Valet encountered an internal error when converting it.
  - There was an unsuccessful network response, often due to invalid credentials, that caused the pipeline to be inaccessible.

The "Job types" section will summarize which types of pipelines are being used and which are supported or unsupported by Valet.

#### Build steps

The build steps summary section presents an overview of the individual build steps that are used across all pipelines and how many were automatically converted by Valet.

```md
UPDATE_ME
```

Here are some key terms in the "Build steps" section in the above example:

- A __known__ build step is a step that was automatically converted to an equivalent action.
- An __unknown__ build step is a step that was not automatically converted to an equivalent action.
- An __unsupported__ build step is a step that is either:
  - A step that is fundamentally not supported by GitHub Actions.
  - A step that is configured in a way that is incompatible with GitHub Actions.
- An __action__ is a list of the actions that were used in the converted workflows. This is important for the following scenarios:
  - Gathering the list of actions to sync to your appliance if you use GitHub Enterprise Server.
  - Defining an organization-level allowlist of actions that can be used. This list of actions is a comprehensive list of which actions their security and/or compliance teams will need to review.

There is an equivalent breakdown of build triggers, environment variables, and other uncategorized items displayed in the audit summary file.

#### Manual Tasks

The manual tasks summary section presents an overview of the manual tasks that you will need to perform that Valet is not able to complete automatically.

```md
UPDATE_ME and update pipeline to add this section
```

Here are some key terms in the “Manual tasks” section in the above example:

- A __secret__ refers to a repository or organization level secret that is used by the converted pipelines. These secrets will need to be created manually in Actions in order for these pipelines to function properly.
- A __self-hosted runner__ refers to a label of a runner that is referenced by a converted pipeline that is not a GitHub-hosted runner. You will need to manually define these runners in order for these pipelines to function properly.

#### Files

The final section of the audit report provides a manifest of all of the files that are written to disk during the audit. These files include:

```md
UPDATE_ME
```

Each pipeline will have a variety of files written that include:

- The original pipeline as it was defined in GitHub.
- Any network responses used to convert a pipeline.
- The converted workflow.
- Stack traces that can used to troubleshoot a failed pipeline conversion

### Next lab

[Perform a dry-run of a GitLab pipeline](3-dry-run.md)