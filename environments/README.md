Create environments here, in either the Role Ruby DSL (.rb) or JSON (.json) files. To install environments on the server, use knife.

    knife environment from file environments/dev.json

Update a node env by
    export EDITOR=vim
    knife node edit webserver1

For more information on environments, see the Chef wiki page:

https://docs.chef.io/environments.html
