#!/usr/bin/perl

$NODE="node119.html";

@titles = ( "ext2-defrag", "bootdisk-howto", "network-admin-guide", "fsstnd-1.2", "device-list" );

%titles={

'ext2-defrag'         , 'Linux filesystem defragmenter',
'bootdisk-howto'      , 'Bootdisk HOWTO',
'network-admin-guide' , 'Linux Network Administrators\' Guide',
'fsstnd-1.2'          , 'Linux Filesystem Structure---Release 1.2',
'device-list'         , 'Linux Device List'

};
# %titles={

# 'ext2-defrag'         => 'Linux filesystem defragmenter',
# 'bootdisk-howto'      => 'Bootdisk HOWTO',
# 'network-admin-guide' => 'Linux Network Administrators\' Guide',
# 'fsstnd-1.2'          => 'Linux Filesystem Structure---Release 1.2',
# 'device-list'         => 'Linux Device List'

# };

#@titles{'ext2-defrag'} = "foo";

for $item ( @titles ) {
    print $item, "\n";
    print @titles { $item }, "\n";
}

# s/[#!ext2-defrag!#]/<a href="$NODE  Linux filesystem defragmenter
# [#!bootdisk-howto!#] "Bootdisk HOWTO"
# [#!network-admin-guide!#] "Linux Network Administrators' Guide"
# [#!fsstnd-1.2!#] "Linux Filesystem Structure---Release 1.2"
# [#!device-list!#] "Linux Device List"
