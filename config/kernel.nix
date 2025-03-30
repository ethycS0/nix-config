{ pkgs, ... }:
{

  boot = {

    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.lib.mkDefault (
      let
        fedora-asus-kernel =
          { buildLinux, ... }@args:
          buildLinux (
            args
            // rec {
              version = "6.13.7";
              extraMeta.branch = "6.13";
              modDirVersion = version;

              src = pkgs.stdenv.mkDerivation rec {
                name = "linux-source";
                inherit version;

                # - [lukenukem/asus-kernel](https://copr.fedorainfracloud.org/coprs/lukenukem/asus-kernel/package/kernel/)
                # - [/results/lukenukem/asus-kernel/fedora-40-x86_64/07623253-kernel/](https://download.copr.fedorainfracloud.org/results/lukenukem/asus-kernel/fedora-40-x86_64/07623253-kernel/)
                # - [kernel build logs](https://download.copr.fedorainfracloud.org/results/lukenukem/asus-kernel/fedora-40-x86_64/07623253-kernel/builder-live.log.gz)
                src = builtins.fetchurl {
                  url = "https://download.copr.fedorainfracloud.org/results/lukenukem/asus-kernel/fedora-42-x86_64/08791894-kernel/kernel-6.13.7-205.rog.fc42.src.rpm";
                  sha256 = "sha256-EJzSH7a3M4e9z3lHc0oOXoI43LZhI1c2QkTu5Ommfb0=";
                };

                phases = [
                  "unpackPhase"
                  "patchPhase"
                ];
                unpackPhase = ''
                  		  ${pkgs.rpm}/bin/rpm2cpio $src | ${pkgs.cpio}/bin/cpio -idmv

                  		  mkdir $out
                  		  mv ./* $out
                  		  cd $out
                  		  tar -xf $out/linux-${version}.tar.xz --strip-components 1 -C $out/.
                  		'';

                patchPhase = ''
                  		  # apply all patches
                  		  # ${pkgs.fd}/bin/fd -t f -e patch . > ./patches.txt
                  		  patch -p1 -F50 < ./patch-6.11-redhat.patch
                  		  patches=$(grep "^ApplyOptionalPatch " ./kernel.spec | grep -v "{patchversion}" | cut -d " " -f2)
                  		  for patch in $patches; do
                  		    patch -p1 -F50 < ./$patch
                  		  done

                  		  # ./Makefile.rhelver is not included in the kernel.dev package. so make sure it is not needed at all
                  		  # inject RHEL stuff directly into the makefile
                  		  cd $out
                  		  var1="# Set RHEL variables"
                  		  TOTAL_LINES=`cat ./Makefile | wc -l`
                  		  BEGIN_LINE=`grep -n -e "$var1" ./Makefile | cut -d : -f 1`
                  		  BEGIN_LINE=$(($BEGIN_LINE - 1))
                  		  TAIL_LINES=$(($TOTAL_LINES - $BEGIN_LINE - 11))

                  		  head -n $BEGIN_LINE ./Makefile > ./Makefile2
                  		  cat ./Makefile.rhelver >> ./Makefile2
                  		  tail -n $TAIL_LINES ./Makefile >> ./Makefile2
                  		  mv ./Makefile2 ./Makefile
                  		'';
              };

              structuredExtraConfig = with lib.kernel; {
                HID_ASUS_ALLY = module;
                ASUS_ARMOURY = module;
                ASUS_WMI_BIOS = yes;
              };

            }
            // (args.argsOverride or { })
          );
        linux_g14 = pkgs.callPackage fedora-asus-kernel { };
      in
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_g14)
    );

  };

}
