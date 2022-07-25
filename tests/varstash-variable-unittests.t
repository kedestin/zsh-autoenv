Unit Tests for lib/varstash for zsh variables

  $ source $TESTDIR/../lib/varstash

Test Scalar {{{

*    Scalar with no attributes

  $ stashed_var="Hello World"
  $ stash stashed_var=changed
  $ echo $stashed_var
  changed
  $ unstash stashed_var
  $ echo $stashed_var
  Hello World
  $ unset -v stashed_var

*    Left Justified

  $ typeset -L 5 stashed_var=a
  $ stash stashed_var=123456789
  $ echo $stashed_var
  12345
  $ unstash stashed_var
Note trailing spaces in echo output
  $ echo $stashed_var
  a    
  $ typeset -m "stashed_var"
  stashed_var=a
  $ unset -v stashed_var

*    Right Justified

  $ typeset -R 5 stashed_var=a
  $ stash stashed_var=123456789
  $ echo $stashed_var
  56789
  $ unstash stashed_var
  $ echo $stashed_var
      a
  $ typeset -m "stashed_var"
  stashed_var=a
  $ unset -v stashed_var

*    Right Zeros

  $ typeset -Z 5 stashed_var=1
  $ stash stashed_var=123456789
  $ echo $stashed_var
  56789
  $ unstash stashed_var
  $ echo $stashed_var
  00001
  $ typeset -m "stashed_var"
  stashed_var=1
  $ unset -v stashed_var


*    Lower

  $ typeset -l stashed_var="FOO"
  $ stash stashed_var=BAR
  $ echo $stashed_var
  bar
  $ unstash stashed_var
  $ echo $stashed_var
  foo
  $ typeset -m "stashed_var"
  stashed_var=FOO
  $ unset -v stashed_var

*    Upper

  $ typeset -u stashed_var=foo
  $ stash stashed_var=bar
  $ echo $stashed_var
  BAR
  $ unstash stashed_var
  $ echo $stashed_var
  FOO
  $ typeset -m "stashed_var"
  stashed_var=foo
  $ unset -v stashed_var


}}}




Test Integer {{{

  $ typeset -i stashed_var=2+2-1
  $ stash stashed_var=2+2
  $ echo $stashed_var
  4
  $ unstash stashed_var
  $ echo $stashed_var
  3
  $ unset -v stashed_var

}}}

Test Float {{{

  $ typeset -F stashed_var=3.1415
  $ stash stashed_var=2+2
  $ echo $stashed_var
  4.0000000000
  $ unstash stashed_var
  $ echo $stashed_var
  3.1415000000
  $ unset -v stashed_var

}}}

Test Array {{{

*    Empty
  $ typeset -a stashed_var=()
  $ stash stashed_var
  $ stashed_var=( 5 6 7 8 )
  $ typeset -p stashed_var
  typeset -a stashed_var=( 5 6 7 8 )
  $ unstash stashed_var
  $ echo ${#stashed_var}
  0
  $ unset -v stashed_var

*    Non Empty

  $ typeset -a stashed_var=( 1 2 3 4 '' )
  $ stash stashed_var
  $ stashed_var=( 5 6 7 8 )
  $ typeset -p stashed_var
  typeset -a stashed_var=( 5 6 7 8 )
  $ unstash stashed_var
  $ typeset -p stashed_var
  typeset -a stashed_var=( 1 2 3 4 '' )
  $ unset -v stashed_var

}}}

Test Associative  Array {{{

*    Empty

  $ typeset -A stashed_var=()
  $ stash stashed_var
  $ stashed_var=( foo bar )
  $ echo ${#stashed_var}
  1
  $ echo ${stashed_var[foo]+"Key is set"}
  Key is set
  $ echo "${stashed_var[foo]}"
  bar
$ functions -t unstash stash
  $ unstash stashed_var
  $ echo ${#stashed_var}
  0
  $ unset -v stashed_var

*    Non Empty

  $ typeset -A stashed_var=( a foo  b "" )
  $ stash stashed_var
  $ stashed_var=( foo bar )
  $ echo ${#stashed_var}
  1
  $ echo ${stashed_var[foo]+"Key is set"}
  Key is set
  $ echo "${stashed_var[foo]}"
  bar
  $ unstash stashed_var
  $ echo ${#stashed_var}
  2
  $ echo ${stashed_var[a]+"Key is set"}, ${stashed_var[b]+"Key is set"}
  Key is set, Key is set
  $ echo ${stashed_var[a]} $([[ ${stashed_var[b]} ]] || echo "emptystring")
  foo emptystring
  $ unset -v stashed_var

}}}

Test Tied Variable {{{

* Default Seperator

  $ typeset -T SCALAR_VAR array_var 
  $ echo ${#array_var}
  0
  $ stash SCALAR_VAR
  $ array_var=(1 2 3 4 5)
  $ echo $array_var
  1 2 3 4 5
  $ echo $SCALAR_VAR
  1:2:3:4:5
  $ SCALAR_VAR="a"
  $ echo ${#array_var}
  1
  $ unstash SCALAR_VAR
  $ echo ${#array_var}
  0
  $ unset SCALAR_VAR
  $ unset array_var

* Non-default Seperator

  $ typeset -T SCALAR_VAR array_var .
  $ echo ${#array_var}
  0
  $ stash SCALAR_VAR
  $ array_var=(1 2 3 4 5)
  $ echo $array_var
  1 2 3 4 5
  $ echo $SCALAR_VAR
  1.2.3.4.5
  $ SCALAR_VAR=""
  $ echo ${#array_var}
  1
  $ unstash SCALAR_VAR
  $ echo ${#array_var}
  0
  $ unset SCALAR_VAR
  $ unset array_var

}}}