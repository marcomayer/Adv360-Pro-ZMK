update_firmware() {( set -e
    MOUNT_PATH=/Volumes/Adv360Pro
    FIRMEWARE_REPO_PATH=$HOME/private_projects/Adv360-Pro-ZMK

    read -s -k '?Build and update kinesis 360 firmware? (old builds in /firmware will be deleted) any key to continue, CTRL+C to abort)'
    
    pushd $FIRMEWARE_REPO_PATH
    if [ -z "$(ls -A firmware/)" ]; then
        rm firmware/*.uf2
    fi

    make
     
    for side in left right; do
        echo "\nConnect ${side:u} keypad to USB and press MOD 1\n"

        echo "waiting for $MOUNT_PATH to be mounted..."
        while [[ ! -d $MOUNT_PATH ]];do
            echo -n "."
            sleep 1
        done
        
        sleep 3
        cp firmware/*-$side.uf2 $MOUNT_PATH

        echo "\nwaiting for $MOUNT_PATH to be unmounted..."
        while [[ -d $MOUNT_PATH ]]; do
            echo -n "."
            sleep 1
        done

        echo "\n${side:u} keypad successfully updated!\n"
    done

    popd
)}
