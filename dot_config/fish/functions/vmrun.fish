############################ QEMU VM Run Script ##################################
# 
# This script runs an existing QEMU virtual machine with high-performance settings.
# It validates the disk image file and display backend before launching the VM.
#
# Usage: ./run.fish <image-file> <display-backend>
# 
# Arguments:
# - image-file: Path to the qcow2 disk image file (must have .qcow2 extension)
# - display-backend: Display backend to use (valid values: gtk, sdl)
#
# Features:
# - High-performance configuration with 12 CPU cores and 16GB RAM
# - Memory backend optimization for better performance
# - PipeWire audio support with virtio model
# - USB tablet for better mouse integration
# - GPU acceleration with OpenGL support
# - VHost conncetion enabled
#
# Examples: 
# ./run.fish /path/to/ubuntu-22.04.qcow2 gtk
# ./run.fish /mnt/vms/cachyos-desktop-linux-260124.qcow2 sdl
##################################################################################

function vmrun
    # Check if both arguments are provided
    if test (count $argv) -ne 2
        echo "Error: Invalid number of arguments."
        echo "Usage: $(status -f) <image-file> <display-backend>"
        echo ""
        echo "Arguments:"
        echo "  image-file      Path to qcow2 disk image (must end with .qcow2)"
        echo "  display-backend Display backend (gtk or sdl)"
        echo ""
        echo "Examples:"
        echo "  $(status -f) /path/to/vm.qcow2 gtk"
        echo "  $(status -f) /path/to/vm.qcow2 sdl"
        exit 1
    end

    set image $argv[1]
    set display $argv[2]

    # Validate image file path existence
    if not test -f $image
        echo "Error: Image file '$image' not found."
        exit 1
    end

    # Validate image file extension (.qcow2)
    if not string match -q "*.qcow2" $image
        echo "Error: Image file must have .qcow2 extension."
        echo "Provided: $image"
        exit 1
    end

    # Validate display backend (gtk or sdl)
    if not contains $display gtk sdl
        echo "Error: Invalid display backend '$display'."
        echo "Valid values: gtk, sdl"
        exit 1
    end

    echo "Starting QEMU VM..."
    echo "Image: $image"
    echo "Display: $display"

    # Launch QEMU with validated parameters
    qemu-system-x86_64 \
        -accel kvm \
        -M q35 \
        -cpu host \
        -smp 12,cores=6,threads=2,sockets=1 \
        -m 16G \
        -object memory-backend-memfd,id=mem1,size=16G,share=on,prealloc=on \
        -machine memory-backend=mem1 \
        -nic user,ipv6=off \
        -device vhost-vsock-pci,id=vhost-vsock-pci0,guest-cid=555 \
        -device virtio-vga-gl \
        -display $display,gl=on \
        -audio pipewire,model=virtio \
        -usb -device usb-tablet \
        -hda $image \
        -full-screen
end
