# Using Custom Transformers in a `dry-run`

In this lab we want to do a `dry-run` of the `test_pipeline` pipeline, however, after a closer inspection, we discovered that we will need to customize how Valet transforms:

1. Steps that are unsupported by Valet, but are essential to our devops process.
2. Steps in which the GitHub action chosen by Valet does not meet our current needs.
3. All pipelines that have the environment variable `DB_ENGINE` must be changed to a different value: `mongodb`.
4. The self-hosted runners before used the `TeamARunner` label in Jenkins but will run on the `ubuntu-latest` runner in Actions.

These customizations will be present in many of our company's pipelines and an automated way to apply these changes would be ideal. In this lab, we will use the `--custom-transformers` flag to change the behavior of Valet using its DSL built on top of the Ruby language.

- [Prerequisites](#prerequisites)
- [Perform a dry-run](#perform-a-dry-run)
- [Custom transformers for an unknown step](#custom-transformers-for-an-unknown-step)
- [Custom transformers for an known step](#custom-transformers-for-a-known-step)
- [Custom transformers for environment variables](#custom-transformers-for-environment-variables)
- [Custom transformers for runners](#custom-transformers-for-runners)
- [Next Lab](#next-lab)

## Prerequisites

1. Followed the steps [here](../jenkins/readme.md#valet-labs-for-jenkins) to set up your Codespace environment and start a Jenkins server.
2. Completed the [configure lab](../jenkins/valet-configure-lab.md#configure-valet-to-work-with-jenkins) to configure the Valet CLI.
3. Completed the [dry-run lab](../jenkins/valet-dry-run-lab.md#dry-run-the-migration-of-a-jenkins-pipeline-to-github-actions).

## Perform a dry-run

- Let’s run the `dry-run` command to see what information we can get from the generated action yaml.

  ```bash
    gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline -o .tmp/jenkins/dry-run
  ```

- Open the resulting GitHub Actions workflow by navigating to `tmp/valet/test_pipeline.yml` from the explorer

__Click to Expand__
<details>
  <summary><em>Actions Workflow</em></summary>

```yaml
name: test_pipeline
on:
  push:
    paths: "*"
  schedule:
  - cron: 0-29/10 * * * *
env:
  DISABLE_AUTH: 'true'
  DB_ENGINE: sqlite
jobs:
  check_env_variables:
    runs-on:
      - self-hosted
      - TeamARunner
    steps:
    - name: checkout
      uses: actions/checkout@v2
    - name: echo message
      run: echo "Database engine is ${{ env.DB_ENGINE }}"
#     # This item has no matching transformer
#     - sleep:
#       - key: time
#         value:
#           isLiteral: true
#           value: 80
    - name: echo message
      run: echo "DISABLE_AUTH is ${{ env.DISABLE_AUTH }}"
  build:
    runs-on:
      - self-hosted
      - TeamARunner
    needs: check_env_variables
    steps:
    - name: checkout
      uses: actions/checkout@v2
    - name: Set up JDK 1.11
      uses: actions/setup-java@v1
      with:
        java-version: '1.11'
        settings-path: "${{ github.workspace }}"
    - name: sh
      shell: bash
      run: mvn clean package
  test:
    runs-on:
      - self-hosted
      - TeamARunner
    needs: build
    steps:
    - name: checkout
      uses: actions/checkout@v2
    - name: Publish test results
      uses: EnricoMi/publish-unit-test-result-action@v1.7
      if: always()
      with:
        files: "**/target/*.xml"
```

</details>

Go back to the previous lab [dry-run Jenkins pipeline](../jenkins/valet-dry-run-lab.md#dry-run-the-migration-of-a-jenkins-pipeline-to-github-actions) if you need a review of the details of the dry-run.

## Custom transformers for an unknown step

We can see in the center of the transformed workflow that the `sleep` step was not transformed. In order for us to write a custom transformer for this we need to know the identifier. In general, the identifier will be the key of a key/value pair within the step of a Jenkinsfile, which in this case is `sleep`.  This is how our custom transformer will target the correct step.

After some research we have decided that a simple bash script will meet our needs:

  ```yaml
    - name: Sleep for 80 seconds
      run: sleep 80s
      shell: bash
  ```

Now that we know the final yaml needed for the transformer, we can start to write the ruby file.The custom transformers file can have any name, but it is recommended that you use an `.rb` extension so the codespaces editor knows it is a ruby file and can provide syntax highlighting.

- Create a new file where you will put the custom transformers logic. It can have any file name, but it is recommended that you use an `.rb` extension so the codespaces editor knows it is a ruby file and can provide syntax highlighting. For this example we will call it `transformers.rb`.

In the custom transformers file we will add a `transform` method.  This is a special method that Valet exposes, that takes the identifier we determined earlier and returns a ruby hash of the final YAML for the pipeline.

The ruby hash can be thought of as the JSON representation of the YAML we want. Valet will call that method when it encounters the identifier and pass in an `item`. The `item` is the key of that key/value pair defined for that step in Jenkins. In this case the item is the settings of the sleep command.

  ```ruby
  transform "sleep" do |item|
    wait_time = item["arguments"][0]["value"]["value"]

    {
      "name": "Sleep for #{wait_time} seconds",
      "run": "sleep #{wait_time}s",
      "shell": "bash"
    }
  end
  ```

Let’s run the `dry-run` command again with `--custom-transformer transformers.rb` to see if our custom transformer worked.

```bash
gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline -o .tmp/jenkins/dry-run --custom-transformers transformers.rb
```

When you open the file you should see the following changes in the GitHub Actions Workflow, note how the sleep timer step is no longer commented out!

```diff
- #     # This item has no matching transformer
- #     - sleep:
- #       - key: time
- #         value:
- #           isLiteral: true
- #           value: 80
+  - name: Sleep for 80 seconds
+    run: sleep 80s
+    shell: bash
```

## Custom transformers for a known step

Next lets address the third-party GitHub action `EnricoMi/publish-unit-test-result-action@v1.7` that Valet chose for the `junit` step.  This action does not meet our needs because our CTO has dictated that our pipelines take no dependencies on third-party actions. We can customize the action that we would like Valet to use instead.

After some research we find that the following action will upload an artifact with the junit test results without depending on a third party action.

```yaml
- uses: actions/upload-artifact@v3
  with:
    name: junit-artifact
    path: path/to/artifact/world.txt
```

We will build this custom transformer similar to how we built the previous custom transformer. This time, we need to add some additional logic. We would like to programmatically assign the file path to junit's test results to our upload action.

The challenge is, that we are unsure what `item` represents (what the incoming JSON object looks like from Jenkins). In order to troubleshoot this, you could use some basic ruby to print `item` to the terminal. You can achieve this by adding the following line in the transform method: `puts "This is the item: #{item}"`.

You are able to add multiple custom transformers to the same file, so you can add this one right below the previous custom transformer.

```ruby
transform "junit" do |item|
  puts "This is the item: #{item}"
end
```

Let’s run the `dry-run` command to see what information is outputted in the terminal.

```bash
gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline -o .tmp/jenkins/dry-run --custom-transformers transformers.rb
```

You should see something like the following outputted into the terminal:

<img width="1113" alt="Screen Shot 2022-08-17 at 10 25 53 AM" src="https://user-images.githubusercontent.com/19557880/186782050-65ece0c4-52a3-4f88-818f-0f860c50c2b7.png">

Now that we know the structure of the incoming JSON blob for `item` we can access the file path programmatically.

```ruby
transform "junit" do |item|
  test_results = item["arguments"].find{ |a| a["key"] == "testResults" }
  file_path = test_results.dig("value", "value")

    [
      {
        "uses": "actions/upload-artifact@v3",
        "with": {
          "name": "junit-artifact",
          "path": file_path
        }
      }
    ]
end
```

Your file should include both custom transformers. Ensure it matches the file below:

__Click to Expand__
<details>
  <summary><em>Custom Transformer file</em></summary>

```ruby
  transform "sleep" do |item|
      wait_time = item["arguments"][0]["value"]["value"]

      {
        "name": "Sleep for #{wait_time} seconds",
        "run": "sleep #{wait_time}s",
        "shell": "bash"
      }
  end

  transform "junit" do |item|
    test_results = item["arguments"].find{ |a| a["key"] == "testResults" }
    file_path = test_results.dig("value", "value")

    [
      {
        "uses": "actions/upload-artifact@v3",
        "with": {
          "name": "junit-artifact",
          "path": file_path
        }
      }
    ]
  end
```

</details>

Let’s run the `dry-run` command again to see if our custom transformer worked.

```bash
gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline -o .tmp/jenkins/dry-run --custom-transformers transformers.rb
```

When you open the file you should see the`EnricoMi/publish-unit-test-result-action@v1.7` action has been replaced with the customized steps.

```diff
-    - name: Publish test results
-      uses: EnricoMi/publish-unit-test-result-action@v1.7
-      if: always()
-      with:
-        files: "**/target/*.xml"
+    - uses: actions/upload-artifact@v3
+      with:
+        name: junit-artifact
+        path: path/to/artifact/world.txt
```

## Custom transformers for environment variables

But wait! There's more we need to customize to make these pipelines fit our needs. Several of our pipelines will need to have the value of the `DB_ENGINE` environment variable changed from `sqlite` to `mongodb`.

Valet allows you to replace values of `variables` by using the `env` method. Let’s replace the value for `DB_ENGINE` by using the below line. The first value of the `env` method is the target variable name and the second is the new value to be used.

  ```ruby
  env "DB_ENGINE", "mongodb"
  ```

You can keep adding these transformer values to your `transformer.rb` file. Your transformer file should look like the one below:

__Click to Expand__
<details>
  <summary><em>Custom Transformer file</em></summary>

```ruby
  env "DB_ENGINE", "mongodb"

  transform "sleep" do |item|
      wait_time = item["arguments"][0]["value"]["value"]

      {
        "name": "Sleep for #{wait_time} seconds",
        "run": "sleep #{wait_time}s",
        "shell": "bash"
      }
  end

  transform "junit" do |item|
    test_results = item["arguments"].find{ |a| a["key"] == "testResults" }
    file_path = test_results.dig("value", "value")

    [
      {
        "uses": "actions/upload-artifact@v3",
        "with": {
          "name": "my-artifact",
          "path": file_path
        }
      }
    ]
  end
```

</details>

Let’s run the `dry-run` command again to see if our custom transformer worked.

```bash
gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline -o .tmp/jenkins/dry-run --custom-transformers transformers.rb
```

When you open the outputed file you should see that the value for `DB_ENGINE` has been changed from `sqlite` to `mongodb`.

```diff
env:
  DISABLE_AUTH: 'true'
-  DB_ENGINE: sqlite
+  DB_ENGINE: mongodb
```

## Custom transformers for runners

Lastly, several of our pipelines will need to have the runner label updated from `TeamARunner` to `ubuntu-latest`.

Valet offers the ability to provide customized mapping between build agents in the source CI instance and their equivalent GitHub Actions runner labels by using the `runner` method. The syntax for this is similar to the `env` method.  

The `runner` methods first parameter is the Jenkins agent label and the second parameter is the GitHub Actions runner label(s) to map too. As an example, the following could be used:

  ```ruby
  runner "TeamARunner", "ubuntu-latest"
  ```

You can keep adding these transformer methods to your `transformer.rb` file. Your transformer file should look like the one below:

__Click to Expand__
<details>
  <summary><em>Custom Transformer file</em></summary>

```ruby
  runner "TeamARunner", "ubuntu-latest"

  env "DB_ENGINE", "mongodb"

  transform "sleep" do |item|
      wait_time = item["arguments"][0]["value"]["value"]

      {
        "name": "Sleep for #{wait_time} seconds",
        "run": "sleep #{wait_time}s",
        "shell": "bash"
      }
  end

  transform "junit" do |item|
    test_results = item["arguments"].find{ |a| a["key"] == "testResults" }
    file_path = test_results.dig("value", "value")

    [
      {
        "uses": "actions/upload-artifact@v3",
        "with": {
          "name": "my-artifact",
          "path": file_path
        }
      }
    ]
  end
```

</details>

Let’s run the `dry-run` command again to see if our custom transformer worked.

```bash
gh valet dry-run jenkins --source-url http://localhost:8080/job/test_pipeline -o .tmp/jenkins/dry-run --custom-transformers transformers.rb
```

When you open the file you should see that the value for `TeamARunner` has been changed to `ubuntu-latest`.

```diff
runs-on:
-  - self-hosted
-  - TeamARunner
+  - ubuntu-latest
```

Thats it! Congratulations you have customized transforming:

- unsupported steps
- steps that are supported but don't meet your requirements
- environment variables
- runners

## Next Lab
[Forecast Jenkins Usage](../jenkins/5-forecast.md#forecast-the-runner-usage-of-a-jenkins-instance)