## Virtual Machine ##

# Creates an image
abbr --add qimg 'qemu-img create -f qcow2 img.qcow2 -o nocow=on 50G'

# Runs a virtual machine
function runvm
    set --local VMNAME $argv[1]

    if test -z "$VMNAME"
        set VMNAME cachyos
    end

    set --local IMG "$HOME/vm/$VMNAME/$VMNAME.qcow2"

    qemu-system-x86_64 -hda "$IMG" \
        -M q35 \
        -accel kvm \
        -cpu host \
        -smp cores=6 \
        -m 16G \
        -vga virtio \
        -display sdl,gl=on,show-cursor=on \
        -audio pipewire,model=virtio \
        -nic user,ipv6=off,hostfwd=tcp::8888-:22 \
        -usb -device usb-tablet \
        -object memory-backend-memfd,id=mem1,size=16G \
        -machine memory-backend=mem1 \
        -full-screen
end
