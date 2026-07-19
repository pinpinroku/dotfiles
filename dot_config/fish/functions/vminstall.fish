#################### QEMU VM Installation Script #############################
#
# This script creates a new QEMU virtual machine for OS installation.
# It automatically generates a qcow2 disk image from the provided ISO filename
# and launches QEMU with appropriate settings for installation.
#
# Usage: ./install.fish <iso-file>
#
# Features:
# - Automatically creates a 50GB qcow2 disk image in the `/mnt/vms/`
# - Uses KVM acceleration for better performance
# - Configured with 6 CPU cores and 8GB RAM for smooth installation
# - Enables GPU acceleration with virtio-vga
# - Runs in fullscreen mode for better user experience
#
# Example: ./install.fish ~/Downloads/ubuntu-22.04.iso
# Creates: /mnt/vms/ubuntu-22.04.qcow2
#
# Note:
# - `/mnt/vms` must exist and is mounted as a subvolume of BTRFS
# - `/mnt/vms` doesn't need to have `nodatacow` attributes but you can ensure
# it by running `sudo chattr +C /mnt/vms/` before creating images
#############################################################################

function vminstall
    # Check if ISO argument is provided
    if test (count $argv) -ne 1
        echo "Usage: $(path basename -E (status -f)) </path/to/image-file.iso>"
        return 1
    end

    set ISO $argv[1]

    # Validate ISO file exists
    if not test -f $ISO
        echo "Error: ISO file '$ISO' not found."
        return 1
    end

    # Generate IMG file path by changing extension from .iso to .qcow2
    set IMG_NAME (basename $ISO | string replace -r '\.iso$' '.qcow2')
    set IMG "/mnt/vms/$IMG_NAME"

    echo "ISO file: $ISO"
    echo "Disk image will be created at: $IMG"

    # Check if the directory is mounted or not
    if not mountpoint -q /mnt/vms
        echo "Error: /mnt/vms is not mounted!"
        return 1
    end

    # Check if IMG file already exists
    if test -f $IMG
        echo "Warning: Disk image '$IMG' already exists."
        echo "Do you want to continue? This will use the existing disk image. (y/N)"
        read -P "> " confirm
        if not string match -qi "y*" $confirm
            echo "Aborted."
            return 0
        end
    else
        echo "Creating disk image..."
        qemu-img create -f qcow2 $IMG -o nocow=on 50G
        if test $status -ne 0
            echo "Error: Failed to create disk image."
            return 1
        end
        echo "Disk image created successfully."
    end

    echo "Starting QEMU VM installation..."

    # Execute QEMU with standard installation options
    qemu-system-x86_64 \
        -accel kvm \
        -machine q35 \
        -smp 6 \
        -m 8G \
        -cpu host \
        -nic user,ipv6=off \
        -device virtio-vga-gl \
        -display gtk,gl=on \
        -boot d \
        -cdrom $ISO \
        -drive file=$IMG,if=virtio,format=qcow2 \
        -full-screen
end
