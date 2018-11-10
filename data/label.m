%Import the original classification for check the accuracy. 
%As the part2ofwholedata
label=zeros(length(kddcup),1);
label(find(kddcup=="normal."))=1;
label(find(kddcup=="smurf."))=2;
label(find(kddcup=="neptune."))=3;
label(find(kddcup=="back."))=4;
label(find(kddcup=="satan."))=5;
label(find(kddcup=="ipsweep."))=6;
label(find(kddcup=="portsweep."))=7;
label(find(kddcup=="warezclinet."))=8;
label(find(kddcup=="teardrop."))=9;
label(find(kddcup=="pod."))=10;
label(find(kddcup=="nmap."))=11;
label(find(kddcup=="guess_passwd."))=12;
label(find(kddcup=="buffer_overflow."))=13;
label(find(kddcup=="land."))=14;
label(find(kddcup=="warezmaster."))=15;
label(find(kddcup=="imap."))=16;
label(find(kddcup=="rootkit."))=17;
label(find(kddcup=="loadmodule."))=18;
label(find(kddcup=="ftp_write."))=19;
label(find(kddcup=="multihop."))=20;
label(find(kddcup=="phf."))=21;
label(find(kddcup=="perl."))=22;
label(find(kddcup=="spy."))=23;