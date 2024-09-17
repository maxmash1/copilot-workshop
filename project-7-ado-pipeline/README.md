# Project 7: Analyze pipeline config file

In this project you will identify what the pipeline config YAML file does using GH Copilot followed by documenting it.

- Analyze file.
- Document what it does.
- Convert to GH Actions yml format.
- Document what it does.
- Does it still do the same thing?

```YAML
trigger:
- main

pool:
  vmImage: 'ubuntu-22.04'

variables:
  container_name: ''
  container_owner: ''
  maven_changelist: ''
  maven_sha1: ''
  github_branch_name: ''
  github_short_sha: ''
  jar_version: ''
  artifact_name: ''
  artifact_path: ''

jobs:
- job: DefineBuildParameters
  displayName: Define Build Parameters
  steps:
  - checkout: self

  - task: NodeTool@0
    inputs:
      versionSpec: '14.x'
    displayName: 'Install Node.js'

  - script: |
      npm install
      node ./.github/workflows/scripts/buildParameters.js
    displayName: 'Define Build Parameters'
    env:
      GITHUB_REF: $(Build.SourceBranch)
      GITHUB_SHA: $(Build.SourceVersion)
      GITHUB_REPOSITORY: $(Build.Repository.Name)
      GITHUB_ACTOR: $(Build.RequestedFor)
      GITHUB_RUN_ID: $(Build.BuildId)
      GITHUB_RUN_NUMBER: $(Build.BuildId)
      GITHUB_WORKFLOW: $(Build.DefinitionName)
      GITHUB_HEAD_REF: $(System.PullRequest.SourceBranch)
      GITHUB_BASE_REF: $(System.PullRequest.TargetBranch)
      GITHUB_EVENT_NAME: $(Build.Reason)
      GITHUB_EVENT_PATH: $(Build.SourceBranch)
      GITHUB_ACTION: $(Build.DefinitionName)
      GITHUB_ACTIONS: true
      GITHUB_TOKEN: $(System.AccessToken)
    displayName: 'Run buildParameters.js'

  - powershell: |
      Write-Output "##vso[task.setvariable variable=container_name]$(container_name)"
      Write-Output "##vso[task.setvariable variable=container_owner]$(container_owner)"
      Write-Output "##vso[task.setvariable variable=maven_changelist]$(maven_changelist)"
      Write-Output "##vso[task.setvariable variable=maven_sha1]$(maven_sha1)"
      Write-Output "##vso[task.setvariable variable=github_branch_name]$(github_branch_name)"
      Write-Output "##vso[task.setvariable variable=github_short_sha]$(github_short_sha)"
    displayName: 'Set Build Parameters'

- job: PublishMavenDependencies
  displayName: Publish Maven dependencies
  dependsOn: DefineBuildParameters
  condition: eq(variables['Build.SourceBranch'], 'refs/heads/main')
  steps:
  - checkout: self

  - task: Maven@3
    inputs:
      mavenPomFile: 'pom.xml'
      goals: 'dependency:tree'
    displayName: 'Maven Dependency Tree Dependency Submission'

- job: BuildAndTest
  displayName: Build and Test
  dependsOn: DefineBuildParameters
  strategy:
    matrix:
      os: [ 'ubuntu-20.04', 'ubuntu-22.04' ]
      java: [ '11' ]
  pool:
    vmImage: $(os)
  steps:
  - checkout: self

  - task: UseJavaVersion@1
    inputs:
      versionSpec: '$(java)'
      jdkArchitectureOption: 'x64'
      jdkSourceOption: 'PreInstalled'
    displayName: 'Set up JDK $(java)'

  - script: |
      mvn package -B \
        -Dsha1="$(maven_sha1)" \
        -Dchangelist="$(maven_changelist)" \
        -Dgithub.repository="$(Build.Repository.Name)"
    displayName: 'Build Test and Package'

  - script: |
      cat target/classes/version.properties >> $(Build.ArtifactStagingDirectory)/version.properties
    displayName: 'Output Version'
    id: maven_version

  - powershell: |
      Write-Output "##vso[task.setvariable variable=jar_version]$(jar_version)"
      Write-Output "##vso[task.setvariable variable=artifact_name]application-jar"
      Write-Output "##vso[task.setvariable variable=artifact_path]target"
    displayName: 'Set artifact parameters'
    condition: eq(variables['Agent.OS'], 'Linux')

  - task: PublishBuildArtifacts@1
    inputs:
      PathtoPublish: '$(Build.ArtifactStagingDirectory)'
      ArtifactName: 'application-jar'
      publishLocation: 'Container'
    displayName: 'Upload application jar artifact'
    condition: eq(variables['Agent.OS'], 'Linux')

- job: BuildApplicationContainer
  displayName: Container Build - application
  dependsOn: 
    - DefineBuildParameters
    - BuildAndTest
  condition: ne(variables['Build.RequestedFor'], 'dependabot[bot]')
  steps:
  - checkout: self

  - task: Docker@2
    inputs:
      containerRegistry: '$(dockerRegistryServiceConnection)'
      repository: '$(container_owner)/$(container_name)'
      command: 'buildAndPush'
      Dockerfile: '**/Dockerfile'
      tags: |
        $(jar_version)
    displayName: 'Build and Publish Container'

- job: ContinuousDelivery
  displayName: Continuous Delivery Deployment
  dependsOn: 
    - DefineBuildParameters
    - BuildAndTest
    - BuildApplicationContainer
  condition: eq(variables['Build.SourceBranch'], 'refs/heads/main')
  steps:
  - checkout: self

  - task: AzureCLI@2
    inputs:
      azureSubscription: '$(azureSubscription)'
      scriptType: 'ps'
      scriptLocation: 'inlineScript'
      inlineScript: |
        $token = az ad app credential reset --id $(application_id) --append --credential-description "temp-token" --years 1 --query password -o tsv
        Write-Output "##vso[task.setvariable variable=temp_token]$token"
    displayName: 'Get temporary token for creating deployment'

  - task: AzureCLI@2
    inputs:
      azureSubscription: '$(azureSubscription)'
      scriptType: 'ps'
      scriptLocation: 'inlineScript'
      inlineScript: |
        $appContainerImage = "$(container_owner)/$(container_name):$(jar_version)"
        node ./.github/workflows/scripts/deployEnvironment.js
    displayName: 'Create Deployment'
    env:
      app_container_image: $(appContainerImage)
      GITHUB_TOKEN: $(temp_token)
