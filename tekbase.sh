#! /bin/bash

# TekLabs TekBase
# Copyright since 2005 TekLab
# Christian Frankenstein
# Website: teklab.de
#          teklab.net


VAR_A=$1
VAR_B=$2
VAR_C=$3
VAR_D=$4
VAR_E=$5
VAR_F=$6
VAR_G=$7
VAR_H=$8
VAR_I=$9
VAR_J=${10}

if [ "$VAR_A" = "" ]; then
    LOGY=$(date +"%Y")
    clear
    echo "###########################################"
    echo "# TekLabs TekBase                         #"
    echo "# Copyright 2005-$LOGY TekLab              #"
    echo "# Christian Frankenstein                  #"
    echo "# Website: www.teklab.de                  #"
    echo "#          www.teklab.us                  #"
    echo "###########################################"
fi

LOGF=$(date +"%Y_%m")
LOGC=$(date +"%Y_%m-%H_%M_%S")
LOGP=$(pwd)

if [ ! -d logs ]; then
    mkdir logs
    chmod 0777 logs
fi
if [ ! -d restart ]; then
    mkdir restart
    chmod 0777 restart
fi
if [ ! -d startscripte ]; then
    mkdir startscripte
    chmod 0777 startscripte
fi

if [ ! -f "logs/$LOGF.txt" ]; then
    echo "***TekBASE Script Log***" >> $LOGP/logs/$LOGF.txt
    chmod 0666 $LOGP/logs/$LOGF.txt
fi

case "$VAR_A" in
    # User anlegen
    1)
        if [ ! -d /home/$VAR_B ] ; then 
	    useradd -g users -p $(perl -e 'print crypt("'$VAR_C'","Sa")') -s /bin/bash -m $VAR_B -d /home/$VAR_B
	    if [ ! -d /home/$VAR_B ]; then
	        echo "$(date) - Error: User $VAR_B cant be created" >> $LOGP/logs/$LOGF.txt
	        echo "ID2"
	    else
	        echo "$(date) - User $VAR_B was created" >> $LOGP/logs/$LOGF.txt
	        echo "ID1"
	    fi
        else
	    usermod -p $(perl -e 'print crypt("'$VAR_C'","Sa")') $VAR_B
	    echo "$(date) - User $VAR_B was existing and changed" >> $LOGP/logs/$LOGF.txt
	    echo "ID1"
        fi
    ;;
    # User bearbeiten
    2)
        usermod -p $(perl -e 'print crypt("'$VAR_C'","Sa")') $VAR_B
        echo "$(date) - User $VAR_B was changed" >> $LOGP/logs/$LOGF.txt
        echo "ID1"
    ;;
    # User entfernen 1-2
    3)
        rm $LOGP/restart/$VAR_B*
        startchk=$(ps aux | grep -v grep | grep -i screen | grep -i "d$VAR_B-X")
        if [ ! -n "$startchk" ]; then
	    screen -A -m -d -S d$VAR_B-X ./tekbase 4 $VAR_B $VAR_C
	    check=$(ps aux | grep -v grep | grep -i screen | grep -i "d$VAR_B-X")
        fi
        if [ ! -n "$check" ]; then
	    if [ ! -d /home/$VAR_B ]; then
	        echo "$(date) - User $VAR_B was deleted" >> $LOGP/logs/$LOGF.txt
	        echo "ID1"
	    else
	        echo "$(date) - Error: User $VAR_B cant be deleted" >> $LOGP/logs/$LOGF.txt
	        echo "ID2"
	    fi
        else
	    echo "$(date) - User $VAR_B was deleted" >> $LOGP/logs/$LOGF.txt
	    echo "ID1"
        fi
    ;;
    # User entfernen 2-2
    4)
        counter=0
        deleteall=0
        if [ "$VAR_C" != "all" ]; then
	    while [ $counter != 1 ]; do
	        totalcount=0
	        cd /home/$VAR_B
	        if [ -d apps ]; then
		    cd apps
		    acounter=$(find -type d | wc -l)
		    if [ "$acounter" != "1" ]; then
		        totalcount=1
		    fi
		    cd ..
	        fi
	        if [ -d server ]; then
		    cd server
		    scounter=$(find -type d | wc -l)
	            if [ "$scounter" != "1" ]; then
		        totalcount=1
		    fi
		    cd ..
	        fi
	        if [ -d streams ]; then
		    cd streams
		    sscounter=$(find -type d | wc -l)
		    if [ "$sscounter" != "1" ]; then
		        totalcount=1
		    fi
		    cd ..
	        fi
	        if [ -d voice ]; then
		    cd voice
		    vcounter=$(find -type d | wc -l)
		    if [ "$vcounter" != "1" ]; then
		        totalcount=1
		    fi
		    cd ..
	        fi
	        if [ -d vstreams ]; then
		    cd vstreams
		    vscounter=$(find -type d | wc -l)
		    if [ "$vscounter" != "1" ]; then
		        totalcount=1
		    fi
		    cd ..
	        fi
	        if [ "$totalcount" = "1" ]; then
		    sleep 5
		    let deleteall=$deleteall+1
	        else
		    counter=1
	        fi
	        if [ "$deleteall" = "5" ]; then
		    cd /home/$VAR_B
		    rm -r *
		    counter=1
	        fi
	    done
        fi

        userdel $VAR_B
        cd /home
        rm -r $VAR_B
        rm -r /var/run/screen/S-$VAR_B
        rm -r /var/run/uscreen/S-$VAR_B
    ;;
    # Games/Apps/Voice/Stream installieren 1-2
    5)
        startchk=$(ps aux | grep -v grep | grep -i screen | grep -i "$VAR_B$VAR_C-X")
        if [ ! -n "$startchk" ]; then
	    screen -A -m -d -S i$VAR_B$VAR_C-X ./tekbase 6 $VAR_B $VAR_C $VAR_D $VAR_E $VAR_F $VAR_G $VAR_H
	    check=$(ps aux | grep -v grep | grep -i screen | grep -i "i$VAR_B$VAR_C-X")
        fi
        if [ ! -n "$check" ]; then
	    if [ ! -d /home/$VAR_B/$VAR_F/$VAR_C ]; then
	        echo "ID2"
	    else
	        echo "ID1"
	    fi
        else
	    echo "ID1"
        fi
    ;;
    # Games/Apps/Voice/Stream installieren 2-2
    6)
        cd /home/$VAR_B
        su $VAR_B -c "mkdir -p $VAR_F"
        cd $VAR_F
        if [ "$VAR_G" = "delete" ]; then
	    sleep 10
	    rm -r $VAR_C
	    if [ -f $VAR_C.tar ]; then
	        rm $VAR_C.tar
	    fi
        fi
        su $VAR_B -c "mkdir $VAR_C"
        if [ ! -d $VAR_C ]; then
	    echo "$(date) - Folder /home/$VAR_B/$VAR_F/$VAR_C cant be created" >> $LOGP/logs/$LOGF.txt
        else
