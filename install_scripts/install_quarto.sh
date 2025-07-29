# break if R not installed
if ! command -v R &> /dev/null; then
    echo "R is not installed. Please install R before running this script."
    exit 1
fi