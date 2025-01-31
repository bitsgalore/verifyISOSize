#!/bin/bash

# Create ISO images with different fs layouts
# Dependencies: mkisofs, mkudffs, mkfs.hfsplus 

# Installation directory
instDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Data directory
dataDir="$instDir"/dataTestfiles
# Output directory
outDir="$instDir"/testFiles

echo "ISO 9660 only"
mkisofs -V "ISO9660 only" -J -r -R -o $outDir/iso9660.iso $dataDir/

echo "Hybrid ISO 9660/HFS file system"
mkisofs -V "ISO9660/HFS" -J -r -R -hfs -o $outDir/iso9660_hfs.iso $dataDir/

echo "Hybrid ISO 9660/HFS file system with partition table"
mkisofs -V "ISO9660/HFS/part_table" -J -r -R -hfs -part -o $outDir/iso9660_hfs_part.iso $dataDir/

echo "ISO 9660/HFS file system with Apple extensions"
mkisofs -V "ISO9660/Apple_Extensions" -J -r -R -apple -o $outDir/iso9660_apple.iso $dataDir/

echo "UDF Bridge (ISO 9660 / UDF hybrid)"
mkisofs -V "UDF Bridge" -J -r -R -udf -o $outDir/iso9660_udf.iso $dataDir/

echo "UDF//ISO 9660/HFS hybrid"
mkisofs -V "UDF Bridge" -J -r -R -udf -hfs -part -o $outDir/iso9660_udf_hfs.iso $dataDir/

echo "UDF (empty fs)"
rm $outDir/udf.iso
truncate -s 600K $outDir/udf.iso
mkudffs --media-type=dvd $outDir/udf.iso

echo "HFS (empty fs)"
rm $outDir/hfs.iso
truncate -s 600K $outDir/hfs.iso
mkfs.hfsplus -h -b 2048 -v "HFS" $outDir/hfs.iso

echo "HFS Plus (empty fs)"
rm $outDir/hfsplus.iso
truncate -s 600K $outDir/hfsplus.iso
mkfs.hfsplus -b 2048 -v "HFS_Plus" $outDir/hfsplus.iso

echo "Truncated ISO 9660 file"
cp $outDir/iso9660.iso $outDir/iso9660_trunc.iso
truncate -s 49157 $outDir/iso9660_trunc.iso

echo "ISO 9660 truncated before PVD"
cp $outDir/iso9660.iso $outDir/iso9660_nopvd.iso
truncate -s 32860 $outDir/iso9660_nopvd.iso

