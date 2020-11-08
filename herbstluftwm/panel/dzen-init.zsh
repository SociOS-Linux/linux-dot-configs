#! /bin/zsh
#############################################################
## author: Vincent (github.com/mother-1)                   ##
## detail: system calls for `dzen2' panel output           ##
#############################################################
## NOTE: executed via 'xinitrc' file before `herbstluftwm' ##
#############################################################

[[ ${+DISPLAY} -gt 0 ]] || exit 1
source ${XDG_CONFIG_DIR:-$HOME}/herbstluftwm/panel/colors.zsh || exit 1
font="Gohu Gohufont:size=10"
width='626'

function i_btry {
  local D=/sys/class/power_supply/BAT1
  if [[ ! -d $D ]] ; then
    local STATE="^fg(#444444)∼"
    local CHARGE=' - '
  else
    local STATE=${$(<${D}/status):l}
    local CHARGE=$(<${D}/capacity)
  fi
  local STATE=${${${${STATE/full/${c_12}^c(5)}/discharging/${c_01}«}/charging/${c_03}»}/unknown/^fg(#444444)∼}
  local BAT="${b_08} ^bg(#292929) ${c_07}${CHARGE}^fg(#555555)% ^bg(#333333)${c_07} ${STATE}"
  print - "${c_XX}${b_08} ${c_07}^bg(#333333) бattery ${c_08}${b_00}▒${_XX}${BAT}"
}

function i_date {
  date "+${b_08} ${c_07}^bg(#292929) ^fg(#616161)%b %d ${_XX}^bg(#333333) ^fg(#585858)%a ${_XX}${b_08} ${c_07}%H:%M "
}

function i_load {
  local LOAD=${${${${${${${${${(s. .)$(</proc/loadavg)}[1]/0./${c_08}0.}/1./${c_07}1.}/2./${c_05}2.}/3./${c_04}3.}/4./${c_03}4.}/5./${c_11}5.}/6./${c_01}6.}//./${c_13}.^fg(#616161)}
  print - "${c_XX}${b_08} ${c_07}^bg(#333333) łoadavg ${c_08}${b_00}▒${_XX}${b_08} ^bg(#292929) ${LOAD}"
}

function i_vol {
  local VOLUME=${$(amixer sget Master)[-2,-1]}
  local VOLUME="${${${${${${VOLUME}//[\[\]]}/on/${c_12}^bg(#333333) ^c(5)}/off/${c_01}^bg(#333333) ^c(5)}:gs/%/^fg(#555555)&}% }"
  print - "${c_XX}${b_08} ${c_07}^bg(#333333) þulse ${c_08}${b_00}▒${_XX}${b_08} ^bg(#292929) ${c_07}${VOLUME}"
}

while : ; do
  print - "${_XX}$(i_vol) $(i_load) $(i_btry) $(i_date)${_XX}"
  sleep 2s
done | dzen2 -p -x 740 -y 0 -h 16 -w ${width} -ta r -bg '#313131' -fg ${_fg} -fn ${font} &> /dev/null || exit 5
