# dfat-lambda-api

The `dfat-lambda-api` repository is a backend solution template, used by the [dfat](https://pub.dev/packages/dfat) CLI, that can be added to a standalone [Flutter](https://flutter.dev) app to make it a cloud-hosted [Flutter](https://flutter.dev) app.

## The Paradigm

The [dfat](https://pub.dev/packages/dfat) paradigm is that you should focus on your app, the experience, the users, and not the infrastructure. [DFAT](https://pub.dev/packages/dfat) aims to enable you to build a local prototype, install an appropriate backend and immediately start using it via an API accessible in the frontend.

The objective, and primary use case, is a standalone [Flutter](https://flutter.dev) app (new or existing) should be able to run two (2) commands and have a deployable backend, fully tested and ready for customization.

The two commands are:

```shell
dart pub global activate dfat
dfat install lambda-api
```

## System Requirements

The following tools chain is required for [dfat](https://pub.dev/packages/dfat). It will not install any of these tools for you. It will check if the tools and folders it needs are present on your system and in your workspace by using the `dfat check` command.

### Required Tools

- [Dart](https://dart.dev/get-dart)
- [Docker](https://www.docker.com/get-started)
- [Flutter](https://docs.flutter.dev/get-started/install)
- [Git](https://git-scm.com/downloads)
- [Terraform](https://www.terraform.io/downloads)

### Using `dfat check`

The command is simple: `dfat check`. The output is also simple, here's an example:

```shell
❯ dfat check
🤖 Processing 'Check'
   🔦 Looking for dart..............................✅
   🔦 Looking for docker............................✅
   🔦 Looking for flutter...........................✅
   🔦 Looking for git...............................✅
   🔦 Looking for terraform.........................✅
   🔦 Looking for .dfat.............................✅
   🔦 Looking for iac...............................✅
   🔦 Looking for lambdas...........................✅
   🔦 Looking for schemas...........................✅
   🔦 Looking for shared............................✅
   🔦 Looking for assets............................✅
🏁 Finished 'Check'
```

If any of the tools or folders were not found, the green box with a white check (✅) would be replaced with a yellow orb (🟡), and a message indicating if this is auto-repairable or not. Here's an example:

```shell
❯ dfat check
🤖 Processing 'Check'
   🔦 Looking for dart..............................✅
   🔦 Looking for docker............................✅
   🔦 Looking for git...............................✅
   🔦 Looking for .dfat.............................🟡 missing, can re-create.
   🔦 Looking for iac...............................🟡 missing, won't re-create.
   🔦 Looking for lambdas...........................✅
   🔦 Looking for schemas...........................🟡 missing, can re-create.
   🔦 Looking for shared............................✅
   🔦 Looking for assets............................✅
   🟡 One or more folders doesn't exist. Running `dfat check --fix` might fix this.
🏁 Finished 'Check'
```

As indicated by the note, running `dfat check --fix` can fix some of these problems in your workspace. The ones it won't fix are because it might clobber your customizations if it tried.

¯\\_(ツ)_/¯

## What's Here?

Thanks for asking! Let's take a look at the solution folder structure and why we have each part. We'll only discuss the aspects introduced by [dfat](https://pub.dev/packages/dfat) and won't cover the other `app` / [dart](https://dart.dev) / [Flutter](https://flutter.dev) specific files.

### Folders

💫 [Generated with https://tree.nathanfriend.io](<https://tree.nathanfriend.io/?s=(%27optiCs!(%27fancy!true~fullPath!false~trailingSlash!true~rootDot!false)~E(%27E%27workspJe4Kfat-9s08.lambda.9308.shGed.93-DockerfileKfat.al2-run.sh48-8.auto.tfvGs3-main.tf-vGiables.tf4lambdas-metaB-todoB4shGed-assetsFngFsd6styles.css-lib0srcAbJk7handlHAclientIcommCA*extensiCIcCtrJtI*messageIfrCt7api5A*http_api_providH0client50servH-83%27)~versiC!%271%27)*%20%20-4*0-*3.jsC4%5Cn*5KGt60cognito_7endA*requestI*8iJ9schemaA0*B0Kist083ConEsource!F6logo.pGarHer5IsAJacK.d%01KJIHGFECBA98765430-*>)

```text
workspace/
├── .dfat/
│   ├── schemas/
│   │   ├── iac.lambda.schema.json
│   │   └── iac.shared.schema.json
│   ├── Dockerfile.dfat.al2
│   └── run.sh
├── iac/
│   ├── iac.auto.tfvars.json
│   ├── main.tf
│   └── variables.tf
├── lambdas/
│   ├── meta/
│   │   ├── .dist
│   │   └── iac.json
│   └── todo/
│       ├── .dist
│       └── iac.json
└── shared/
    ├── assets/
    │   ├── cognito_logo.png
    │   ├── cognito_logo.psd
    │   └── cognito_styles.css
    ├── lib/
    │   ├── src/
    │   │   ├── backend/
    │   │   │   ├── requests
    │   │   │   └── handler.dart
    │   │   ├── clients
    │   │   ├── common/
    │   │   │   └── extensions
    │   │   ├── contracts/
    │   │   │   └── messages
    │   │   └── frontend/
    │   │       ├── requests
    │   │       ├── api.dart
    │   │       └── http_api_provider.dart
    │   ├── client.dart
    │   └── server.dart
    └── iac.json
```

- **workspace** → _This is your project root_
  - **.dfat** → _Holds critical files for normal [dfat](https://pub.dev/packages/dfat) operations_
    - **schemas** → _The JSON schemas for IaC files_
      - **iac.lambda.schema.json** → _Defines the deployment options (routes, timeouts, memory, etc.) schema per lambda_
      - **iac.shared.schema.json** → _Defines the deployment options (URL, stages, IPDs, user attributes, etc) schema for the backend_
    - **Dockerfile.dfat.al2** → _An Amazon Linux 2 docker image definition for building the lambdas in their target runtime_
    - **run.sh** → _Installs and runs [dfat](https://pub.dev/packages/dfat) in the docker image_
  - **app** → _Where your [Flutter](https://flutter.dev) app lives in relation to the rest of the solution_
  - **iac** → _The Terraform IaC (infrastructure as code) definition for backend deployment_
    - **iac.auto.tfvars.json** → _This file only exists after `dfat build` or, more precisely, after `dfat aggregate` (one of the first build steps)_
    - **main.tf** → _Defines your AWS backend, state configuration, and references the [dfat](https://pub.dev/packages/dfat) [`terraform-aws-lambda-api`](https://registry.terraform.io/modules/GioCirque/lambda-api/aws/latest) module_
    - **variables.tf** → _All the variables required by the module, these are **ALL** mapped from the **iac.auto.tfvars.json** file_
  - **lambdas** → _The top-level container folder for your lambda function implementations_
    - **meta** → _An example `meta` lambda function that returns [Amazon Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer/) data for your account, and can be filtered by tags._
      - **.dist** → _An intermediate folder used by [dfat](https://pub.dev/packages/dfat) to stage the native build output for ZIP compression and aggregation_
      - **iac.json** → _The deployment options for this lambda see: `iac.lambda.schema.json`_
    - **todo** → _An example `todo` lambda function that implements the `CRUD` operations for Todo Items_
      - Otherwise, same files, folders and intentions at `meta`
- **shared** → _The shared library between the `lambdas` and the `app`. While you cannot change the folder names, you can change all of the package names to whatever you want. Reference the `client.dart` barrel from `shared` in your `app`, the `lambdas` reference the `server.dart` barrel for their functionality_
  - **assets** → _Non-code assets used in the deployment. RIght now, these are primarily [Amazon Cognito](https://aws.amazon.com/cognito/) Client Application Hosted UI customization file._
    - **cognito_logo.png** → _A rendered logo for the Cognito Hosted UI_
    - **cognito_logo.psd** → _The layered source logo for the Cognito Hosted UI_
    - **cognito_styles.css** → _A copy of the official, default style sheet for customizing the Cognito Hosted UI_
  - **lib**
    - **src**
      - **backend** → _The `backend` focal point for the shared library_
        - **requests** → _The `backend` version of the request models, optimized for the `backend` needs_
        - **handler.dart** → _The `backend` primary interaction point. A lambda shouldn't call much of anything except this_
      - **clients** → _Client implementations to databases and other systems, typically these are only used by the `handler`_
      - **common** → _Commonly available and accessible functionality (extensions, UI fakes, etc.) for both `frontend` and `backend`_
      - **contracts** → _As the name suggests, these are the contract between `frontend` and `backend`. These are meant to be serializable and simple. More complete and specific version are available in the `frontend` and `backend` as `request` implementations_
        - **messages** → _While the contracts are the shape of your data in both sides of the wire, the messages are the `request` and `response` types using those shapes for various operations. Like contracts, these must be serializable and not contain anything `frontend` nor `backend` specific_
      - **frontend** → _The `frontend` focal point for the shared library_
        - **request** → _The `frontend` version of the request models, optimized for the `frontend` needs_
        - **api.dart** → _The `frontend` primary interaction point. A `frontend` shouldn't call a `backend` except through this_
        - **http_api_provider.dart** → _A request object `mixin` that locks the response type with type arguments and facilitates the serialization, HTTP call, and deserialization of the response. This is where you might want to handle additional headers, tracing, or other network operations/modifications_
  - **iac.json** → _The general deployment options for this `backend`. See: `iac.shared.schema.json`_
