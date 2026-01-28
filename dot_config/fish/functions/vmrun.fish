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
# - SSH port forwarding (host:8888 -> guest:22)
# - PipeWire audio support with virtio model
# - USB tablet for better mouse integration
# - GPU acceleration with OpenGL support
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

    # -vga virtio \
    # Launch QEMU with validated parameters
    qemu-system-x86_64 \
        -accel kvm \
        -M q35 \
        -smp cores=12 \
        -m 16G \
        -cpu host \
        -nic user,ipv6=off,hostfwd=tcp::8888-:22 \
        -device virtio-vga-gl \
        -display $display,gl=on \
        -audio pipewire,model=virtio \
        -usb -device usb-tablet \
        -object memory-backend-memfd,id=mem1,size=16G \
        -machine memory-backend=mem1 \
        -hda $image \
        -full-screen
end
