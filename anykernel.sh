# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
eval $(cat $home/props | grep -v '\.')


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
#set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 750 750 $ramdisk/*;


## AnyKernel install
dump_boot;

# migrate from /overlay to /overlay.d to enable SAR Magisk
if [ -d $ramdisk/overlay ]; then
  rm -rf $ramdisk/overlay;
fi;

# use custom kernel compression
kernel_compression=gzip;
kernel_comp_ext=gz;


# combine kernel image and dtbs if separated in the zip
if [ ! -e $home/Image.gz-dtb ]; then
  # Change skip_initramfs to want_initramfs if Magisk is detected
  IMAGE=$home/Image;
  if [ ! -e $IMAGE ]; then
    gzip -dc < ${IMAGE}.gz > $IMAGE;
  fi
  if [ -d $ramdisk/.backup ]; then
    sed -i -e 's/skip_initramfs/want_initramfs/g' $IMAGE;
    gzip -9 < $IMAGE > ${IMAGE}.gz;
  fi

  if [ ! -e ${IMAGE}.gz ]; then
    gzip -9 < $IMAGE > ${IMAGE}.gz;
  fi

  cat ${IMAGE}.gz $home/dtbs/*.dtb > $home/Image.gz-dtb;
  rm $IMAGE ${IMAGE}.gz;
fi

write_boot;
## end install

