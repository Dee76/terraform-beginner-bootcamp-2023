# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to use semantic versioning for its tagging.

[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

* **MAJOR** version when you make incompatible API changes
* **MINOR** version when you add functionality in a backward compatible manner
* **PATCH** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

## Install the Terraform CLI

### Considerations with the Terraform CLI changes

The Terraform CLI installation instructions have changed due to GPG keyring changes. So we needed to refer to the latest Terraform CLI install instructions and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against _Ubuntu_.

Please consider checking your Linux Distribution and change accordingly to your distribution needs.

[How to Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS version:

```sh
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation issues we noticed that the bash script steps were considerably more lines of code. We decided to create a bash script to install the Terraform CLI.

Terraform CLI install bash script location: [`./bin/install_terraform_cli`](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([`.gitpod.yml`](.gitpod.yml)) tidy.
- This will allow us to debug more easily and manually execute the Terraform CLI install.
- This allows for better portability for other projects that need to install Terraform CLi.

#### Shebang Considerations

A Shebang (pronounced _Sha-bang_) tells the bash script which program to use to interpret the script, ex. `#!/bin/bash`.

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`.

- For portability between different OS distributions.
- Will search the user's _PATH_ for the bash executable.

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to run the bash script.

ex. `./bin/install_terraform_cli`

If we are using a script in `.gitpod.yml` we need to point the script to a program to interpret it.

ex. `source ./bin/install_terraform_cli`

#### Linux Permission Considerations

In order to make our bash scripts executable we need to change Linux permissions for the file to be executable in user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

Alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

### Gitpod Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

https://gitpod.io/docs/configure/workspaces/tasks

### Working with Env Vars

#### env command

We can list out all _environment variables (env vars)_ using the _env_ command.

We can filter specific env vars using grep. Ex., `env | grep AWS_`.

#### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`.

In the terminal we unset using `unset HELLO`.

We can set an env var temporarily when just running a command.

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export. Ex.:

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

#### Printing Env Vars

We can print an env var using _echo_. Ex., `echo $HELLO`.

### Scoping of Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want env vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. Eg., `.bash_profile`.

#### Persisting Env Vars in Gitpod

We can persist env vars in Gitpod by storing them in Gitpod Secrets Storage.

```sh
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals open in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.

### AWS CLI Installation

Amazon Web Services (AWS) command line interface (CLI) is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli).

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured correctly by running the following command:

```sh
aws sts get-caller-identity
```



:end: