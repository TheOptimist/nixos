{ pkgs, ...  }:

{
  programs.fish = {
    enable = true;

#    functions = {
#      aws = {
#        description = "Ensures 'aws sso login' uses Microsoft Edge browser";
#        wraps = "aws";
#        body = '''
#          if $argv[0] == "sso"
#            and $argv[1] == "login"
#            echo "Logging into AWS via SSO"
#        ''';
#      };
#    };
  };
}
