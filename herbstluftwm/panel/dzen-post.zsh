#! /bin/zsh
#############################################################
## author: Vincent (github.com/mother-1)                   ##
## detail: system calls for `dzen2' panel output           ##
#############################################################
## NOTE: executed via 'autostart' file by `herbstluftwm'   ##
#############################################################

[[ ${+DISPLAY} -gt 0 ]] || exit 1
source ${XDG_CONFIG_DIR:-$HOME}/herbstluftwm/panel/colors.zsh || exit 1
font="Gohu Gohufont:size=10"
width='740'

{
  herbstclient --idle | while read i ; do
    if [[ $i =~ tag_ || $i =~ changed ]] ; then
      tags=( $(herbstclient tag_status) )
      curframe="^fg(#555555)#${c_13}$(printf ${${${(s.i.)${(s.curframe_wcount = .)$(herbstclient attr tags.focus)}[2]}//[[:blank:]]/\\n}[1]})"
      [[ ${${${(z)i}[2]}[1,2]} == 0x ]] && proc=(${${(z)i}:2})
      for i ( $tags ) {
        case ${i[1]} {
          '#') tags=("${tags/$i/${c_00}${b_07}${i#[[:graph:]]}${b_08} }") ;;
          '+') tags=("${tags/$i/^fg(#707070)${i#[[:graph:]]} }") ;;
          '%') tags=("${tags/$i/${c_04}${i#[[:graph:]]} }") ;;
          '-') tags=("${tags/$i/^fg(#707070)${i#[[:graph:]]} }") ;;
          '.') tags=("${tags/$i/^fg(#707070)${i#[[:graph:]]} }") ;;
          ':')
            _n=(${#${(M)${$(herbstclient layout ${i[2,-1]})}#0[[:alpha:]]}})
            case ${_n} {
              0) _N=' ' ;;
              1) _N='¹' ;;
              2) _N='²' ;;
              3) _N='³' ;;
              *) _N='¨' ;;
            }
            tags=("${tags/$i/${c_fg}${i#[[:graph:]]}^fg(#696969)${_N}}")
          ;;
          '!')
            if [[ ${+_n} -eq 1 ]] ; then
              tags=("${tags/$i/${c_02}${i#[[:graph:]]}^fg(#696969)${_N}}")
            else
              tags=("${tags/$i/${c_02}${i#[[:graph:]]} }")
            fi
          ;;
          *)   tags=("${tags/$i/^fg(#707070)${i#[[:graph:]]} }") ;;
        }
      }
    elif [[ $i =~ quit || $i =~ reload ]] ; then
      kill $!
      exit
    fi
    print " ${b_00} ${c_08}:${c_07}ҕ${c_08}: ${b_08} ${c_XX}^bg(#2a2a2a)${tags:-${c_08}$(repeat 6 { printf " · " })}^bg(#313131) ${curframe} ${_XX}${b_08} ^bg(#292929)${b_08}${_XX} ${c_07}${proc:-${c_08}$(repeat 20 { printf " · " })} ${_XX}"
  done
} | dzen2 -p -x 0 -y 0 -w ${width} -h 16 -ta l -bg '#313131' -fg ${_fg} -fn ${font} &> /dev/null || exit 5
