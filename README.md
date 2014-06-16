
XivelyRead
==========
An example of how to read a [Xively](https://xively.com/) feed from MATLAB. Xively promotes the IoT (Internet of Things) provinding a platform for easily uploading and accessing data. There are libraries for a variety of languages, but apparently not for MATLAB. However, they offer a [REST API](https://xively.com/dev/docs/api/).

### Requirements  
Assuming that you have read the API docs and got a master key with reading permissions, you can access any public feed along with your own private feeds. In order to use the key, save it in a matfile like this:

```matlab
key = 'YOUR_KEY_HERE';
save('key.mat','key');
```

The script can work as standalone, but I've used two libraries from the MathWorks Matlab Central which you can either download (their URLs are included in the source) or disable.

> Tip: Browse [Thingful](http://thingful.net/) for relevant feeds near you!

### Example result
This example script gets CPU load and CPU temperature from a Raspberry Pi (you can see a tutorial on how to connect a Pi to Xively [here](https://xively.com/dev/tutorials/pi/)) and uses it to plot a figure of the increasing of temperature over time, taking into account only datapoints where the CPU load was low:

<p align="center">
 <img src="http://i.imgur.com/CWEjYst.png" alt="Result"/>
</p>

### Licensing
This script is licensed under GPL v3.