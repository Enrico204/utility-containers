This is an asterisk version with a fix for the Raspberry Pi bluetooth module (for the `chan_mobile` addon).

The device frame used in the Raspberry Pi bluetooth is different than the one assumed in the addon.

The manual fix may be applied also:

```sh
sed -i 's/DEVICE_FRAME_SIZE 48/DEVICE_FRAME_SIZE 60/' asterisk-20.5.2/addons/chan_mobile.c
```