#	    if [ "$VAR_F" = "server" ]; then
#	        passwd=`pwgen 10 1`
#	        useradd -g users -p `perl -e 'print crypt("'$passwd'","Sa")'` -s /bin/bash $VAR_B-$VAR_C -d /home/$VAR_B/server/$VAR_C
#	        echo "$(date) - Gameserver user $VAR_B-$VAR_C was created" >> $LOGP/logs/$LOGF.txt
#	    fi
	    echo "$(date) - Folder /home/$VAR_B/$VAR_F/$VAR_C was created" >> $LOGP/logs/$LOGF.txt
#	    if [ "$VAR_G" = "protect" ]; then
#	        chown -R $VAR_H $VAR_C
#	        chmod 755 $VAR_C
#	    fi
        fi

        if [ -f $VAR_G ] && [ "$VAR_G" != "" ]; then
	    mv $VAR_G /home/$VAR_B/$VAR_F/$VAR_C/install.sh
	    cd /home/$VAR_B/$VAR_F/$VAR_C
	    chown $VAR_B install.sh
	    chmod 755 install.sh
	    su $VAR_B -c "./install.sh"
	    rm install.sh
	    counter=$(find -type f | wc -l)
	    if [ "$counter" != "0" ]; then
	        echo "$(date) - Script in $VAR_B/$VAR_F/$VAR_C was installed" >> $LOGP/logs/$LOGF.txt
	    else
	        echo "$(date) - Script in $VAR_B/$VAR_F/$VAR_C cant be installed" >> $LOGP/logs/$LOGF.txt
	    fi
	    exit 0
        fi

        cd $LOGP
        mkdir -p cache
        cd cache
        if [ ! -f $VAR_D.tar ]; then
	    mkdir $LOGC
	    cd $LOGC
	    wget $VAR_E/$VAR_D.tar
	    mv $VAR_D.tar $LOGP/cache/$VAR_D.tar
	    cd $LOGP/cache
	    rm -r $LOGC
        else
	    if [ -f $VAR_B$VAR_C.md5 ]; then
	        rm $VAR_B$VAR_C.md5
	    fi
	    wget -O $VAR_B$VAR_C.md5 $VAR_E/$VAR_D.tar.md5
	    if [ -f $VAR_B$VAR_C.md5 ]; then
	        dowmd5=$(cat $VAR_B$VAR_C.md5 | awk '{print $1}')
	        rm $VAR_B$VAR_C.md5
	    else
	        dowmd5="ID2"
	    fi
	    chkmd5=$(md5sum $VAR_D.tar | awk '{print $1}')
	    if [ "$dowmd5" != "$chkmd5" ]; then
	        mkdir $LOGC
	        cd $LOGC
	        wget $VAR_E/$VAR_D.tar
	        dowmd5=$(md5sum $VAR_D.tar | awk '{print $1}')
	        if [ "$dowmd5" != "$chkmd5" ]; then
	            mv $VAR_D.tar $LOGP/cache/$VAR_D.tar
	        fi
	        cd $LOGP/cache
	        rm -r $LOGC
	    fi
        fi
        if [ ! -f $VAR_D.tar ]; then
	    echo "$(date) - Image $VAR_D.tar cant be downloaded" >> $LOGP/logs/$LOGF.txt
        else
	    echo "$(date) - Image $VAR_D.tar was downloaded" >> $LOGP/logs/$LOGF.txt
	    if [ "$VAR_G" = "protect" ]; then
	        userchk=$(grep ^$VAR_B-p: /etc/passwd | grep -i "sec")
	        if [ "$userchk" = "" ]; then
		    passwd=$(pwgen 8 1 -c -n)
		    useradd -g users -p $(perl -e 'print crypt("'$passwd'","Sa")') -s /bin/bash $VAR_B-p -d /home/$VAR_B/$VAR_F/$VAR_C
	        fi
	        cd /home/$VAR_B/$VAR_F
	        chown $VAR_B-p:users $VAR_C
	        chmod 755 $VAR_C
	        cd $LOGP/cache
	        su $VAR_B-p -c "tar -xf $VAR_D.tar -C /home/$VAR_B/$VAR_F/$VAR_C"
	    else
	        su $VAR_B -c "tar -xf $VAR_D.tar -C /home/$VAR_B/$VAR_F/$VAR_C"
	    fi
	    
	    cd /home/$VAR_B/$VAR_F/$VAR_C
	    if [ -f install.sh ]; then
	        chmod 0777 install.sh
	        su $VAR_B -c "./install.sh"
	        rm install.sh
	    fi
	    if [ "$VAR_F" = "server" ]; then
	        cd /home/$VAR_B/$VAR_F/$VAR_C
	        for PROTLINE in $(cat $LOGP/includes/$VAR_D/protect.inf)
	        do
		    if [ -f $PROTLINE ]; then
		        chown $VAR_B-p:users $PROTLINE
		        chmod 554 $PROTLINE
		   fi
	        done
	    fi
	    counter=$(find -type f | wc -l)
	    if [ "$counter" != "0" ]; then
	        echo "$(date) - Image $VAR_D.tar was installed" >> $LOGP/logs/$LOGF.txt
	    else
	        echo "$(date) - Image $VAR_D.tar cant be installed" >> $LOGP/logs/$LOGF.txt
	    fi
        fi
        sleep 2
    ;;
    # Games/Apps/Voice/Stream deinstallieren 1-2
    7)
        if [ -f $LOGP/restart/$VAR_B-$VAR_D-$VAR_C ]; then
	    rm $LOGP/restart/$VAR_B-$VAR_D-$VAR_C
        fi
        startchk=$(ps aux | grep -v grep | grep -i screen | grep -i "$VAR_B$VAR_C-X")
        if [ ! -n "$startchk" ]; then
	    screen -A -m -d -S d$VAR_B$VAR_C-X ./tekbase 8 $VAR_B $VAR_C $VAR_D
	    check=$(ps aux | grep -v grep | grep -i screen | grep -i "d$VAR_B$VAR_C-X")
        fi
        if [ ! -n "$check" ]; then
	    cd /home/$VAR_B/$VAR_D
	    if [ ! -d $VAR_C ]; then
	        echo "ID1"
	    else
	        echo "ID2"
	    fi
        else
	    echo "ID1"
        fi
    ;;
    # Games/Apps/Voice/Stream deinstallieren 2-2
    8)
        sleep 10
        cd /home/$VAR_B/$VAR_D
        rm -r $VAR_C

        userchk=$(grep ^$VAR_B-p: /etc/passwd | grep -i "sec")
        if [ "$userchk" != "" ]; then
	    killall -u $VAR_B-p
	    sleep 10
    	    userdel $VAR_B-p
	    cd /home
	    rm -r $VAR_B
	    rm -r /var/run/screen/S-$VAR_B-p
	    rm -r /var/run/uscreen/S-$VAR_B-p
        fi
        if [ -d $LOGP/cache/$VAR_B$VAR_D ]; then
	    cd $LOGP/cache
	    rm $VAR_B$VAR_D
        fi
        cd $LOGP/cache
        if [ -d $VAR_B$VAR_C ]; then
	    rm -r $VAR_B$VAR_C
        fi
        if [ ! -d $VAR_C ]; then
	    echo "$(date) - Folder /home/$VAR_B/$VAR_D/$VAR_C was deleted" >> $LOGP/logs/$LOGF.txt
        else
	    echo "$(date) - Folder /home/$VAR_B/$VAR_D/$VAR_C cant be deleted" >> $LOGP/logs/$LOGF.txt
        fi
    ;;
    # FTP User anlegen
    9)
        uid=$(grep home/$VAR_B /etc/passwd | cut -d : -f3)
	gid=$(grep home/$VAR_B /etc/passwd | cut -d : -f4)
	/usr/bin/expect<<EOF
        cd /etc/proftpd
	spawn ftpasswd --passwd --name=$VAR_C --uid=$uid --gid=$gid --home=$VAR_E --shell=/bin/false
	expect "Password:" {send "$VAR_D\r"}
	expect "Re-type password:" {send "$VAR_D\r"}
	expect eof
