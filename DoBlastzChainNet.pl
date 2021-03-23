###INSTALL Parasol and DoBlastzChainNet
#!/bin/bash

 export self=`id -n -u`
 if [ "${self}" = "root" ]; then
   printf "# creating /data/ directory hierarchy and installing binaries\n" 1>&2
   mkdir -p ./data/bin ./data/scripts ./data/genomes ./data/parasol/nodeInfo
   chmod 777 ./data ./data/genomes ./data/parasol ./data/parasol/nodeInfo
   chmod 777 ./data/bin ./data/scripts
   rsync -a rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/ ./data/bin/
   yum -y install wget
   wget -qO ./data/parasol/nodeInfo/nodeReport.sh 'http://genomewiki.ucsc.edu/images/e/e3/NodeReport.sh.txt'
   chmod 755 ./data/parasol/nodeInfo/nodeReport.sh
   wget -qO ./data/parasol/initParasol 'http://genomewiki.ucsc.edu/images/4/4f/InitParasol.sh.txt'
   chmod 755 ./data/parasol/initParasol
   git archive --remote=git://genome-source.soe.ucsc.edu/kent.git \
      --prefix=kent/ HEAD src/hg/utils/automation \
        | tar vxf - -C ./data/scripts --strip-components=5 \
      --exclude='kent/src/hg/utils/automation/incidentDb' \
      --exclude='kent/src/hg/utils/automation/configFiles' \
      --exclude='kent/src/hg/utils/automation/ensGene' \
      --exclude='kent/src/hg/utils/automation/genbank' \
      --exclude='kent/src/hg/utils/automation/lastz_D' \
      --exclude='kent/src/hg/utils/automation/openStack'
   wget -O ./data/bin/bedSingleCover.pl 'http://genome-source.soe.ucsc.edu/gitlist/kent.git/raw/master/src/utils/bedSingleCover.pl' 

echo 'export PATH=/home/alexandre/data/bin:/home/alexandre/data/scripts:$PATH' >> /home/alexandre/.bashrc
. $HOME/.bashrc

./data/parasol/nodeInfo/nodeReport.sh 2 /home/alexandre/data/parasol/nodeInfo  ## change path (data/parasol) to whole path
./data/parasol/initParasol initialize
cd /data/parasol
./initParasol start
./initParasol stop

##add /home/alexandre/data/bin : /home/alexandre/data/scripts to the shell PATH! check that it work. Here, added PATH to the environment file. 
###quite complicated to work. Remove subcmd and add full path to the commands
##########
###convert fna to 2bit
 
#baobab
#gruezi
cd /home/alexandre/data/bin
./faToTwoBit ../genomes/dm6/trackData/GCF_000005575.2_AgamP3/GCF_000005575.2_AgamP3_genomic.fna.gz ../genomes/dm6/trackData/GCF_000005575.2_AgamP3/GCF_000005575.2_AgamP3.2bit
./twoBitInfo ../****.2bit *****.chrom.sizes




##start the pipeline
###the DEF File needs to be changed for each genome (only Query is changing as we align with zebrafish as reference)
##remove psl folder
## change species name in do.log.SPECIES

cd ~/data
rm -r psl
cd ~/data/parasol
./initParasol start 
screen
time (/home/alexandre/data/scripts/doBlastzChainNet.pl /home/alexandre/data/genomes/ch.catfish/DEF -verbose=2 -noDbNameCheck -workhorse=localhost -bigClusterHub=localhost --blastzOutRoot /home/alexandre/data/genomes/ch.catfish -skipDownload -dbHost=localhost -smallClusterHub=localhost -trackHub -fileServer=localhost -swapDir=/home/alexandre/data/blastz.targetDb.swap/ -syntenicNet) > do.log.ch.catfish
 
 
 
 ###multiple
 
 roast + E=zebra "(((zebra) amber) guppy)" *.*.sing maf 3spec.maf

