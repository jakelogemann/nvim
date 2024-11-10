" Vim syntax file
" Language: Modelfile
" Maintainer: Eugene Kalinin
" Latest Revision: 11 September 2013
" Source: http://docs.docker.io/en/latest/use/builder/

if exists("b:current_syntax")
  finish
endif

" case sensitivity (fix #17)
" syn case  ignore

" Keywords
syn keyword modelfileKeywords FROM PARAMETER TEMPLATE SYSTEM ADAPTER LICENSE MESSAGE

" Bash statements
setlocal iskeyword+=-
syn keyword bashStatement add-apt-repository adduser apk apt-get aptitude apt-key autoconf bundle
syn keyword bashStatement cd chgrp chmod chown clear complete composer cp curl du echo egrep
syn keyword bashStatement expr fgrep find gem gnufind gnugrep gpg grep groupadd head less ln
syn keyword bashStatement ls make mkdir mv node npm pacman pip pip3 php python rails rm rmdir rpm ruby
syn keyword bashStatement sed sleep sort strip tar tail tailf touch useradd virtualenv yum
syn keyword bashStatement usermod bash cat a2ensite a2dissite a2enmod a2dismod apache2ctl
syn keyword bashStatement wget gzip

" Strings
syn region modelfileString start=/"/ skip=/\\"|\\\\/ end=/"/
syn region modelfileString1 start=/'/ skip=/\\'|\\\\/ end=/'/

" Emails
syn region modelfileEmail start=/</ end=/>/ contains=@ oneline

" Urls
syn match modelfileUrl /\(http\|https\|ssh\|hg\|git\)\:\/\/[a-zA-Z0-9\/\-\._]\+/

" Task tags
syn keyword modelfileTodo contained TODO FIXME XXX

" Comments
syn region modelfileComment start="#" end="\n" contains=modelfileTodo
syn region modelfileEnvWithComment start="^\s*ENV\>" end="\n" contains=modelfileEnv
syn match modelfileEnv contained /\<ENV\>/

" Highlighting
hi link modelfileKeywords  Keyword
hi link modelfileEnv       Keyword
hi link modelfileString    String
hi link modelfileString1   String
hi link modelfileComment   Comment
hi link modelfileEmail     Identifier
hi link modelfileUrl       Identifier
hi link modelfileTodo      Todo
hi link bashStatement       Function

let b:current_syntax = "modelfile"
