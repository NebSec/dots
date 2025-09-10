#!/bin/sh

export GTK_IM_MODULE=xim
export XMODIFIERS="@im=none"

userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/.Xresources

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

feh --bg-center ~/dots/wallpapers/blackwp.png

xset dpms 0 0 0

(
    ~/dots/scripts/updates.sh &
    slstatus &
    picom &

    trap 'kill $(jobs -p)' EXIT

    exec dwm
)
