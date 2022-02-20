# MarineAhoyGB
Game Boy ROM to play [Ahoy!! 我ら宝鐘海賊団 by Houshou Marine](https://youtu.be/e7VK3pne8N4).  
Uses my custom .vgm playback engine [Deflemask GBVGM](https://github.com/Pegmode/Deflemask-GB-Engine) for music playback and event timing.  

Download the .gb ROM [HERE](https://github.com/Pegmode/MarineAhoyGB/releases/download/1.0/ahoyGB.gb)

<img src="https://raw.githubusercontent.com/Pegmode/MarineAhoyGB/main/doc/preview1.gif" width="500"/>\
[Full emulator video recording](https://youtu.be/1-DEiKUNUCk)\
[Full hardware video recording](https://youtu.be/bS_inEQkhss)  

Code and GB music by Pegmode  
Art by [Gaplan](https://twitter.com/Gaplan1337)

## Build instructions
Make sure [RGBDS](https://github.com/gbdev/rgbds) is unpacked into the projects root directory.  
To build run `buildDesktop.bat`. You will need to edit the path under bgb in `buildDesktop.bat` to match your [BGB](https://bgb.bircd.org/)
path. It does not have to be the 64-bit version. 


### Build requirements
* windows only build script
* requires [RGBDS 0.5.0](https://github.com/gbdev/rgbds/releases/tag/v0.5.0)  
* build script uses [BGB](https://bgb.bircd.org/)  
