# cpplib

## Environment settings

For Ubuntu:

```bash
# for build tools
sudo apt-get install -y build-essential cmake cmake-curses-gui
# for basic libraries
sudo apt-get install -y libboost-all-dev

mkdir build && cd build
cmake ..
make -j$(nproc)
```
