function fix --description "Run convmv to normalize all filenames to NFC"
    if not type -q convmv
        echo "convmv is not installed. Please install it first (e.g., sudo apt install convmv)"
        return 1
    end

    convmv -r -f utf-8 -t utf-8 --nfc --notest .
    echo "✅ File and folder names normalized to NFC."
end
