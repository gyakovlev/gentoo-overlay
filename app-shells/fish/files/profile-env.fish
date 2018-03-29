# since fish supports export via  upstream provided function
# we can source directly, only ommiting $PATH and comments.
egrep -v "#|PATH|ROOTPATH" /etc/profile.env  | source

# strip unneded stuff from bash export lines
# apply paths
# and cleanup
if [ "$EUID" = "0" ] ; or [ "$USER" = "root" ]
	set _rootpath (egrep  " ROOTPATH" /etc/profile.env | sed "s/export PATH=//;s/:/\n/g;s/'//g")
    set -xg PATH /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin $_rootpath
    set -e _rootpath
else
	set _userpath (egrep  " PATH" /etc/profile.env | sed "s/export PATH=//;s/:/\n/g;s/'//g")
    set -xg PATH /usr/local/bin /usr/bin /bin $_userpath
    set -e _userpath
end