EOF
	ftpasswd --group --file=/etc/proftpd/ftpd.group --name=$VAR_C --gid=$gid --member=$VAR_C
	echo "ID1"
    ;;
    # FTP User bearbeiten
    10)
	/usr/bin/expect<<EOF
	cd /etc/proftpd
	spawn ftpasswd --change-password --passwd --name=$VAR_C
	expect "Password:" {send "$VAR_D\r"}
	expect "Re-type password:" {send "$VAR_D\r"}
	expect eof
EOF
	echo "ID1"
    ;;
    # FTP User entfernen
    11)
        cd /etc/proftpd
	ftpasswd --delete-user --passwd --name=$VAR_C
	echo "ID1"
    ;;
    # Versionsausgabe und Screenlog
    18)
        if [ ! -n "$VAR_B" ]; then
	    echo "8701"
        fi

        if [ "$VAR_B" = "scservlog" ]; then
	    cd /home
	    for FILE in $(find . -iname sc_serv.log -type f)
	    do
	        rm $FILE
	    done
        fi
    
        if [ "$VAR_B" = "sctranslog" ]; then
	    cd /home
	    for FILE in $(find . -iname sc_trans.log -type f)
	    do
	        rm $FILE
	    done
        fi

        if [ "$VAR_B" = "screenlog" ]; then
	    cd /home
	    for FILE in $(find . -iname screenlog* -type f)
	    do
	        rm $FILE
	    done
        fi
    
        if [ "$VAR_B" = "restart" ]; then
	    cd $LOGP/restart
	    for FILE in $(find -type f)
	    do
	        $FILE
	    done
        fi

        if [ "$VAR_B" = "daemon" ]; then
	    check=$(ps aux | grep -v grep | grep -i tekbase_daemon)
	    if [ ! -n "$check" ]; then
	        check=$(ps aux | grep -v grep | grep -i "per -e use MIME::Base64")
	        if [ ! -n "$check" ]; then
	            ./server &
	        fi
	    fi
        fi

        if [ "$VAR_B" = "cpumem" ]; then
	    check=$(ps x | grep -i "server${VAR_C}-X" | grep -v grep | sed -e 's#.*server'${VAR_C}'-X \.\(\)#\1#' | grep -v "sed -e")
	    if [ -n "$check" ]; then
	        pidone=$(ps x | grep -i "$check" | grep -vi screen | grep -v grep | awk '{print $1}')
	        if [ -n "$pidone" ]; then
		    let pidend=pidone+51
		    while [ $pidone -lt $pidend ]; do
		        chkpid=$(ps x | grep -i "${pidone} " | grep -v grep)
		        if [ -n "$chkpid" ]; then
			    chkmem=$(ps -p $pidone -o pmem --no-headers | awk '{print $1}')
			    if [ "$chkmem" != "0.0" ] && [ "$chkmem" != "0.1" ] && [ "$chkmem" != "0.2" ]; then
			        chkcpu=$(ps -p $pidone -o pcpu --no-headers | awk '{print $1}')
			        chkfree=$(free -k | grep -i "mem" | awk '{print $2}')
			        echo "$chkcpu;$chkmem;$chkfree"
			        pidend=52
			    fi
		        fi
		        let pidone=pidone+1
		    done
	        fi
	    fi
        fi
    ;;
    # Autoupdater
    19)
        screen -A -m -d -S tekautoup ./autoupdater
        check=$(ps aux | grep -v grep | grep -i screen | grep -i tekautoup)
        if [ ! -n "$check" ]; then
	    echo "ID2"
        else
	    echo "ID1"
        fi
    ;;
    # VServer Ausfuehrung
    24)
        if [ "$VAR_C" = "delete" ]; then
	    check=$(vzctl status $VAR_B | grep -i running)
	    if [ -n "$check" ]; then
	        vzctl stop $VAR_B
	    fi
	    vzctl destroy $VAR_B
	    if [ ! -f /etc/vz/conf/$VAR_B.conf ]; then
	        echo "$(date) - VServer $VAR_B was deleted" >> $LOGP/logs/$LOGF.txt
	    else
	        echo "$(date) - VServer $VAR_B cant be deleted" >> $LOGP/logs/$LOGF.txt
	    fi
	    cd /etc/vz/conf
	    rm $VAR_B.conf.destroyed
	    if [ -d /usr/vz/$VAR_B ]; then
	        cd /usr/vz
	        rm -r $VAR_B
	    fi
        fi

        if [ "$VAR_C" = "traffic" ]; then
	    for i in $(./tekbase 24 99 iplist)
	    do
	        traffic=$(iptables -nvx -L FORWARD | grep " $i " | tr -s [:blank:] |cut -d' ' -f3| awk '{sum+=$1} END {print sum;}')
	        if [ -n "$VAR_E" ]; then
		    wget --post-data 'op=vtraffic&key='$VAR_B'&rid='$VAR_E'&vip='$i'&traffic='$traffic'' -O - $VAR_D/automated.php
	        else
		    wget --post-data 'op=vtraffic&key='$VAR_B'&vip='$i'&traffic='$traffic'' -O - $VAR_D/automated.php
	        fi
	    done
	    iptables -Z
	    for i in $(./tekbase 24 99 iplist); do iptables -D FORWARD -s $i; iptables -D FORWARD -d $i; done >/dev/null 2>&1
	    for i in $(./tekbase 24 99 iplist); do iptables -A FORWARD -s $i; iptables -A FORWARD -d $i; done >/dev/null 2>&1
        fi

        if [ "$VAR_C" = "iplist" ]; then
	    vzlist -H -o ip
        fi
    ;;
    # Change files
    28)
        if [ "$VAR_F" = "startscr" ]; then
            cd /home/$VAR_B/$VAR_C/$VAR_D
            for LINE in $(echo "$VAR_E" | sed -e 's/;/\n/g')
            do
	        chmod 777 $LINE
	        if [ -d $LINE ]; then
		    cd $LINE
		    chmod 544 *
		    cd /home/$VAR_B/$VAR_C/$VAR_D
	        fi
            done
        else
	    newvar="startscr"
	    screen -A -m -d -S $VAR_B$VAR_D-28 ./tekbase 28 $VAR_B $VAR_C $VAR_D $VAR_E $newvar
        fi
    ;;
    # Copy files
    29)
        if [ "$VAR_F" = "startscr" ]; then
            cd $LOGP/cache
            mkdir -p $VAR_B$VAR_D
            chmod 0777 $VAR_B$VAR_D
            cd /home/$VAR_B/$VAR_C/$VAR_D
            for LINE in $(echo "$VAR_E" | sed -e 's/;/\n/g')
            do
                if [ -d $LINE ]; then
                    cp -r --parents $LINE $LOGP/cache/$VAR_B$VAR_D
                fi
                if [ -f $LINE ]; then
                    cp --parents $LINE $LOGP/cache/$VAR_B$VAR_D
                fi
            done
            cd $LOGP/cache/$VAR_B$VAR_D
            rm protect.md5
            cd $LOGP/cache
            tar -cf $VAR_B$VAR_D.tar $VAR_B$VAR_D
            md5sum $VAR_B$VAR_D.tar | awk '{print $1}' > $LOGP/cache/$VAR_B$VAR_D/protect.md5
            rm $VAR_B$VAR_D.tar
            cd $LOGP/cache/$VAR_B$VAR_D
            cp protect.md5 /home/$VAR_B/$VAR_C/$VAR_D/protect.md5
        else
            newvar="startscr"
            screen -A -m -d -S $VAR_B$VAR_D-29 ./tekbase 29 $VAR_B $VAR_C $VAR_D $VAR_E $newvar
        fi
    ;;
    # Check MD5
    30)
        dowmd5=$(cat $LOGP/cache/$VAR_B$VAR_D/protect.md5 | awk '{print $1}')
        chkmd5=$(cat /home/$VAR_B/$VAR_C/$VAR_D/protect.md5 | awk '{print $1}')
        if [ "$dowmd5" = "$chkmd5" ]; then
            echo "ID1"
        else
            echo "ID2"
        fi
    ;;
    # Check Limit
    31)
        cd /home/$VAR_B/$VAR_C

        if [ "$VAR_D" != "" ]; then
	    cd /home/$VAR_B/$VAR_D
        fi
        if [ "$VAR_E" != "" ]; then
	    cd /home/$VAR_B/$VAR_E
        fi
        if [ "$VAR_F" != "" ]; then
	    cd /home/$VAR_B/$VAR_F
        fi

        echo "$(du -s | awk '{print $1}')"
    ;;
    32)
        echo "$(ps aux --sort pid | grep -v "ps aux" | grep -v "awk {printf" | grep -v "tekbase" | grep -v "perl -e use MIME::Base64" | awk '{printf($1"%TD%")
        printf($2"%TD%")
        printf($3"%TD%")
        printf($4"%TD%")
        for (i=11;i<=NF;i++) {
	    printf("%s ", $i);
        }
        print("%TEND%") }')"
    ;;
    33)
        killall -w -q -u $VAR_B
        home=$(grep $VAR_B /etc/passwd | cut -f 6 -d ":")
        rsync -a --link-dest=/home/chroot/ /home/chroot/ $home/
        grep $VAR_B /etc/passwd >> $home/etc/passwd
        grep $VAR_B /etc/shadow >> $home/etc/shadow
        cp /home/skripte/tekbase $home/
        chown $VAR_B $home
        mkdir -p $home/proc
        umount $home/proc >/dev/null 2>&1
        umount $home/dev >/dev/null 2>&1
        mount proc -t proc $home/proc >/dev/null 2>&1
        mount --bind /dev $home/dev
        rm -rf $home$home
        mkdir -p $home$home
        rmdir $home$home
        ln -s / $home$home
        chroot $home su $VAR_B -c "./tekbase 9 '$VAR_C' '$VAR_D' '$VAR_E' '$VAR_F' '$VAR_G' '$VAR_H' '$VAR_I' '$VAR_J'"
        echo "su $VAR_B -c \"./tekbase 9 '$VAR_C' '$VAR_D' '$VAR_E' '$VAR_F' '$VAR_G' '$VAR_H' '$VAR_I' '$VAR_J'\"" >> $LOGP/logs/tekbase2
    ;;
    34)
        ps aux | grep -i apache | awk '{printf ($1"%TD%);
        for(i=11;i<=NF;i++) {
	    printf("%s ", $i);
        }
        printf("\n") }'
    ;;
    35)
	cd /home
	for MEMBER in $(ls -d */ | sed 's#/##')
	do
	    if [ -d $MEMBER/$VAR_B ]; then
	        cd /home/$MEMBER/$VAR_B
		for SERVER in $(ls -d */ | sed 's#/##')
		do
		    quota=$(du -s | awk '{print $1}')
		    wget --post-data 'op=softlimit&key='$VAR_C'&member='$MEMBER'&typ='$VAR_B'&path='$SERVER'&quota='$quota'' -O - $VAR_D/automated.php
		done
		cd /home
	    fi
	done
    ;;
esac


exit 0
