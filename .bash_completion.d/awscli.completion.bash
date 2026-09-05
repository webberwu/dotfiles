# complete -C 會在補全時才從 PATH 找 aws_completer，不必在這裡解析完整路徑。
command -v aws_completer &> /dev/null && complete -C aws_completer aws
