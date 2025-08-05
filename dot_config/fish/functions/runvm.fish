function runvm
    # Runs a virtual machine

    if test (count $argv) -ne 1
        echo "Usage: $(status basename) <VM_NAME>"
        return 1
    end

    set IMG_PATH "~/vm/img/$argv.qcow2"

    qemu-system-x86_64 -hda $IMG_PATH \
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
